-----------------------------------------------------------------------------------------
--
-- level.lua
--
-----------------------------------------------------------------------------------------

local configReader = require("classes.utils.config_reader");

-- game classes
local blankTowerClass = require("classes.game_classes.blank_tower");
local resourcesClass = require("classes.game_classes.resources");
local towerClass = require("classes.game_classes.tower");
local waveClass = require("classes.game_classes.wave");
local securedZoneClass = require("classes.game_classes.secured_zone");

local levelClass = {};

levelClass = {
	towers = {},
	blankTowers = {},
	waves = {},
	dialogs = {},

	securedZones = {},

	nextWaveButtons = {},

	time = 0;

	backgroundImage = {},
	levelConfig = {}
};

-- entry point
function levelClass:readConfig(configPath)
	self.levelConfig = configReader.readLevelConfig(configPath);

	local levelParams = self.levelConfig["params"];

	-- init background
	self:initMainDisplay( levelParams["background"] );

	-- init resources
	-- FIMME - 10 must be real waves number
	self:initResources( levelParams["level_resources"], self.levelConfig["static_resources_conf"]["resources"], 
		-- number of waves
		#self.levelConfig["waves_conf"]["waves"] );

	-- init blank towers
	self:initBlankTowes( levelParams["blanks_towers"], self.levelConfig["static_towers_conf"] );

	-- init towers
	self:initTowers( levelParams["towers"], self.levelConfig["static_towers_conf"] );

	-- init secured zone
	self:initSecuredZone( levelParams["secured_zones"] );

	-- init waves
	self:initWaves( self.levelConfig["waves_conf"]["waves"], self.levelConfig["static_units_conf"], levelParams["paths"] );

	-- global listeners initialization
	self:listen();
end

-- builder
function levelClass:initMainDisplay(imagePath)
	self.backgroundImage = display.newImage(imagePath, 450, 400);
	self.backgroundImage:toBack();

	-- BEGIN - DEBUG ONLY

	local function onObjectTouch( event )
		print("x = [ " .. event.x .. " ], y = [ " .. event.y .. " ]");
	end

	self.backgroundImage:addEventListener("touch", onObjectTouch);

	-- END - DEBUG ONLY
end

function levelClass:initResources(levelResources, staticResources, wavesNumber)
	levelResources["static"] = staticResources;
	levelResources["waves_total"] = wavesNumber;

	resourcesClass:init(levelResources);
end

function levelClass:initBlankTowes(blankTowersConfig, staticTowersConfig)
	local staticBlankTowerConfig = staticTowersConfig["blank_tower"];

	local tmpBlankTower = nil;
	for i, blankTower in ipairs(blankTowersConfig) do
		tmpBlankTower = blankTowerClass.new(staticBlankTowerConfig, self);

		tmpBlankTower:setDisplayPosition(blankTower["x"], blankTower["y"]);

		table.insert(self.blankTowers, tmpBlankTower);
	end
end

function levelClass:initTowers(towersConfig, staticTowersConfig)
	local staticTowersConfig = staticTowersConfig;

	local tmpTower = nil;
	for i, tower in pairs(towersConfig) do
		tmpTower = towerClass.new(towersConfig["type"], staticTowersConfig[ tower["type"] ], self );

		tmpTower:setTowerPosition( tower["x"], tower["y"] );

		table.insert(self.towers, tmpTower);
	end
end

function levelClass:initWaves(wavesConfig, unitsConfig, levelPaths)
	local tmpWave = nil;

	for i, currWaveCfg in pairs(wavesConfig) do
		currWaveCfg["static_units"] = unitsConfig;
		currWaveCfg["levelPaths"] = levelPaths;

		tmpWave = waveClass.new(currWaveCfg, self);

		table.insert(self.waves, tmpWave);
	end
end

function levelClass:initSecuredZone(zonesConfig)
	local tmpZone = nil;
	for i, currZoneConfig in pairs(zonesConfig) do
		tmpZone = securedZoneClass.new(currZoneConfig);
		table.insert(self.securedZones, tmpZone);
	end
end

-- behaviour
function levelClass:touch(event)
	for i, currBlankTower in pairs(levelClass.blankTowers) do
		currBlankTower:hideMenu();
	end

	for i, currTower in pairs(levelClass.towers) do
		currTower:hideMenu();
	end

	return true;
end

function levelClass:checkWavesQueue(tick)

end

function levelClass:cleanWaves()
end

function levelClass:cleanTowers()
end

function levelClass:cleanBlankTowers()
end

function levelClass:checkInUnitInSecuredZone(x, y)
	for i, currZone in pairs(self.securedZones) do
		if (currZone:isObjectInZone(x, y)) then
			return true;
		end
	end
end

function levelClass:dicreaseHealth()
	resourcesClass:decreaseHealth();
end

function levelClass:onTick()
	self.time = self.time + 0.01;

	self:objectsMovments();

	-- TODO: thinks about proper timing implementation
	-- bezier constant
	-- FIXME: advanced threshold calculation
	if (self.time > 1.2) then
		self.time = 0;
	end
end

function levelClass:listen()
	local gameField = self;

	self.backgroundImage.touch = function (self, event)
		gameField.touch(self, event);
	end

	self.backgroundImage:addEventListener("touch");
end

function levelClass:checkResourcesBuild(type)
	return resourcesClass:checkResourcesBuild(type);
end

function levelClass:checkResourcesUpgrade(type, level)
	return resourcesClass:checkResourcesForUpgrade(type, level);
end

function levelClass:upgradeTower(type, level)
	resourcesClass:buildOrUpgradeTower(type, level);
end

function levelClass:upgradeCharacteristics(type, level)
	return resourcesClass:upgradeCharacteristics(type, level);
end

function levelClass:sellTower(tower, type, level)
	-- FIXME double click workaround
	if (tower.towerGroup ~= nil) then
		resourcesClass:sellTower(type, level);

		self:putBlankTower(tower.towerGroup.x, tower.towerGroup.y);

		tower:destroyTower();
	end
end

function levelClass:putBlankTower(x, y)
	local tmpBlankTower = blankTowerClass.new(self.levelConfig["static_towers_conf"]["blank_tower"], self);

	tmpBlankTower:setDisplayPosition(x, y);

	table.insert(self.blankTowers, tmpBlankTower);
end

function levelClass:buildTower(blankTower, event, type)
	-- FIXME double click workaround
 	if (blankTower.blankTowerGroup ~= nil) then
	 	local bt_x = blankTower.blankTowerGroup.x;
	 	local bt_y = blankTower.blankTowerGroup.y;

		blankTower:destroyBlankTower();
		blankTower = nil;

		self:buildNewTower(type, bt_x, bt_y);
	end

	return true;
end

function levelClass:buildNewTower(type, x, y)
	local static_towers_conf = self.levelConfig["static_towers_conf"][type];
	local newTower = towerClass.new(type, static_towers_conf, self);

	resourcesClass:buildOrUpgradeTower(type, "1");

	newTower:setTowerPosition(x, y);

	table.insert(self.towers, newTower);
end

function levelClass:objectsMovments()
	-- waves movements
	for i, currWave in ipairs(self.waves) do
		currWave:calculateWaveMovement(self.time, path);
	end

	-- towers rotation
	for i, currTower in ipairs(self.towers) do
		currTower:calculateRotation(self.time);
	end

	-- shots

end

return levelClass;


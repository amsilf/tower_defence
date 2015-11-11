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

local bulletsPoolClass = require("classes.game_classes.bullets_pool");

local securedZoneClass = require("classes.game_classes.secured_zone");
local newWaveButtonClass = require("classes.game_classes.next_wave_button");

local levelClass = {};

levelClass = {
	towers = {},
	blankTowers = {},
	waves = {},
	dialogs = {},

	securedZones = {},

	nextWaveButtons = {},

	bezierTime = 0,
	
	absTime = 1,

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

	-- init next wave buttons
	-- FIXME: set up config
	self:initNextWavesButtons(nil, levelParams["paths"]);

	-- set level to bullets pool
	-- TODO think about passing level
	bulletsPoolClass.setLevel(self);

	-- init waves timer
	-- function - levelClass:timer
	timer.performWithDelay(100, self, 0);

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

function levelClass:initSecuredZone(zonesConfig)
	local tmpZone = nil;
	for i, currZoneConfig in pairs(zonesConfig) do
		tmpZone = securedZoneClass.new(currZoneConfig);
		table.insert(self.securedZones, tmpZone);
	end
end

function levelClass:initNextWavesButtons(nextWaveButtonConfig, paths)
	tmpButton = nil;
	tmpStartEnd = nil;
	for pathId, currPath in pairs(paths) do
		tmpStartEnd = currPath["start_end_points"];

		tmpButton = newWaveButtonClass.new(nextWaveButtonConfig, self, pathId);
		tmpButton:setPosition(tmpStartEnd["start_x"], tmpStartEnd["start_y"]);

		table.insert(self.nextWaveButtons, tmpButton);
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

function levelClass:timer(event)
	
	local levelWaves = self.levelConfig["waves_conf"]["waves"];

	table.sort(levelWaves, waveClass.compareWavesByTime);

	-- wave movments
	for i, currWave in pairs(levelWaves) do
		if ( currWave["abs_time"] == self.absTime ) then
			local newWave = self:createWave(currWave, self.levelConfig["static_units_conf"], self.levelConfig["params"]["paths"]);

			-- faked filed to distingiush active and future waves
			currWave["is_active"] = "true";

			-- release button
			for i, currButton in pairs(self.nextWaveButtons) do
				if (currButton.nextWaveId == currWave["id"]) then
					currButton.nextWaveId = nil;
				end
			end

			resourcesClass:increaseWavesCounter();
		end

		for i, currButton in pairs(self.nextWaveButtons) do
			-- link wave and button
			if (currButton.pathId == currWave.path and currWave["is_active"] == nil and currButton.nextWaveId == nil) then
				currButton:setNextWaveId( currWave["id"] );
			end

			if (currButton.nextWaveId ~= nil and currButton.nextWaveId == currWave["id"]) then
				currButton:updateTime(currWave["abs_time"] - self.absTime);
			end
		end
	end

	-- towers shots
	for i, currTower in pairs(self.towers) do
		currTower:checkAndDoShot(self.absTime);
	end

	self.absTime = self.absTime + 1;
end

-- required for next wave functionality
function levelClass:createWaveById(id)
	local levelWaves = self.levelConfig["waves_conf"]["waves"];

	for i, currWave in pairs(levelWaves) do
		if (currWave.id == id and currWave["is_active"] ~= "dead") then
			local waveWithId = self:createWave(currWave, self.levelConfig["static_units_conf"], self.levelConfig["params"]["paths"]);

			waveWithId.absTime = self.absTime;

			-- wave config marked and can't be reused
			currWave["is_active"] = "dead";

			break;
		end
	end
end

function levelClass:createWave(waveConfig, unitsConfig, levelPaths)
	local tmpWave = nil;

	waveConfig["static_units"] = unitsConfig;
	waveConfig["levelPaths"] = levelPaths;

	tmpWave = waveClass.new(waveConfig, self);

	table.insert(self.waves, tmpWave);

	return tmpWave;
end

-- FIXME: proper wave cleaning - doesn't work properly now!
function levelClass:cleanWaves()
	for i, currWave in pairs(self.waves) do
		if (currWave.units == nil) then
			table.remove(self.waves, i);
		end
	end
end

function levelClass:cleanTowers()
	for i, currTower in pairs(self.towers) do
		if (currTower.towerGroup == nil) then
			table.remove(self.towers, i);
		end
	end
end

function levelClass:cleanBlankTowers()
	for i, currBlankTower in pairs(self.blankTowers) do
		if (currBlankTower.towerGroup == nil) then
			table.remove(self.blankTowers, i);
		end
	end
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
	self.bezierTime = self.bezierTime + 0.01;

	self:objectsMovments();

	-- TODO: thinks about proper timing implementation
	-- bezier constant
	-- FIXME: advanced threshold calculation
	if (self.bezierTime > 1.2) then
		self.bezierTime = 0;
	end
end


function levelClass:handleHits(waveId, unitId, bulletParams)
	for i, currWave in pairs(self.waves) do
		if (currWave.id == tonumber(waveId)) then
			currWave:handleHit(unitId, bulletParams);
			return;
		end
	end
end

function levelClass:listen()
	local gameField = self;

	self.backgroundImage.touch = function (self, event)
		gameField.touch(self, event);
	end

	-- for objects reset
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
		self:cleanTowers();
	end
end

function levelClass:doTowerShot(tower)
	bulletsPoolClass:shot(tower);
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

		self:cleanBlankTowers();

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

function levelClass:getClosestUnitForTower(tower)
	-- waves haven't been initialzed or tower already has an aim
	if (self.waves == nil or tower.aim ~= nil) then
		return;
	end

	local tmpUnitDist = nil;	
	local closestUnitDist = {
		dist = 10000,
		unit = nil
	};

	for i, currWave in pairs(self.waves) do
		tmpUnitDist = currWave:getClosestUnitToPoint(tower.towerGroup.x, tower.towerGroup.y);

		if (closestUnitDist.dist > tmpUnitDist.dist) then
			closestUnitDist = tmpUnitDist;
		end
	end

	return closestUnitDist;
end

function levelClass:unitDestroyed(type)
	resourcesClass:addCreditsForDestroyedUnit(type);
end

function levelClass:objectsMovments()
	-- waves movements
	for i, currWave in ipairs(self.waves) do
		currWave:calculateWaveMovement(self.bezierTime, path);
	end

	-- towers rotation and shots
	for i, currTower in ipairs(self.towers) do
		currTower:setAim();
		currTower:towerRotation(self.bezierTime);
	end

end

return levelClass;


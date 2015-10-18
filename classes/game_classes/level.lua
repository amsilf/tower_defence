-----------------------------------------------------------------------------------------
--
-- level.lua
--
-----------------------------------------------------------------------------------------

local configReader = require("config_reader");

-- game classes
local blankTowerClass = require("classes.game_classes.blank_tower");
local resourcesClass = require("classes.game_classes.resources");
local towerClass = require("classes.game_classes.tower");
local waveClass = require("classes.game_classes.wave");

local levelClass = {};

levelClass = {
	towers = {},
	blankTowers = {},
	waves = {},
	resources = {},
	dialogs = {},

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
	self:initResources( levelParams["level_resources"], self.levelConfig["static_resources_conf"]["resources"], 10 );

	-- init blank towers
	self:initBlankTowes( levelParams["blanks_towers"], self.levelConfig["static_towers_conf"] );

	-- init towers
	self:initTowers( levelParams["towers"], self.levelConfig["static_towers_conf"] );

	-- init waves
	self:initWaves( self.levelConfig["waves_conf"]["waves"], self.levelConfig["static_units_conf"], levelParams["paths"] );

	-- global listeners initialization
	self:listen();
end

-- builder
function levelClass:initMainDisplay(imagePath)
	self.backgroundImage = display.newImage(imagePath, 450, 400);
	self.backgroundImage:toBack();
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
		tmpBlankTower = blankTowerClass.new( staticBlankTowerConfig, self);

		tmpBlankTower:setDisplayPosition( blankTower["x"], blankTower["y"] );

		table.insert(self.blankTowers, tmpBlankTower);
	end
end

function levelClass:initTowers(towersConfig, staticTowersConfig)
	local staticTowersConfig = staticTowersConfig;

	local tmpTower = nil;
	for i, tower in pairs(towersConfig) do
		tmpTower = towerClass.new( staticTowersConfig[ tower["type"] ], self );

		tmpTower:setTowerPosition( tower["x"], tower["y"] );

		table.insert(self.towers, tmpTower);
	end
end

function levelClass:initWaves(wavesConfig, unitsConfig, levelPaths)
	local tmpWave = nil;

	for i, currWaveCfg in pairs(wavesConfig) do
		currWaveCfg["static_units"] = unitsConfig;
		currWaveCfg["levelPaths"] = levelPaths;

		tmpWave = waveClass.new(currWaveCfg);

		table.insert(self.waves, tmpWave);
	end
end

-- behaviour
function levelClass:resetFieldElements()

end

function levelClass:touch(event)
	
end

function levelClass:checkWavesQueue(tick)

end

-- the name must be timer
-- https://docs.coronalabs.com/api/library/timer/performWithDelay.html
function levelClass:onTick()
	self.time = self.time + 0.01;

	self:objectsMovments();

	-- TODO: thinks about proper timing implementation
	-- bezier constant
	if (self.time > 1) then
		self.time = 0;
	end
end

function levelClass:listen()
	local gameField = self;

	self.backgroundImage.touch = function (self, event) 
		gameField.touch(event);
	end

	self.backgroundImage:addEventListener("touch");
end

function levelClass:checkResourcesBuild(type)
	return resourcesClass:checkResourcesBuild(type);
end

function levelClass:buildTower(blankTower, event, type)
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
	local newTower = towerClass.new(static_towers_conf, self);

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


-----------------------------------------------------------------------------------------
--
-- level.lua
--
-----------------------------------------------------------------------------------------

local configReader = require("config_reader");

-- game classes
local blankTowerClass = require("classes.game_classes.blank_tower");
local resourcesClass = require("classes.game_classes.resources");

-- for test
local gameObjects = require("game_objects");

local towerClass = game_objects["tower"];

local levelClass = {};

levelClass = {
	towers = {},
	blankTowers = {},
	waves = {},
	resources = {},
	dialogs = {},

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
	self:initResources( levelParams["level_resources"], self.levelConfig["static_resources"]["resources"], 10 );

	-- init blank towers
	self:initBlankTowes( levelParams["blanks_towers"], self.levelConfig["towers_conf"] );

	-- init towers
	self:initTowers( levelParams["towers"], self.levelConfig["static_towers"] );

	-- init waves
	self:initWaves(self.levelConfig["waves"]);

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
	local commonBlankTowerConfig = staticTowersConfig["blank_tower"];

	local tmpBlankTower;
	for i, blankTower in ipairs(blankTowersConfig) do
		tmpBlankTower = blankTowerClass.new( commonBlankTowerConfig, self );

		tmpBlankTower:setDisplayPosition(blankTower["bt_x"], blankTower["bt_y"]);
		tmpBlankTower:setId(blankTower["id"]);

		table.insert(self.blankTowers, tmpBlankTower);
	end
end

function levelClass:initTowers(towersConfig, staticTowersConfig)

end

function levelClass:initWaves(wavesConfig)
end

-- behaviour
function levelClass:resetFieldElements()

end

function levelClass:touch(event)
	
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
	local towerParams = self.levelConfig["towers_conf"][type];
	local newTower = towerClass.new();

	newTower.towerGroup.x = x;
	newTower.towerGroup.y = y;

	table.insert(self.towers, newTower);
end

return levelClass;


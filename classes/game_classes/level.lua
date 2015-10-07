-----------------------------------------------------------------------------------------
--
-- level.lua
--
-----------------------------------------------------------------------------------------

local configReader = require("config_reader");

-- game classes
local blankTowerClass = require("classes.game_classes.blank_tower");

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

	-- init blank towers
	self:initBlankTowes( levelParams["blanks_towers"], self.levelConfig["towers_conf"] );

	-- init towers

	-- init waves
end

-- public functions

-- constructor
function levelClass:initMainDisplay(imagePath)
	self.backgroundImage = display.newImage(imagePath, 450, 400);
	self.backgroundImage:toBack();
end

function levelClass:initResources(resourcesConfig)
end

function levelClass:initBlankTowes(blankTowersConfig, commonTowersConfig)
	local commonBlankTowerConfig = commonTowersConfig["blank_tower"];

	local tmpBlankTower;
	for i, blankTower in ipairs(blankTowersConfig) do
		tmpBlankTower = blankTowerClass.new( commonBlankTowerConfig );

		tmpBlankTower:setDisplayPosition(blankTower["bt_x"], blankTower["bt_y"]);

		table.insert(self.blankTowers, tmpBlankTower);
	end
end

function levelClass:initTowers(towersConfig)

end

function levelClass:initWaves(wavesConfig)
end

-- behaviour
function levelClass:resetFieldElements()

end

return levelClass;


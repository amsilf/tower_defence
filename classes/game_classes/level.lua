-----------------------------------------------------------------------------------------
--
-- level.lua
--
-----------------------------------------------------------------------------------------

local configReader = require("config_reader");

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
function levelClass.readConfig(configPath)
	local levelConfig = configReader.readLevelConfig(configPath);

	-- init background

	-- init resources

	-- init towers

	-- init waves
end

-- public functions
function levelClass.resetFieldElements()
end

function levelClass.buildTower(type)

end

-- private functions
local levelClass.initMainDisplay(imagePath)
	
end

return levelClass;
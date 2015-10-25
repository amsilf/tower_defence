	 -----------------------------------------------------------------------------------------
--
-- Reading maps configuration in a following order:
-- - map description
-- - dialogs into the map
-- - waves into the map
-- - units into the waves
--
-----------------------------------------------------------------------------------------
local levelConfigReader={};

function parseJsonToTable(file)

	filePath = system.pathForFile(file);

    local jsonFile = io.open(filePath);

    local content = jsonFile:read("*a");
    
    jsonFile:close();

    local json = require("json");
    return json.decode(content);
end

function levelConfigReader.readLevelConfig(levelConfig)
	if not levelConfig then 
		print("[ERROR] levelConfig is empty!");
		return nil; 
	end

	print("[INFO] Reading [ " .. levelConfig .. " ] map...");

	local levelConfiguration = parseJsonToTable(levelConfig);

	local levelParameters = levelConfiguration["params"];

	-- load related configuration objects

	local unitsConfiguarion = levelParameters["static_units"];
	print("[INFO] Loading units configuration [ " .. unitsConfiguarion .. " ]" );
	levelConfiguration["static_units_conf"] = parseJsonToTable(unitsConfiguarion);	

	local towersConfiguration = levelParameters["static_towers"];
	print("[INFO] Loading towers configuration [ " .. towersConfiguration .. " ]");
	levelConfiguration["static_towers_conf"] = parseJsonToTable(towersConfiguration);

	local resourcesConfiguration = levelParameters["static_resources"];
	print("[INFO] Loading resources configuration [ " .. resourcesConfiguration .. " ]");
	levelConfiguration["static_resources_conf"] = parseJsonToTable(resourcesConfiguration);

	local wavesConfiguration = levelParameters["waves"];
	print("[INFO] Loading waves configuration [ " .. wavesConfiguration .. " ]");
	levelConfiguration["waves_conf"] = parseJsonToTable(wavesConfiguration);

	local dialogsConfiguration = levelParameters["dialogs"];
	print("[INFO] Loading dialogs configuration [ " .. dialogsConfiguration .. " ]");
	levelConfiguration["dialogs_conf"] = parseJsonToTable(dialogsConfiguration);

	print("[INFO] Reading of [ " .. levelConfig .. " ] completed...");

	return levelConfiguration;
end

return levelConfigReader;
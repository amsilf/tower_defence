	 -----------------------------------------------------------------------------------------
--
-- Reading maps configuration in a following order:
-- - map description
-- - dialogs into the map
-- - waves into the map
-- - units into the waves
--
-----------------------------------------------------------------------------------------
local MapConfigReader={};

function parseJsonToTable( file )

	filePath = system.pathForFile(file);

    local jsonFile = io.open(filePath);

    local content = jsonFile:read("*a");
    
    jsonFile:close();

    local json = require("json");
    return json.decode(content);
end

function MapConfigReader.readMapConfig( mapConfig )
	if not mapConfig then 
		print("[ERROR] mapConfig is empty!");
		return nil; 
	end

	print("[INFO] Reading [ " .. mapConfig .. " ] map...");

	local mapConfiguration = parseJsonToTable(mapConfig);

	local mapParameters = mapConfiguration["params"];

	-- load related configuration objects

	local unitsConfiguarion = mapParameters["units"];
	print("[INFO] Loading units configuration [ " .. unitsConfiguarion .. " ]" );
	mapConfiguration["units_conf"] = parseJsonToTable(unitsConfiguarion);	

	local towersConfiguration = mapParameters["towers"];
	print("[INFO] Loading towers configuration [ " .. towersConfiguration .. " ]");
	mapConfiguration["towers_conf"] = parseJsonToTable(towersConfiguration);

	local wavesConfiguration = mapParameters["waves"];
	print("[INFO] Loading waves configuration [ " .. wavesConfiguration .. " ]");
	mapConfiguration["waves_conf"] = parseJsonToTable(wavesConfiguration);

	local dialogsConfiguration = mapParameters["dialogs"];
	print("[INFO] Loading dialogs configuration [ " .. dialogsConfiguration .. " ]");
	mapConfiguration["dialogs_conf"] = parseJsonToTable(dialogsConfiguration);

	print("[INFO] Reading of [ " .. mapConfig .. " ] completed...");

	return mapConfiguration;
end

return MapConfigReader;
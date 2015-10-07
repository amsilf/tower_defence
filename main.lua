-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--local composer = require("composer");
--composer.gotoScene("scenes.main_menu", "zoomInOutFade");

-- global imports
local physics = require("physics");

-- local imports
local level = require("classes.game_classes.level");

local levelConfigReader = require("config_reader");
local gameObjects = require("game_objects");
local sprites_sequences = require("objects_sequences");

local unitClass = gameObjects["unit"];
local towerClass = gameObjects["tower"];
local blanTowerClass = gameObjects["blank_tower"];

-- hide default status bar (iOS)
display.setStatusBar( display.HiddenStatusBar );

level:readConfig("resources/config/maps/02_saint_petersburg.json");
local levelConfig = levelConfigReader.readLevelConfig("resources/config/maps/02_saint_petersburg.json");

local levelParameters = levelConfig["params"];

-- status string
local playerCredits = 100;

-- FIXME: "-80" - why?
local creditString = display.newText("Credits: " .. playerCredits, -60, 40, native.systemFont, 30);

local health = 20;
local healthString = display.newText("Health: " .. health, 100, 40, native.systemFont, 30);

local wave_number = 0;
local total_waves = 10;
local wavesString = display.newText("Waves: " .. wave_number .. "/" .. total_waves, -54, 90, native.systemFont, 30);

local start_x = 800;
local start_y = 180;

local unit_per_row = 2;
local units_number = 6;

wave = {};
local row_number = 0;
for i = 1, units_number do
	wave[i] = unitClass.new();

	wave[i].characterGroup.x = start_x + 40 * i + 20 * row_number;
	wave[i].characterGroup.y = start_y + 40 * i - 140 * row_number;
	wave[i].sprite:play();

	if (i % unit_per_row == 0) then
		row_number = row_number + 1;
	end
end

-- end of waves description

-- towers description

local testTower = towerClass.new();

testTower.towerGroup.x = 270;
testTower.towerGroup.y = 300;

-- end of towers description

-- timing parameters
t=0.1

local function bezierPath(self, event)

	-- tower position

	-- choose closest unit
	local closestUnit = wave[1].sprite;
	-- 10000 - for test, must be max double
	local minDist = 10000;

	-- NB: tower is a center of the coordinates system
	for i, unit in ipairs(wave) do
		local currentUnit = unit.sprite;

		local currentDist = math.sqrt( currentUnit.y * currentUnit.y + currentUnit.x * currentUnit.x );

		if ( currentDist < minDist ) then
			minDist = currentDist;
			closestUnit = currentUnit;

			--print("Closest unit number is [ " .. i .. " ]");
		end
	end

	-- tower animation
	local angelTowerUnit = math.acos( math.pow(closestUnit.x, 2) / math.sqrt( math.pow(closestUnit.x, 2) + math.pow(closestUnit.y, 2) ) );

	local isTowerAnimationChanged = false;

	local basicRad = 0.393;

	for i = 0, 15 do
		isAnimationChanged = true;
		if (angelTowerUnit > (basicRad * i) and angelTowerUnit < (basicRad * (i + 1)) ) then
			-- 22.5 is a basic rad in degrees
			local movementType = (i * 22.5) .. "_degree_fire";
			testTower.sprite:setSequence( movementType );
		end
	end

	if (isTowerAnimationChanged == true) then
		isTowerAnimationChanged = false;
		testTower:play();
	end

	-- end of towers

	-- moving wave cycle
	local rowNumber = 0;
	for i, unit in ipairs(wave) do
		local unitAngel = unit.angel;
		local x1 = unit.characterGroup.x;
		local y1 = unit.characterGroup.y;

		-- + 40 * i + 20 * rowNumber - using only start position
		local bezierX = (1 - t*t) * start_x + 2 * t * (1 - t) * 500 + t * t * 100 + 40 * i + 20 * rowNumber;
		-- + 40 * i - 140 * rowNumber
		local bezierY = (1 - t*t) * start_y + 2 * t * (1 - t) * 150 + t * t * 100 + 40 * i - 140 * rowNumber;

		local angelNew = math.acos( (bezierX - x1) / math.sqrt( math.pow(bezierX - x1, 2) + math.pow(bezierY - y1, 2) ));

		local isUnitAnimationChanged = false;
		if ( math.abs(angelNew - unitAngel) > 0.392 ) then
			isUnitAnimationChanged = true;
		
			local basicRad = 0.393;

			for i = 0, 15 do
				if (angelNew > (basicRad * i) and angelNew < (basicRad * (i + 1)) ) then
					-- 22.5 is a basic rad in degrees
					local movementType = (i * 22.5) .. "_degree_run";
					unit.sprite:setSequence( movementType );
				end
			end

		end

		unit.characterGroup.x = bezierX;
		unit.characterGroup.y = bezierY;

		if ( i % unit_per_row == 0 and unitNum ~= 1) then
			rowNumber = rowNumber + 1;
		end
	
		if (isUnitAnimationChanged == true) then
			unit.sprite:play();
			isUnitAnimationChanged = false;
			unit.angel = angelNew;
		end

	end
	-- end of moving wave cycle

	-- refresh time
	t = t + 0.005;

	if (t > 1) then
		t = 0;
	end
end

Runtime:addEventListener("enterFrame", bezierPath);


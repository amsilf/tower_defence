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
local mapConfigReader = require("config_reader");
local game_objects = require("game_objects");
local sprites_sequences = require("objects_sequences");

local unit = game_objects["unit"];

-- hide default status bar (iOS)
display.setStatusBar( display.HiddenStatusBar );

mapConfig = mapConfigReader.readMapConfig("resources/config/maps/02_saint_petersburg.json");

mapParameters = mapConfig["params"];

-- load tower defence background
local backgroundImage = display.newImage(mapParameters["background"], 450, 400);
backgroundImage:toBack();

local unitOptions = {
	width = 100,
	height = 100,
	numFrames = 192
};

local unitSheet = graphics.newImageSheet("resources/units/mariner_animation.png", unitOptions);

local start_x = 800;
local start_y = 180;

local unit_per_row = 2;
local units_number = 6;

wave = {};
local row_number = 0;
for i = 1, units_number do
	wave[i] = unit.new();

	wave[i].sprite = display.newSprite(unitSheet, sprites_sequences["unit"]);

	wave[i].sprite.x = start_x + 40 * i + 20 * row_number;
	wave[i].sprite.y = start_y + 40 * i - 140 * row_number;
	wave[i].sprite:play();

	if (i % unit_per_row == 0) then
		row_number = row_number + 1;
	end
end

-- end of waves description

-- towers description
local towerOptions = {
	width = 100,
	height = 100,
	numFrames = 192
};

local towerSheet = graphics.newImageSheet("resources/towers/turret_01_renders_set.png", towerOptions);


local test_tower = display.newSprite(towerSheet, sprites_sequences["tower"]);

test_tower.x = 270;
test_tower.y = 300;

-- end of towers description

-- timing parameters
t=0.1

local function bezierPath(self, event)

	-- tower position

	-- choose closest unit
	local closest_unit = wave[1].sprite;
	-- 10000 - for test, must be max double
	local min_dist = 10000;

	-- NB: tower is a center of the coordinates system
	for i, unit in ipairs(wave) do
		local current_unit = unit.sprite;

		local current_dist = math.sqrt( current_unit.y * current_unit.y + current_unit.x * current_unit.x );

		if ( current_dist < min_dist ) then
			min_dist = current_dist;
			closest_unit = current_unit;

			--print("Closest unit number is [ " .. i .. " ]");
		end
	end

	--print("cu.x = [ " .. closest_unit.x .. " ], cu.y = " .. closest_unit.y .. " ]");

	--print("pure value [ " .. (math.pow(closest_unit.x, 2) / math.sqrt( math.pow(closest_unit.x, 2) + math.pow(closest_unit.y, 2) ) ) .. " ]" );

	-- tower animation
	local angel_tower_unit = math.acos( math.pow(closest_unit.x, 2) / math.sqrt( math.pow(closest_unit.x, 2) + math.pow(closest_unit.y, 2) ) );

	--print("Angel tower - unit [ " .. angel_tower_unit .. " ]");

	local isTowerAnimationChanged = false;

	local basic_rad = 0.393;

	for i = 0, 15 do
		isAnimationChanged = true;
		if (angel_tower_unit > (basic_rad * i) and angel_tower_unit < (basic_rad * (i + 1)) ) then
			-- 22.5 is a basic rad in degrees
			local movement_type = (i * 22.5) .. "_degree_fire";
			tower_test.sprite:setSequence( movement_type );
		end
	end

	if (isTowerAnimationChanged == true) then
		isTowerAnimationChanged = false;
		test_tower:play();
	end

	-- end of towers

	-- moving wave cycle
	local row_number = 0;
	for i, unit in ipairs(wave) do
		local unit_angel = unit.angel;
		local x1 = unit.sprite.x;
		local y1 = unit.sprite.y;

		-- + 40 * i + 20 * row_number - using only start position
		local bezier_x = (1 - t*t) * start_x + 2 * t * (1 - t) * 500 + t * t * 100 + 40 * i + 20 * row_number;
		-- + 40 * i - 140 * row_number
		local bezier_y = (1 - t*t) * start_y + 2 * t * (1 - t) * 150 + t * t * 100 + 40 * i - 140 * row_number;

		local angel_new = math.acos( (bezier_x - x1) / math.sqrt( math.pow(bezier_x - x1, 2) + math.pow(bezier_y - y1, 2) ));

		local isUnitAnimationChanged = false;
		if ( math.abs(angel_new - unit_angel) > 0.392 ) then
			isUnitAnimationChanged = true;
			print("isAnimationChanged: unit = [ " .. unit_angel .. " ] new = [ " .. angel_new .. " ]");
		
			local basic_rad = 0.393;

			for i = 0, 15 do
				if (angel_new > (basic_rad * i) and angel_new < (basic_rad * (i + 1)) ) then
					-- 22.5 is a basic rad in degrees
					local movement_type = (i * 22.5) .. "_degree_run";
					unit.sprite:setSequence( movement_type );
				end
			end

		end

		unit.sprite.x = bezier_x;
		unit.sprite.y = bezier_y;

		if ( i % unit_per_row == 0 and unitNum ~= 1) then
			row_number = row_number + 1;
		end
	
		if (isUnitAnimationChanged == true) then
			unit.sprite:play();
			isUnitAnimationChanged = false;
			unit.angel = angel_new;
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

-- Main theme music
--[[
local function mainThemeFinished( event )
	print("Main theme fininshed");
end

local backgroundMusicStream = audio.loadStream("resources/music/battle_2.mp3");
local backgroundMusicChannel = audio.play(backgroundMusicStream,	 
	{channel=1, loops=-1, fadein=5000, onComplete=mainThemeFinished});
]]--

-- GUI experiments
--[[

local function scrollListener( event )
    local phase = event.phase

    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached top limit" )
        elseif ( event.direction == "down" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "left" ) then print( "Reached left limit" )
        elseif ( event.direction == "right" ) then print( "Reached right limit" )
        end
    end

    return true
end

local briefingDialog = widget.newScrollView
{
	top = 100,
	left = 10,
	width = 1000,
	height = 600,
	scrollWidth = 600,
    scrollHeight = 800,
    listener = scrollListener
}

local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
    end
end

-- Create the widget
local brief_ok = widget.newButton
{
    left = 430,
    top = 500,
    id = "brief_ok",
    label = "Ok",
    onEvent = handleButtonEvent
}

local brief_text = display.newText("Brief text test", 200, 200, native.systemFont, 60);

brief_text:setFillColor(0, 0, 0);

briefingDialog:insert(brief_text);
briefingDialog:insert(brief_ok);
]]--

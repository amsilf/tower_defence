-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--local physics = require("physics");
--physics.setDrawMode( "hybrid" );

-- NB: uncomment to enable GUI
--local composer = require("composer");
--composer.gotoScene("scenes.main_menu", "zoomInOutFade");

--physics.start();
--physics.setGravity(0, 0);

display.setStatusBar( display.HiddenStatusBar );

-- local imports
local level = require("classes.game_classes.level");

level:readConfig("resources/config/maps/02_saint_petersburg.json");

local function onTick(self, event)
	level:onTick();
end

Runtime:addEventListener( "enterFrame", onTick );
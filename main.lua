-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- NB: uncomment to enable GUI
--local composer = require("composer");
--composer.gotoScene("scenes.main_menu", "zoomInOutFade");

display.setStatusBar( display.HiddenStatusBar );

-- local imports
local level = require("classes.game_classes.level");

level:readConfig("resources/config/maps/02_saint_petersburg.json");

local function onTick(self, event)
	level:onTick();
end

Runtime:addEventListener( "enterFrame", onTick );
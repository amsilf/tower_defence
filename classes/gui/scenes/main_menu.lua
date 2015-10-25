-----------------------------------------------------------------------------------------
--
-- main_menu.lua
--
-----------------------------------------------------------------------------------------

-- global imports
local composer = require("composer");
local widget = require("widget");

local scene = composer.newScene();

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local function onPlayButtonRelease()
    composer.gotoScene("scenes.saved_sessions_menu", "zoomInOutFade");
    return true;
end

local function onSettingsButtonRelese()
    composer.gotoScene("scenes.settings_menu", "zoomInOutFade");
    return true;
end

local function onCreditsButtonRelease()
    composer.gotoScene("scenes.credits_menu", "zoomInOutFade");
    return true;
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view;

    playButton = widget.newButton({
        label="Play",
        width=200, height=100,
        fontSize=40,
        onRelease = onPlayButtonRelease
        });

    settingsButton = widget.newButton({
        label="Settings",
        width=200, height=100,
        fontSize=40,
        onRelease=onSettingsButtonRelese
        });

    creditsButton = widget.newButton({
        label="Credits",
        width=200, height=100,
        fontSize=40,
        onRelease=onCreditsButtonRelease
        });

    playButton.x = display.contentWidth * 0.5;
    playButton.y = display.contentHeight * 0.5 - 140;

    settingsButton.x = display.contentWidth * 0.5;
    settingsButton.y = display.contentHeight * 0.5 - 20;

    creditsButton.x = display.contentWidth * 0.5;
    creditsButton.y = display.contentHeight * 0.5 + 100;

    sceneGroup:insert(playButton);
    sceneGroup:insert(settingsButton);
    sceneGroup:insert(creditsButton);
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    if playButton then
        playButton.removeSelf();
        playButton = nil;
    end

    if settingsButton then

    end

    if creditsButton then

    end
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene

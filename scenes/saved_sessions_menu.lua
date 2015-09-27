-----------------------------------------------------------------------------------------
--
-- saved_sessions.lua
--
-----------------------------------------------------------------------------------------

-- global imports
local widget = require("widget")
local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local function onFirstSaveButtonRelease()
end

local function onSecondSaveButtonRelease()
end

local function onThirdSaveButtonRelease()
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    firstSaveButton = widget.newButton({
        label="Save - 1",
        width=200, height=100,
        fontSize=40,
        onRelease = onFirstSaveButtonRelease
        });

    secondSaveButton = widget.newButton({
        label="Save - 2",
        width=200, height=100,
        fontSize=40,
        onRelease=onSecondSaveButtonRelease
        });

    thirdSaveButton = widget.newButton({
        label="Save - 3",
        width=200, height=100,
        fontSize=40,
        onRelease=onThirdSaveButtonRelease
        });


    firstSaveButton.x = display.contentWidth * 0.5;
    firstSaveButton.y = display.contentHeight * 0.5 - 140;

    secondSaveButton.x = display.contentWidth * 0.5;
    secondSaveButton.y = display.contentHeight * 0.5 - 20;

    thirdSaveButton.x = display.contentWidth * 0.5;
    thirdSaveButton.y = display.contentHeight * 0.5 + 100;

    sceneGroup:insert(firstSaveButton);
    sceneGroup:insert(secondSaveButton);

    sceneGroup:insert(thirdSaveButton);
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

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
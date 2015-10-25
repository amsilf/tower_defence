-----------------------------------------------------------------------------------------
--
-- gui_dialogs.lua
--
-----------------------------------------------------------------------------------------
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

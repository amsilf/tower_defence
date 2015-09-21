-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- represents any movable objet in the game
local Wave = {};
Wave = {
	numUnits = 8,
	perRow = 2,
	type = mariner,

}

local Unit = {};
Unit = {
	sprite = nil,
	health = 100,
	speed = 1,

}

-- represents any tower in the game
local Tower = {};
Tower = {
	sprite = nil,
	speed = 1,
	level = 1,
	radius = 10,
	
}
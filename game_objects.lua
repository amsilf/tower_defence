-----------------------------------------------------------------------------------------
--
-- game_objects.lua
--
-----------------------------------------------------------------------------------------

game_objects = {};

-- any unit in the game

local unit = {};
unit = {
	sprite = nil,
	health = 100,
	speed = 1,
	armor = 0,
	angel = 0
}

local unit_mt = { __index = unit }

game_objects["unit"] = unit;

function unit.new()
	local newUnit = {
		sprite = nil,
		health = 100,
		speed = 1,
		armor = 0,
		angel = 1
	};

	return setmetatable( newUnit, unit_mt );
end

-- end of unit

-- wave - group of units
local wave = {};
wave = {
	numUnits = 8,
	perRow = 2,
	type = "mariner"
}

wave_mt = { __index = wave }

function wave.new()
	local newWave = {
		numUnits = 8,
		perRow = 2,
		type = "mariner"
	};

	return setmetatable( newWave, wave_mt );
end

game_objects["wave"] = wave;

-- end of wave

-- towers in the game
local tower = {};
tower = {
	sprite = nil,
	speed = 1,
	level = 1,
	radius = 10,
	
}

local tower_mt = { __index = tower }

function tower.new()
	local newTower = {
		sprite = nil,
		speed = 1,
		level = 1,
		radius = 10
	};

	return setmetatable( newTower, tower_mt );
end

game_objects["tower"] = tower;

-- end of towers

return game_objects;
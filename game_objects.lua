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
	displayGroup = nil,
	healthBar = nil,
	health = 100,
	speed = 1,
	armor = 0,
	angel = 0
}

local unit_mt = { __index = unit }

function unit:touch(event)
	print("Unit touched...");
end

-- global functions
function unit.new()
	local newUnit = {
		sprite = nil,
		characterGroup = nil,
		healthBar = nil,
		health = 100,
		speed = 1,
		armor = 0,
		angel = 1
	};

	-- FIXME revise calls and pass parameters
	newUnit.sprite = initUnitSprite("");

	newUnit.characterGroup = display.newGroup();

	newUnit.characterGroup:insert(newUnit.sprite);

	-- FIXME: review number
	healthBar = display.newRect(-5, -45, 35, 7);
	healthBar:setFillColor(0, 10, 0);

	healthBar.strokeWidth = 0.5;
	healthBar:setStrokeColor(0, 0, 0, .5);

	newUnit.characterGroup:insert(healthBar);

	setmetatable(newUnit, unit_mt);

	return newUnit;
end

function unit:listen()
	local unit = self;

	self.sprite.touch = function(self, event)
		unit:touch(event);
	end

	self.sprite:addEventListener("touch");
end

-- private functions
-- TODO make it local
function initUnitSprite(type)
	local unitOptions = {
		width = 100,
		height = 100,
		numFrames = 192
	};

	local unitSheet = graphics.newImageSheet("resources/units/mariner_animation.png", unitOptions);

	return display.newSprite(unitSheet, sprites_sequences["unit"])
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

	return setmetatable(newWave, wave_mt);
end

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

	newTower.sprite = initTowerSprite("");

	setmetatable(newTower, tower_mt);

	newTower:listen();

	return newTower;
end

-- private functions
-- TODO make it local
function initTowerSprite(type)
	local towerOptions = {
		width = 100,
		height = 100,
		numFrames = 192
	};

	local towerSheet = graphics.newImageSheet("resources/towers/turret_01_renders_set.png", towerOptions);

	return display.newSprite(towerSheet, sprites_sequences["tower"])
end

function tower:touch(event)
	print("Tower touched...");
end

function tower:listen()
	local tower = self;

	self.sprite.touch = function(self, event)
		tower:touch(event);
	end

	self.sprite:addEventListener("touch");
end

-- end of towers

game_objects["unit"] = unit;
game_objects["wave"] = wave;
game_objects["tower"] = tower;

return game_objects;


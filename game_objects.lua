-----------------------------------------------------------------------------------------
--
-- game_objects.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget");

game_objects = {};

-- any unit in the game

local unit = {};
unit = {
	sprite = nil,
	characterGroup = nil,
	healthBar = nil,
	health = 100,
	speed = 1,
	armor = 0,
	angel = 0
}

local unit_mt = { __index = unit }

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
	range = 150,
	cost = 100,
	
	towerGroup = nil,
	upgradeButton = nil,
	sellButton = nil,
	towerRange = nil
}

local tower_mt = { __index = tower }

function tower.new()
	local newTower = {
		sprite = nil,
		speed = 1,
		level = 1,
		range = 150,
		cost = 100,

		towerGroup = nil,
		upgradeButton = nil,
		sellButton = nil,
		towerRange = nil
	};

	newTower.sprite = initTowerSprite("");
	newTower.towerGroup = display.newGroup();

	newTower.towerGroup:insert(newTower.sprite);

	-- draw the tower range
	-- FIME must be an ellipse
	newTower.towerRange = display.newCircle(25, 0, newTower.range);

	local objRange = newTower.towerRange;
	objRange.fill.effect = "generator.radialGradient";

	objRange.fill.effect.color1 = { 1, 0, 0, 1 };
	objRange.fill.effect.color2 = { 0, 0, 0, 0 };
	objRange.fill.effect.center_and_radiuses  =  { 0.5, 0.5, 0.6, 0.4 };
	objRange.fill.effect.aspectRatio  = 1;
	objRange.alpha = 0;
	objRange.rotation = 50;

	objRange.strokeWidth = 0.5;
	newTower.towerGroup:insert(objRange);

	-- sell and upgrade buttons - images
	newTower.upgradeButton = widget.newButton({
			width = 100,
			height = 100,
			left = -20,
			top = -140,
			fontSize = 25,
			isEnable = false,
			label = "U"
		});

	newTower.upgradeButton.alpha = 0;

	newTower.towerGroup:insert(newTower.upgradeButton);

	newTower.sellButton = widget.newButton({
			width = 70,
			height = 70,
			left = -10,
			top = 110,
			fontSize = 25,
			isEnable = false,
			defaultFile = "resources/icons/sell_icon.png"
		});

	newTower.sellButton.alpha = 0;

	newTower.towerGroup:insert(newTower.sellButton);

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

	local towerSheet = graphics.newImageSheet("resources/towers/turret_renders_set.png", towerOptions);

	return display.newSprite(towerSheet, sprites_sequences["tower"])
end

-- local?
function tower:touch(event)
	self.towerRange.alpha = 0.5;

	self.upgradeButton.alpha = 1;
	self.upgradeButton.isEnable = true;

	self.sellButton.alpha = 1;
	self.sellButton.isEnable = true;
end

-- local?
function tower:listen()
	local tower = self;

	self.sprite.touch = function(self, event)
		tower:touch(event);
	end

	self.sprite:addEventListener("touch");
end

-- end of towers

-- blank space for towers
local blankTower = {
	blankTowerGroup = nil,
	menu = nil,
	image = nil,

	buildTurretButton = nil,
	buildLaserButton  = nil,
	buildRocketButton = nil,
	buildPlasmaButton = nil
};

local blankTower_mt = { __index = blankTower };

function blankTower.new()
	newBlankTower = {
		blankTowerGroup = nil,
		menu = nil,
		image = nil,

		buildTurretButton = nil,
		buildLaserButton  = nil,
		buildRocketButton = nil,
		buildPlasmaButton = nil
	};

	newBlankTower.blankTowerGroup = display.newGroup();
	newBlankTower.image = display.newImage("resources/towers/blank_tower.png");
	
	newBlankTower.blankTowerGroup:insert(newBlankTower.image);

	newBlankTower.menu = display.newCircle(0, 0, 100);

	local objMenu = newBlankTower.menu;
	objMenu.fill.effect = "generator.radialGradient";

	objMenu.fill.effect.color1 = { 0, 0, 1, 1 };
	objMenu.fill.effect.color2 = { 0, 0, 0, 0 };
	objMenu.fill.effect.center_and_radiuses  =  { 0.5, 0.5, 0.6, 0.4 };
	objMenu.fill.effect.aspectRatio  = 1;
	objMenu.rotation = 50;
	objMenu.alpha = 0;
	objMenu.strokeWidth = 0.5;

	newBlankTower.blankTowerGroup:insert(newBlankTower.menu);

	-- control buttons
	-- turret
	newBlankTower.buildTurretButton = widget.newButton({
		width = 100,
		height = 100,
		left = -50,
		top = 50,
		fontSize = 25,
		isEnable = false,
		label = "T"
	});

	newBlankTower.buildTurretButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildTurretButton);

	-- laser
	newBlankTower.buildLaserButton = widget.newButton({
		width = 100,
		height = 100,
		left = -150,
		top = -50,
		fontSize = 25,
		isEnable = false,
		label = "L"
	});
	newBlankTower.buildLaserButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildLaserButton);
	
	-- rocket
	newBlankTower.buildRocketButton = widget.newButton({
		width = 100,
		height = 100,
		left = -50,
		top = -150,
		fontSize = 25,
		isEnable = false,
		label = "R"
	});
	newBlankTower.buildRocketButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildRocketButton);

	-- plasma
	newBlankTower.buildPlasmaButton = widget.newButton({
		width = 100,
		height = 100,
		left = 50,
		top = -50,
		fontSize = 25,
		isEnable = false,
		label = "P"
	});
	newBlankTower.buildPlasmaButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildPlasmaButton);

	setmetatable(newBlankTower, blankTower_mt);

	newBlankTower:listen();

	return newBlankTower;
end

-- local
function blankTower:touch(event)
	self.menu.alpha = 1;

	self.buildTurretButton.alpha = 1;
	self.buildTurretButton.isEnable = true;

	self.buildRocketButton.alpha = 1;
	self.buildRocketButton.isEnable = true;

	self.buildLaserButton.alpha = 1;
	self.buildLaserButton.isEnable = true;

	self.buildPlasmaButton.alpha = 1;
	self.buildPlasmaButton.isEnable = true;
end

-- local?
function blankTower:listen()
	local blankTower = self;

	self.image.touch = function (self, event)
		blankTower:touch(event)
	end

	self.image:addEventListener("touch");
end
-- enf od blank space for towers

-- game field


-- end of game field

game_objects["unit"] = unit;
game_objects["wave"] = wave;
game_objects["tower"] = tower;
game_objects["blank_tower"] = blankTower;

return game_objects;


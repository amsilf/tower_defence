-----------------------------------------------------------------------------------------
--
-- tower.lua
--
-----------------------------------------------------------------------------------------
local towerClass = {};

towerClass = {
	speed = 1,
	level = 1,
	range = 150,
	cost = 100,
	upgradeCost = 120,

	sprite = nil,
	
	towerGroup = nil,
	upgradeButton = nil,
	sellButton = nil,
	towerRange = nil
}

local towerClass_mt = { __index = towerClass }

function towerClass.new(params)
	local newTower = {
		speed = params["speed"],
		level = params["level"],
		range = params["ramge"],
		cost = params["cost"],
		upgradeCost = params["upgradeCost"],

		sprite = nil,

		towerGroup = nil,
		upgradeButton = nil,
		sellButton = nil,
		towerRange = nil
	};

	newTower.sprite = initTowerSprite(params["type"]);
	newTower.towerGroup = display.newGroup();

	newTower.towerGroup:insert(newTower.sprite);

	-- draw the tower range
	-- FIME must be an ellipse
	local rangeParams = params["gui"]["range"];
	newTower.towerRange = display.newCircle(rangeParams["circle_x"], rangeParams["circle_y"], newTower.range);

	local objRange = newTower.towerRange;
	objRange.fill.effect = rangeParams["effect"];

	-- converting string to table
	objRange.fill.effect.color1 = { 1, 0, 0, 1 };
	objRange.fill.effect.color2 = { 0, 0, 0, 0 };
	objRange.fill.effect.center_and_radiuses  =  { 0.5, 0.5, 0.6, 0.4 };
	objRange.fill.effect.aspectRatio  = rangeParams["aspect_ratio"];
	objRange.alpha = rangeParams["def_alpha"];

	objRange.strokeWidth = 0.5;
	newTower.towerGroup:insert(objRange);

	-- sell and upgrade buttons - images
	local btnUpgradeParams = 
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

	setmetatable(newTower, towerClass_mt);

	newTower:listen();

	return newTower;
end

local function towerClass:hideMenu()
	self.towerRange.alpha = 0.5;

	self.upgradeButton.alpha = 1;
	self.upgradeButton.isEnable = true;

	self.sellButton.alpha = 1;
	self.sellButton.isEnable = true;	
end

-- TODO make it local
local function towerClass.initTowerSprite(type)
	local towerOptions = {
		width = 100,
		height = 100,
		numFrames = 192
	};

	local towerSheet = graphics.newImageSheet("resources/towers/turret_renders_set.png", towerOptions);

	return display.newSprite(towerSheet, sprites_sequences["tower"])
end

local function towerClass:hideMenu()
	self.towerRange.alpha = 0;

	self.upgradeButton.alpha = 0;
	self.upgradeButton.isEnable = false;

	self.sellButton.alpha = 0;
	self.sellButton.isEnable = false;	
end

-- local?
function towerClass:touch(event)
	self.towerRange.alpha = 0.5;

	self.upgradeButton.alpha = 1;
	self.upgradeButton.isEnable = true;

	self.sellButton.alpha = 1;
	self.sellButton.isEnable = true;
end

function towerClass:setTowerPosition(x, y)
	self.towerGroup.x = x;
	self.towerGroup.y = y;
end

function towerClass:listen()
	local tower = self;

	self.sprite.touch = function(self, event)
		tower:touch(event);
	end

	self.sprite:addEventListener("touch");
end

return towerClass;


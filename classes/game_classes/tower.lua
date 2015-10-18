-----------------------------------------------------------------------------------------
--
-- tower.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget");

local sprites_sequences = require("objects_sequences");

local towerClass = {};

towerClass = {
	speed = 1,
	level = 1,
	range = 150,
	cost = 100,
	upgradeCost = 120,

	sprite = nil,

	level = nil,
	
	towerGroup = nil,
	upgradeButton = nil,
	sellButton = nil,
	towerRange = nil
}

local towerClass_mt = { __index = towerClass }

function towerClass.new(params, level)
	local newTower = {
		speed = params["speed"],
		level = params["level"],
		range = params["range"],
		cost = params["cost"],
		upgradeCost = params["upgradeCost"],

		sprite = nil,

		towerGroup = nil,
		upgradeButton = nil,
		sellButton = nil,
		towerRange = nil
	};

	newTower.level = level;

	newTower.sprite = towerClass.initTowerSprite(params);
	newTower.towerGroup = display.newGroup();

	newTower.towerGroup:insert(newTower.sprite);

	-- draw the tower range
	-- FIME must be an ellipse
	local rangeParams = params["gui"]["range"];
	newTower.towerRange = display.newCircle(rangeParams["circle_x"], rangeParams["circle_y"], newTower.range);

	local objRange = newTower.towerRange;
	objRange.fill.effect = rangeParams["effect"];

	-- converting string to table
	objRange.fill.effect.color1 = rangeParams["color1"];
	objRange.fill.effect.color2 = rangeParams["color2"];
	objRange.fill.effect.center_and_radiuses  =  rangeParams["center_and_radius"];
	objRange.fill.effect.aspectRatio  = rangeParams["aspect_ratio"];
	objRange.alpha = rangeParams["def_alpha"];

	objRange.strokeWidth = rangeParams["strokeWidth"];
	newTower.towerGroup:insert(objRange);

	-- sell and upgrade buttons - images
	local btnUpgradeParams = params["gui"]["btnUpgrade"];
	newTower.upgradeButton = widget.newButton({
			width = btnUpgradeParams["width"],
			height = btnUpgradeParams["height"],
			left = btnUpgradeParams["left"],
			top = btnUpgradeParams["top"],
			isEnable = btnUpgradeParams["isEnable"],
			defaultFile = btnUpgradeParams["defaultFile"]
		});

	newTower.upgradeButton.alpha = btnUpgradeParams["alpha"];

	newTower.towerGroup:insert(newTower.upgradeButton);

	local btnSellParams = params["gui"]["btnSell"];
	newTower.sellButton = widget.newButton({
			width = btnSellParams["width"],
			height = btnSellParams["height"],
			left = btnSellParams["left"],
			top = btnSellParams["top"],
			isEnable = btnSellParams["isEnable"],
			defaultFile = btnSellParams["defaultFile"]
		});

	newTower.sellButton.alpha = btnSellParams["alpha"];

	newTower.towerGroup:insert(newTower.sellButton);

	setmetatable(newTower, towerClass_mt);

	newTower:listen();

	return newTower;
end

function towerClass:hideMenu()
	self.towerRange.alpha = 0.5;

	self.upgradeButton.alpha = 1;
	self.upgradeButton.isEnable = true;

	self.sellButton.alpha = 1;
	self.sellButton.isEnable = true;	
end

function towerClass.initTowerSprite(params)
	local towerSpriteParams = params["gui"];
	local towerOptions = {
		width = towerSpriteParams["tower_sheet_width"],
		height = towerSpriteParams["tower_sheet_height"],
		numFrames = towerSpriteParams["tower_sheet_numframes"]
	};

	local towerSheet = graphics.newImageSheet(towerSpriteParams["tower_sheet"], towerOptions);

	return display.newSprite(towerSheet, sprites_sequences["tower"])
end

function towerClass:hideMenu()
	self.towerRange.alpha = 0;

	self.upgradeButton.alpha = 0;
	self.upgradeButton.isEnable = false;

	self.sellButton.alpha = 0;
	self.sellButton.isEnable = false;	
end

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

function towerClass:calculateRotation(tick)
	--[[
	-- choose closest unit
	local closestUnit = wave[1].sprite;
	-- 10000 - for test, must be max double
	local minDist = 10000;

	-- NB: tower is a center of the coordinates system
	for i, unit in ipairs(wave) do
		local currentUnit = unit.sprite;

		local currentDist = math.sqrt( currentUnit.y * currentUnit.y + currentUnit.x * currentUnit.x );

		if ( currentDist < minDist ) then
			minDist = currentDist;
			closestUnit = currentUnit;

			--print("Closest unit number is [ " .. i .. " ]");
		end
	end

	-- tower animation
	local angelTowerUnit = math.acos( math.pow(closestUnit.x, 2) / math.sqrt( math.pow(closestUnit.x, 2) + math.pow(closestUnit.y, 2) ) );

	local isTowerAnimationChanged = false;

	local basicRad = 0.393;

	for i = 0, 15 do
		isAnimationChanged = true;
		if (angelTowerUnit > (basicRad * i) and angelTowerUnit < (basicRad * (i + 1)) ) then
			-- 22.5 is a basic rad in degrees
			local movementType = (i * 22.5) .. "_degree_fire";
			testTower.sprite:setSequence( movementType );
		end
	end

	if (isTowerAnimationChanged == true) then
		isTowerAnimationChanged = false;
		testTower:play();
	end
	]]--
end

return towerClass;


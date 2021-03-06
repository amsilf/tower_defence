-----------------------------------------------------------------------------------------
--
-- tower.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget");

local sprites_sequences = require("classes.game_classes.objects_sequences");

local towerClass = {};

towerClass = {
	towerType = nil,
	rateOfFire = 1,
	towerLevel = 1,
	range = 150,
	price = 100,

	aim = nil,
	currentAngle = nil,

	nextShotTime = 0,

	sprite = nil,

	level = nil,
	
	towerGroup = nil,
	upgradeButton = nil,
	sellButton = nil,
	towerRange = nil
}

local towerClass_mt = { __index = towerClass }

function towerClass.new(type, params, level)
	local newTower = {
		towerType = type,
		rateOfFire = params["rate_of_fire"],
		towerLevel = params["level"],
		range = params["range"],
		price = params["price"],

		aim = nil,

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
			isEnabled = btnUpgradeParams["isEnabled"],
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
			isEnabled = btnSellParams["isEnabled"],
			defaultFile = btnSellParams["defaultFile"]
		});

	newTower.sellButton.alpha = btnSellParams["alpha"];

	newTower.towerGroup:insert(newTower.sellButton);

	setmetatable(newTower, towerClass_mt);

	newTower:listen();

	return newTower;
end

function towerClass.initTowerSprite(params)
	local towerSpriteParams = params["gui"];
	local towerOptions = {
		width = towerSpriteParams["tower_sheet_width"],
		height = towerSpriteParams["tower_sheet_height"],
		numFrames = towerSpriteParams["tower_sheet_numframes"]
	};

	local towerSheet = graphics.newImageSheet(towerSpriteParams["tower_sheet"], towerOptions);

	return display.newSprite(towerSheet, sprites_sequences["tower"]);
end

function towerClass:hideMenu()
	-- FIXME workaround to prevent double clicking
	if (self.towerGroup == nil) then
		return;
	end

	self.towerRange.alpha = 0;

	self.upgradeButton.alpha = 0;
	self.upgradeButton:setEnabled(false);

	self.sellButton.alpha = 0;
	self.sellButton:setEnabled(false);	
end

function towerClass:touch(event)
	self.towerRange.alpha = 0.5;

	if ( self.level:checkResourcesUpgrade(self.towerType, tostring(tonumber(self.towerLevel) + 1)) == true ) then
		self.upgradeButton.alpha = 1;
		self.upgradeButton:setEnabled(true);
	else
		self.upgradeButton.alpha = 0.5;
		self.upgradeButton:setEnabled(false);		
	end

	self.sellButton.alpha = 1;
	self.sellButton:setEnabled(true);
end

function towerClass:setTowerPosition(x, y)
	self.towerGroup.x = x;
	self.towerGroup.y = y;
end

-- FIXME: double click!!!
function towerClass:upgrade(event)
	if (event.phase == "ended") then
		print("Upgrade, level = " .. self.towerLevel);
		self.towerLevel = tostring(tonumber(self.towerLevel) + 1);

		local upgradeCharacteristics = self.level:upgradeCharacteristics(self.towerType, self.towerLevel);

		self.price = upgradeCharacteristics["price"];
		self.range = upgradeCharacteristics["range"];
		self.speed = upgradeCharacteristics["speed"];

		self.level:upgradeTower(self.towerType, self.towerLevel);
	end

	return true;
end

function towerClass:destroyTower()
	if (self.upgradeButton ~= nil) then
		self.upgradeButton:removeSelf();
		self.upgradeButton = nil;
	end

	if (self.sellButton ~= nil) then
		self.sellButton:removeSelf();
		self.sellButton = nil;
	end

	if (self.towerRange ~= nil) then
		self.towerRange:removeSelf();
		self.towerRange = nil;
	end

	if (self.towerGroup ~= nil) then
		self.towerGroup:removeSelf();
		self.towerGroup = nil;
	end
end

function towerClass:sell(event)
	self.level:sellTower(self, self.towerType, self.towerLevel);
end

function towerClass:listen()
	local tower = self;

	self.sprite.touch = function(self, event)
		tower:touch(event);
		return true;
	end

	self.upgradeButton.touch = function (self, event)
		tower:upgrade(event);
		return true;
	end

	self.sellButton.touch = function (self, event)
		tower:sell(event);
		return true;
	end

	self.sellButton:addEventListener("touch", self.sellButton);
	self.upgradeButton:addEventListener("touch", self.upgradeButton);

	self.sprite:addEventListener("touch");
end

function towerClass:setAim()
	self.aim = self.level:getClosestUnitForTower(self);

	if (self.aim ~= nil and self.aim.unit == nil) then
		self.aim = nil;
	end
end

function towerClass:checkAndDoShot(tick)

	-- aim haven't chosen
	if (self.aim == nil or self.aim.unit == nil or self.aim.unit.unitGroup == nil) then
		return;
	end

	local aimX = self.aim.unit.unitGroup.x;
	local aimY = self.aim.unit.unitGroup.y;

	-- tower is the circle center
	local towerX = self.towerGroup.x;
	local towerY = self.towerGroup.y;

	-- if aim in the tower range
	local pointsInRange = math.sqrt( math.pow(aimX - towerX, 2) + math.pow(aimY - towerY, 2) );

	if (pointsInRange <= self.range) then
		if (self.nextShotTime == 0) then
			self.nextShotTime = tick + self.rateOfFire;
		end

		if (self.nextShotTime - tick < 0) then
			self.level:doTowerShot(self);
			self.nextShotTime = 0;
		end
	end
end

--[[
	We are assume that the tower is the coordinates center
]]--
function towerClass:towerRotation(tick)

	-- wave movements haven't triggered
	if (self.aim == nil or self.aim.unit == nil) then
		return;
	end

	local unitX = self.aim.unit.unitGroup.x;
	local unitY = self.aim.unit.unitGroup.y;

	local towerX = self.towerGroup.x;
	local towerY = self.towerGroup.y;

	-- tower animation

	local angleTowerUnit = 0;

	-- specific way of angle calcultion - start from 270

	-- first quarter - 0 < alpha < 90
	if (unitX > towerX and unitY < towerY) then
		-- FIXME: revise unitY - towerX !!!
		angleTowerUnit = math.atan( ( unitY - towerX ) / ( unitY - towerY ) );
	-- second quatert - 270 < alpha < 360
	elseif (unitX < towerX and unitY < towerY) then
		-- 4.7 = rad (270)
		angleTowerUnit = math.atan( ( towerY - unitY ) / ( towerX - unitX )  ) + 4.7;
	-- third quarter - 180 alpha < 270
	elseif(unitX < towerX and unitY > towerY) then
		-- 3.13 = rad (180)
		angleTowerUnit = math.atan( ( unitY - towerY ) / ( towerX - unitX ) ) + 3.14;
	-- fourth quarter - 90 alpha < 180
	elseif (unitX > towerX and unitY > towerY) then
		-- 1.57 = rad (90)
		angleTowerUnit = math.atan( ( unitY - towerY ) / ( towerX - unitX ) ) + 1.57;
	end

	local basicRad = 0.393;
	
	-- FIXME make it similar to unit approach !!!

	for i = 0, 15 do
		if (angleTowerUnit > (basicRad * i) and angleTowerUnit < (basicRad * (i + 1)) ) then
			angleTowerUnit = i * 22.5
		end
	end


	if (angleTowerUnit ~= self.currentAngle) then
		local animationType = angleTowerUnit .. "_degree_fire";
		self.sprite:setSequence( animationType );

		self.sprite:play();
		self.currentAngle = angleTowerUnit;
	end

end

return towerClass;


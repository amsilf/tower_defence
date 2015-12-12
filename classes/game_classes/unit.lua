-----------------------------------------------------------------------------------------
--
-- unit.lua
--
-----------------------------------------------------------------------------------------

local sprites_sequences = require("classes.game_classes.objects_sequences");

local widget = require("widget");

local unitClass = {};
unitClass = {
	id = nil,
	sprite = nil,
	unitGroup = nil,
	healthBar = nil,


	maxHealth = 100,
	currHealth = 100,
	speed = 1,
	armor = 0,

	parentWave = nil,
	
	-- path related properties
	numbereInWave = 0,
	unitsPerRow = 0,

	timeShift = 0,
	angle = 0,
	shift_x = 0,
	shift_y = 0,
	points_x = nil,
	points_y = nil
}

local unitClass_mt = { __index = unitClass }

-- global functions
function unitClass.new(params, timeShift, parentWave)
	local newUnit = {
		id = params["id"],
		sprite = nil,
		unitGroup = nil,
		healthBar = nil,
		maxHealth = 100,
		currHealth = 100,
		speed = 1,
		armor = 0,
		
		-- path related properties
		numberInWave = 0,
		unitsPerRow = 0,

		angle = 0,
		shift_x = 0,
		shift_y = 0,

		-- bezier coordinates
		coreX = 0,
		coreY = 0,

		points_x = {},
		points_y = {}
	};

	newUnit.parentWave = parentWave;

	newUnit.timeShift = timeShift;

	-- FIXME revise calls and pass parameters
	newUnit.sprite = initUnitSprite("mariner");
	newUnit.sprite["id"] = newUnit.id;

	newUnit.unitGroup = display.newGroup();

	newUnit.unitGroup:insert(newUnit.sprite);

	-- FIXME: review number
	-- width is 80
	newUnit.healthBar = display.newRect(-5, -45, 35, 7);

	newUnit.healthBar:setFillColor(0, 10, 0);

	newUnit.healthBar.strokeWidth = 0.5;
	newUnit.healthBar:setStrokeColor(0, 0, 0, .5);

	newUnit.unitGroup:insert(newUnit.healthBar);

	-- FIXME: for test
	newUnit.shift_row = 80;
	newUnit.shift_column = 40;

	setmetatable(newUnit, unitClass_mt);

	return newUnit;
end

function initUnitSprite(type)
	local unitOptions = {
		width = 100,
		height = 100,
		numFrames = 192
	};

	local unitSheet = graphics.newImageSheet("resources/units/mariner_animation.png", unitOptions);

	return display.newSprite(unitSheet, sprites_sequences["unit"])
end

function unitClass:setNumberInWave(i)
	self.numberInWave = i;
end

function unitClass:setUnitsPerRow(num)
	self.unitsPerRow = num;
end

function unitClass:setCoreCoordinates(x, y)
	self.coreX = x;
	self.coreY = y;
end

function unitClass:decreaseHealt(value)
	self.currHealth = self.currHealth - value;

	if(self.currHealth < 0) then
		self.parentWave:destroyUnit(self.id);
		return;
	end

	self:updateHealthBar();
end

function unitClass:updateHealthBar()
	local currHealthPercentage = (self.maxHealth / 100) * self.currHealth;
	if ( currHealthPercentage < 50 ) then
		self.healthBar:setFillColor(230, 245, 20);
	elseif ( currHealthPercentage < 20 ) then
		self.healthBar:setFillColor(10, 0, 0);
	end

	local scaleRate = (100 - self.currHealth) / 100;
	print("scale rate [ " .. scaleRate .. " ]");

	-- FIXME 80 is the bar width, will be moved into const
	local ratio = 80 / self.currHealth;
	self.healthBar:scale(scaleRate, 1);
end

function unitClass:setPosition(x, y)
	self.unitGroup.x = x;
	self.unitGroup.y = y;
end

function unitClass:destroyUnit()

	if (self.sprite ~= nil) then
		self.sprite:removeSelf();
		self.sprite = nil;
	end

	if (self.healthBar ~= nil) then
		self.healthBar:removeSelf();
		self.healthBar = nil;
	end

	if (self.unitGroup ~= nil) then
		self.unitGroup:removeSelf();
		self.unitGroup = nil;
	end	

end

function unitClass:calculateMovmentDirection(currPosX, currPosY, newPosX, newPosY)
	
	if( math.abs(currPosX - newPosX) > 1 ) then
		if (currPosX - newPosX < 0) then
			return "right_to_left";
		else
			return "left_to_right";
		end
	end

	if( math.abs(currPosY - newPosY) > 1 ) then
		if(currPosY - newPosY > 0) then
			return "up_to_down";
		else
			return "down_to_up";
		end
	end

end

function unitClass:calculateUnitPosition(tick, path)

	-- FIXME workaround because of unproper destory
	if (self.unitGroup == nil) then
		return;
	end

	-- TODO: could be cached
	-- creating points array
	local pointsX = {};
	local pointsY = {}; 
	table.insert(pointsX, path["start_end_points"]["start_x"]);
	table.insert(pointsY, path["start_end_points"]["start_y"]);

	for i, currPoint in pairs(path["points"]) do
		table.insert(pointsX, currPoint["x"]);
		table.insert(pointsY, currPoint["y"]);
	end

	table.insert(pointsX, path["start_end_points"]["end_x"]);
	table.insert(pointsY, path["start_end_points"]["end_y"]);

	local bezierX = unitClass.calculateBizerApproximation(tick - self.timeShift, pointsX);
	local bezierY = unitClass.calculateBizerApproximation(tick - self.timeShift, pointsY);

	local currentPosX = self.unitGroup.x;
	local currentPosY = self.unitGroup.y;

	local newUnitPosX = bezierX;
	local newUnitPosY = bezierY;
	
	-- FIXME: works only for 1 and 2 units per row
	if (self.unitsPerRow > 1) then
		local direction = self:calculateMovmentDirection(self.coreX, self.coreY, newUnitPosX, newUnitPosY);

		local rowNum = math.round(self.numberInWave / self.unitsPerRow);
		if (direction == "right_to_left" or direction == "left_to_right") then
			
			if (direction == "right_to_left") then
				newUnitPosX = newUnitPosX - rowNum * self.shift_row;
			else
				newUnitPosX = newUnitPosX + rowNum * self.shift_row;
			end
			
			if (self.numberInWave % self.unitsPerRow == 0) then 
				newUnitPosY = newUnitPosY + self.shift_column;
			else
				newUnitPosY = newUnitPosY - self.shift_column;
			end
		end

		if (direction == "up_to_down" or direction == "down_to_up") then
			if (direction == "up_to_down") then
				newUnitPosY = newUnitPosY - rowNum * self.shift_row;
			else
				newUnitPosY = newUnitPosY + rowNum * self.shift_row;
			end

			if (self.numberInWave % self.unitsPerRow == 0) then 
				newUnitPosX = newUnitPosX + self.shift_column;
			else
				newUnitPosX = newUnitPosX - self.shift_column;
			end
		end
	end

	local unitAngle = self.angle;
	local angleNew = 0;

	-- first quarter - 0 < alpha < 90
	if (self.coreX < bezierX and self.coreY > bezierY) then
		angleNew = unitClass.atanRound ( math.atan( (self.coreY - bezierY) / (bezierX - self.coreX) ) );

	-- second quarter - 270 < alpha < 360
	elseif (self.coreX > bezierX and self.coreY > bezierY) then
		-- 3.13 = rad (180)
		angleNew = unitClass.atanRound ( math.atan( (self.coreY - bezierY) / (self.coreX - bezierX) ) + 3.13);

	-- third quarter - 180 < alpha < 270
	elseif (self.coreX > bezierX and self.coreY < bezierY) then
		-- 4.7 = rad (270)
		angleNew = unitClass.atanRound ( 4.7 - math.atan( (self.coreX - bezierX) / (bezierY - self.coreY) ) );

	-- forth quarter - 90 < alpha < 180
	elseif (self.coreX < bezierX and self.coreY < bezierY) then
		-- 1.57 = rad (90)
		angleNew = unitClass.atanRound ( math.atan( (bezierY - self.coreY) / (bezierX - self.coreX) ) + 1.57);
	end

	-- radians to degrees
	angleNew = math.deg(angleNew);

	local basicAngle = 22.5;
	local isUnitAnimationChanged = false;


	local closestAngle = 0;
	for i = 0, 15 do
		if (angleNew > basicAngle * i and angleNew < basicAngle * (i + 1) ) then
			if ( math.abs(angleNew - basicAngle * i) < math.abs(angleNew - basicAngle * (i + 1)) ) then
				closestAngle = basicAngle * i;
			else
				closestAngle = basicAngle * (i + 1);
			end
		end
	end
	
	if (unitAngle ~= closestAngle) then
		isUnitAnimationChanged = true;

		local movementType = closestAngle .. "_degree_run";
		self.sprite:setSequence( movementType );
	end


	if (isUnitAnimationChanged == true) then
		self.sprite:play();
		isUnitAnimationChanged = false;
		self.angle = closestAngle;
	end

	self:setCoreCoordinates(bezierX, bezierY);
	self:setPosition(newUnitPosX, newUnitPosY);
end

function unitClass.atanRound(t)
    return math.round( t * 1000 ) * 0.001;
end

-- FIXME: factorial calculations could be cached
-- basic calcualtion based on wikipeia article
-- https://ru.wikipedia.org/wiki/Кривая_Безье
function unitClass.calculateBizerApproximation(tick, points)
	local resultValue = 0;

	for i, currPoint in pairs(points) do
		resultValue = resultValue + unitClass.calculateBezierCofficient(tick, points, i - 1) * currPoint;
	end

	return resultValue;
end

function unitClass.calculateBezierCofficient(tick, points, i)
	local n = #points - 1;

	local nFactorial = unitClass.calculateFactorial( n );
	local iFactorial = unitClass.calculateFactorial( i );
	local nMiFactorial = unitClass.calculateFactorial( n - i );

	local bezierCoeff = nFactorial / (iFactorial * nMiFactorial);

	return bezierCoeff * math.pow(tick, i) * math.pow(1 - tick, n - i);
end

function unitClass.calculateFactorial(n)
	local nFactorial = 1;

	for i = 1, n do
		nFactorial = nFactorial * i; 
	end

	return nFactorial;
end

return unitClass;


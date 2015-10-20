-----------------------------------------------------------------------------------------
--
-- unit.lua
--
-----------------------------------------------------------------------------------------

local unitClass = {};
unitClass = {
	sprite = nil,
	unitGroup = nil,
	healthBar = nil,
	health = 100,
	speed = 1,
	armor = 0,
	
	-- path related properties
	angel = 0,
	shift_x = 0,
	shift_y = 0,
	points_x = nil,
	points_y = nil
}

local unitClass_mt = { __index = unitClass }

-- global functions
function unitClass.new()
	local newUnit = {
		sprite = nil,
		unitGroup = nil,
		healthBar = nil,
		health = 100,
		speed = 1,
		armor = 0,
		
		-- path related properties
		angel = 0,
		shift_x = 0,
		shift_y = 0,
		points_x = {},
		points_y = {}
	};

	-- FIXME revise calls and pass parameters
	newUnit.sprite = initUnitSprite("mariner");

	newUnit.unitGroup = display.newGroup();

	newUnit.unitGroup:insert(newUnit.sprite);

	-- FIXME: review number
	healthBar = display.newRect(-5, -45, 35, 7);
	healthBar:setFillColor(0, 10, 0);

	healthBar.strokeWidth = 0.5;
	healthBar:setStrokeColor(0, 0, 0, .5);

	newUnit.unitGroup:insert(healthBar);

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

function unitClass:setPosition(x, y)
	self.unitGroup.x = x;
	self.unitGroup.y = y;
end

function unitClass:setShift(x, y)
	self.shift_x = x;
	self.shift_y = y;
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

function unitClass:calculateUnitPosition(tick, path)

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

	local bezierX = unitClass.calculateBizerApproximation(tick, pointsX);
	local bezierY = unitClass.calculateBizerApproximation(tick, pointsY);

	local newUnitPosX = bezierX + self.shift_x;
	local newUnitPosY = bezierY + self.shift_y;

	local unitAngel = self.angel;
	
	local currentPosX = self.unitGroup.x;
	local currentPosY = self.unitGroup.y;

	-- 0.393 - rotation angel in rad, 22.5 degrees
	local basicRad = 0.393;
	local basicAngel = 22.5;

	-- FIXME: revise rotation angel construction
	local angelNew = math.acos( (newUnitPosX - currentPosX) 
			/ math.sqrt( math.pow(newUnitPosX - currentPosX, 2) + math.pow(newUnitPosY - currentPosY, 2) ));

	local isUnitAnimationChanged = false;
	if ( math.abs(angelNew - unitAngel) > basicRad ) then
		isUnitAnimationChanged = true;
		
		-- 0, 15 - because 16 frames
		for i = 0, 15 do
			if (angelNew > (basicRad * i) and angelNew < (basicRad * (i + 1)) ) then
				local movementType = (i * basicAngel) .. "_degree_run";
				self.sprite:setSequence( movementType );
			end
		end

	end

	if (isUnitAnimationChanged == true) then
		self.sprite:play();
		isUnitAnimationChanged = false;
		self.angel = angelNew;
	end

	self:setPosition(newUnitPosX, newUnitPosY);
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


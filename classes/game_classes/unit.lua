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
	angel = 0
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
		angel = 1
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
	print("x = [ " .. x .. " ], y = [ " .. y .. " ]" );
	self.unitGroup.x = x;
	self.unitGroup.y = y;
end

function unitClass:calculateUnitPosition(tick, path)
	local unitAngel = self.angel;
	local x1 = self.unitGroup.x;
	local y1 = self.unitGroup.y;

	-- 0.393 - rotation angel in rad, 22.5 degrees
	local basicRad = 0.393;
	local basicAngel = 22.5;

	-- TODO: could be cached
	-- creating points array
	local pointsX = {};
	local pointsY = {}; 
	table.insert(pointsX, path["start_end"]["start_x"]);
	table.insert(pointsY, path["start_end"]["start_y"]);

	for i, currPoint in pairs(path["points"]) do
		table.insert(pointsX, currPoint["x"]);
		table.insert(pointsY, currPoint["y"]);
	end

	table.insert(pointsX, path["start_end"]["end_x"]);
	table.insert(pointsY, path["start_end"]["end_y"]);

	-- + 40 * i + 20 * rowNumber - using only start position
	-- local bezierX = (1 - tick * tick) * start_x + 2 * tick * (1 - tick) * 500 + tick * tick * 100;
	local bezierX = unitClass.calculateBizerApproximation(tick, pointsX);

	-- + 40 * i - 140 * rowNumber
	-- local bezierY = (1 - tick * tick) * start_y + 2 * tick * (1 - tick) * 150 + tick * tick * 100;
	local bezierY = unitClass.calculateBizerApproximation(tick, pointsY);

	self:setPosition(bezierX, bezierY);

	local angelNew = math.acos( (bezierX - x1) / math.sqrt( math.pow(bezierX - x1, 2) + math.pow(bezierY - y1, 2) ));

	local isUnitAnimationChanged = false;
	if ( math.abs(angelNew - unitAngel) > basicRad ) then
		isUnitAnimationChanged = true;
		
		-- 0, 15 - 16 frames
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


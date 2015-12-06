-----------------------------------------------------------------------------------------
--
-- wave.lua
--
-----------------------------------------------------------------------------------------

local physics = require("physics");

local unitClass = require("classes.game_classes.unit");

local waveClass = {};

waveClass = {
	id = nil,

	unitsType = nil,
	unitsPerRow = nil,
	numUnits = nil,
	path = nil,

	absTime = nil,

	level = nil,

	units_static = nil,

	units = nil,
}

local waveClass_mt = { __index = waveClass }

function waveClass.new(params, level)
	local newWave = {
		id = params["id"],
		unitsType = params["type"],
		unitsPerRow = params["units_per_row"],
		numUnits = params["num_units"],
		absTime = params["abs_time"],
		path = params["levelPaths"][ params["path"] ],

		units = {}
	}

	newWave.level = level;

	setmetatable(newWave, waveClass_mt);

	newWave:initUnits();

	return newWave;
end

function waveClass.compareWavesByTime(wave1, wave2)
	return wave1["abs_time"] < wave2["abs_time"];
end

function waveClass:cleanUnits()
	for i, currUnit in pairs(self.units) do
		if (currUnit.unitGroup == nil) then
			table.remove(self.units, i);
		end
	end
end

function waveClass:destoryWave()
	self.unitsType = nil;
	self.unitsPerRow = nil;
	self.numUnits = nil;
	self.nextWaves = nil;
	self.path = nil;

	self.units_static = nil;

	self.units = nil;

	self = nil;
end

function waveClass:initUnits()
	units_parameters = {};	
	units_parameters["type"] = self.unitsType;
	units_parameters["static"] = self.units_static;

	local tmpUnit = nil;
	local startEndPoints = self.path["start_end_points"];
	local row_number = 0;

	local tickDelta = 0.01;

	local currTimeShift = nil;
	local currAxisXShift = 10;
	local currAxisYShift = 30;

	for i = 1, self.numUnits do

		units_parameters["id"] = "wave_" .. self.id .. "_unit_" .. i;

		if (i % self.unitsPerRow == 0) then
			row_number = row_number + 1;

			currTimeShift = ( 1 / self.numUnits ) * i * 0.01;
		end

		tmpUnit = unitClass.new(units_parameters, currTimeShift, self);

		tmpUnit:setUnitsPerRow(self.unitsPerRow);
		tmpUnit:setNumberInWave(i);

		tmpUnit:setPosition( startEndPoints["start_x"], startEndPoints["start_y"]);

		table.insert(self.units, tmpUnit);
	end
end

function waveClass:destroyUnit(id)
	for i, currUnit in pairs(self.units) do
		if (currUnit.id == id) then
			currUnit:destroyUnit();
			break;
		end
	end

	self.level:unitDestroyed(self.unitsType);
end

function waveClass:getClosestUnitToPoint(x, y)

	local unitClosestDist = {
		dist = 10000,
		unit = nil
	}

	local currDist = 0;
	for i, currUnit in pairs(self.units) do

		-- FIXME: because of unproper unit delete
		if (currUnit.unitGroup ~= nil) then
			currDist = math.sqrt( math.pow( x - currUnit.unitGroup.x , 2) + math.pow( y - currUnit.unitGroup.y , 2) );

			if (currDist < unitClosestDist.dist) then
				unitClosestDist.dist = currDist;
				unitClosestDist.unit = currUnit;
			end
		end
	end

	return unitClosestDist;
end

function waveClass:handleHit(unitId, bulletParams)
	local compelteUnitId = "wave_" .. self.id .. "_unit_" .. unitId;
	for i, currUnit in pairs(self.units) do
		if (currUnit.id == compelteUnitId) then
			-- FIXME 10 - must be a parameter
			currUnit:decreaseHealt(10);
		end
	end
end

function waveClass:calculateWaveMovement(tick, securedZones)
	for i, currUnit in ipairs(self.units) do

		currUnit:calculateUnitPosition(tick, self.path);

		-- FIXME unproper delete
		if (currUnit.unitGroup ~= nil) then
			if (self.level:checkInUnitInSecuredZone(currUnit.unitGroup.x, currUnit.unitGroup.y) == true) then
				currUnit:destroyUnit();
				self.level:dicreaseHealth();

				self.numUnits = self.numUnits -1;
				if (self.numUnits == 0) then
					self:destoryWave();
					self.level:cleanWaves();
				end
			end
		end
	end
end

return waveClass;

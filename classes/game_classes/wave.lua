-----------------------------------------------------------------------------------------
--
-- wave.lua
--
-----------------------------------------------------------------------------------------

local unitClass = require("classes.game_classes.unit");

local waveClass = {};

waveClass = {
	unitsType = nil,
	unitsPerRow = nil,
	numUnits = nil,
	nextWaves = nil,
	path = nil,

	level = nil,

	units_static = nil,

	units = nil,
}

local waveClass_mt = { __index = waveClass }

function waveClass.new(params, level)
	local newWave = {
		unitsType = params["unitsType"],
		unitsPerRow = params["units_per_row"],
		numUnits = params["num_units"],
		nextWave = params["next_waves"],
		path = params["levelPaths"][ params["path"] ],

		units = {}
	}

	newWave.level = level;

	setmetatable(newWave, waveClass_mt);

	newWave:initUnits();

	return newWave;
end

function waveClass:cleanUnits()
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
	for i = 1, self.numUnits do

		currTimeShift = ( 1 / self.numUnits ) * i * 0.01;
		tmpUnit = unitClass.new(units_parameters, currTimeShift);

		tmpUnit:setPosition( startEndPoints["start_x"], startEndPoints["start_y"]);

		-- FIXME move these params into config
		-- FIXME think about proper shif
		tmpUnit:setShift(70 * i, 0);	

		if (i % self.unitsPerRow == 0) then
			row_number = row_number + 1;
		end

		table.insert(self.units, tmpUnit);
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
					-- destroy wave
				end
			end
		end
	end
end

return waveClass;

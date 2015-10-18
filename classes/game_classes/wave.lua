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

	units_static = nil,

	units = nil,
}

local waveClass_mt = { __index = waveClass }

function waveClass.new(params)
	local newWave = {
		unitsType = params["unitsType"],
		unitsPerRow = params["units_per_row"],
		numUnits = params["num_units"],
		nextWave = params["next_waves"],
		path = params["levelPaths"][ params["path"] ],

		units = {}
	}

	setmetatable(newWave, waveClass_mt);

	newWave:initUnits();

	return newWave;
end

function waveClass:initUnits()
	units_parameters = {};
	units_parameters["type"] = self.unitsType;
	units_parameters["static"] = self.units_static;

	local tmpUnit = nil;
	local startEndPoints = self.path["start_end"];
	local row_number = 0;
	for i = 1, self.numUnits do
		tmpUnit = unitClass.new(units_parameters);

		-- FIXME move these params into config
		tmpUnit:setPosition( startEndPoints["start_x"] + 40 * i + 20 * row_number, 
			startEndPoints["start_y"] + 40 * i - 140 * row_number );	

		if (i % self.unitsPerRow == 0) then
			row_number = row_number + 1;
		end

		table.insert(self.units, tmpUnit);
	end
end

function waveClass:calculateWaveMovement(tick)
	for i, currUnit in ipairs(self.units) do
		currUnit:calculateUnitPosition(tick, self.path);
	end
end

return waveClass;

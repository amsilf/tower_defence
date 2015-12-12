-----------------------------------------------------------------------------------------
--
-- objects_sequences.lua
--
-----------------------------------------------------------------------------------------

sprites_sequences={};

-- Running unit sequence
-- 360 / 16 = 22.5, 22.5 in rad = 0.393
local running_unit_sequence = {
	{
		name = "270_degree_run",
		start = 1,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},
	
	{
		name = "292.5_degree_run",
		start = 13,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "315_degree_run",
		start = 25,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "337.5_degree_run",
		start = 37,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "0_degree_run",
		start = 49,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "22.5_degree_run",
		start = 61,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "45_degree_run",
		start = 73,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "67.5_degree_run",
		start = 85,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "90_degree_run",
		start = 97,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "112.5_degree_run",
		start = 109,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "135_degree_run",
		start = 121,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "157.5_degree_run",
		start = 133,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "180_degree_run",
		start = 145,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "202.5_degree_run",
		start = 157,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "225_degree_run",
		start = 169,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "247.5_degree_run",
		start = 181,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	}
};
-- end of unit sequence

-- Tower sequence
local tower_sequence = {
	{
		name = "270_degree_fire",
		start = 1,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},
	
	{
		name = "292.5_degree_fire",
		start = 13,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "315_degree_fire",
		start = 25,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "337.5_degree_fire",
		start = 37,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "360_degree_fire",
		start = 49,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "67.5_degree_fire",
		start = 61,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "45_degree_fire",
		start = 73,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "22.5_degree_fire",
		start = 85,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "0_degree_fire",
		start = 97,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "112.5_degree_fire",
		start = 109,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "135_degree_fire",
		start = 121,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "157.5_degree_fire",
		start = 133,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "180_degree_fire",
		start = 145,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "202.5_degree_fire",
		start = 157,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "225_degree_fire",
		start = 169,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	},

	{
		name = "247.5_degree_fire",
		start = 181,
		count = 12,
		time = 500,
		loop_count = 0,
		loopDirection = "forward"
	}
};
-- end of tower sequence

sprites_sequences["unit"] = running_unit_sequence;
sprites_sequences["tower"] = tower_sequence;

return sprites_sequences;


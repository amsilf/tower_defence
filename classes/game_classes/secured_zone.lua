-----------------------------------------------------------------------------------------
--
-- secured_zone.lua
--
-----------------------------------------------------------------------------------------

classSecuredZone = {
	id = nil,

	topLeftCorner = nil,
	topRightCorner = nil,
	bottomLeftCorner = nil,
	bottomRightCorner = nil

}

local securedZoneClass_mt = { __index = classSecuredZone }

function classSecuredZone.new(params)
	local newSecuredZone = {
		id = params["id"],

		topLeftCorner = params["top_left_corner"],
		topRightCorner = params["top_right_corner"],
		bottomRightCorner = params["bottom_right_corner"],
		bottomLeftCorner = params["bottom_left_corner"]
	}

	setmetatable(newSecuredZone, securedZoneClass_mt);

	return newSecuredZone;
end

-- based on http://math.stackexchange.com/questions/190111/how-to-check-if-a-point-is-inside-a-rectangle
function classSecuredZone:isObjectInZone(x, y)
	-- edge length
	local a1 = math.sqrt( math.pow(self.topLeftCorner["x"] - self.topRightCorner["x"], 2) + 
		math.pow(self.topLeftCorner["y"] - self.topRightCorner["y"], 2));

	local a2 = math.sqrt( math.pow(self.topRightCorner["x"] - self.bottomRightCorner["x"], 2) + 
		math.pow(self.topRightCorner["y"] - self.bottomRightCorner["y"], 2));

	local a3 = math.sqrt( math.pow(self.bottomRightCorner["x"] - self.bottomLeftCorner["x"], 2) + 
		math.pow(self.bottomRightCorner["y"] - self.bottomLeftCorner["y"], 2));

	local a4 = math.sqrt( math.pow(self.bottomLeftCorner["x"] - self.topLeftCorner["x"], 2) 
		+ math.pow(self.bottomLeftCorner["y"] - self.topLeftCorner["y"], 2));

	-- length of the lines segments with point
	local b1 = math.sqrt( math.pow(self.topLeftCorner["x"] - x, 2) + math.pow(self.topLeftCorner["y"] - x, 2) );
	local b2 = math.sqrt( math.pow(self.topRightCorner["x"] - x, 2) + math.pow(self.topRightCorner["y"] - x, 2) );
	local b3 = math.sqrt( math.pow(self.bottomRightCorner["x"] - x, 2) + math.pow(self.bottomRightCorner["y"] - x, 2) );
	local b4 = math.sqrt( math.pow(self.bottomLeftCorner["x"] - x, 2) + math.pow(self.bottomLeftCorner["y"] - x, 2) );

	-- area of a triangles by Heron's formule - https://en.wikipedia.org/wiki/Heron%27s_formula
	local u1 = (a1 + b1 + b2) / 2;
	local u2 = (a2 + b2 + b3) / 2;
	local u3 = (a3 + b3 + b4) / 2;
	local u4 = (a4 + b4 + b1) / 2;

	-- original area size
	local A = a1 * a2;

	-- area size with additional point
	local A1 = math.sqrt(u1 * (u1 - a1) * (u1 - b1) * (u1 - b2));
	local A2 = math.sqrt(u2 * (u2 - a2) * (u2 - b2) * (u2 - b3));
	local A3 = math.sqrt(u3 * (u3 - a3) * (u3 - b3) * (u3 - b4));
	local A4 = math.sqrt(u4 * (u4 - a4) * (u4 - b4) * (u4 - b1));

	-- A = A1 + A2 + A3 + A4 - inside
	-- A > A1 + A2 + A3 + A4 - outside
	local anotherA = A1 + A2 + A3 + A4;

	-- TODO: check algorithm and is this workaround required
	if ( (round(A, 0) - round(anotherA, 0)) > 100) then
		return true;
	else
		return false;
	end 

end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

return classSecuredZone;
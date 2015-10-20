-----------------------------------------------------------------------------------------
--
-- resources.lua
--
-----------------------------------------------------------------------------------------

local resourcesClass = {};

resourcesClass = {
	health = 20,
	waves = 1,
	waves_total = 6;
	credits = 100,

	static = nil,

	resourcesGroup = nil,
	
	healthLabel = nil,
	healthImage = nil,

	wavesLabel = nil,
	wavesImage = nil,

	creditsLabel = nil,
	creditsImage = nil
};

function resourcesClass:init(params)	
	self.health = params["health"];
	self.waves = 0;
	self.waves_total = params["waves_total"];
	self.credits = params["credits"];

	self.static = params["static"];

	-- init images and labels
	self.healthLabel = display.newText(self.health, -50, 70, native.systemFont, 30);
	self.creditsLabel = display.newText(self.credits, -50, 120, native.systemFont, 30);
	self.wavesLabel = display.newText(self.waves .. "/" .. self.waves_total, -50, 170, native.systemFont, 30);
end

function resourcesClass:checkResourcesBuild(type)
	if (type == "turret") then
		-- 1 - first level
		if (self.credits >= self.static["turret"]["price"]) then
			return true;
		else
			return false;
		end
	end

	if (type == "laser") then
		-- 1 - first level
		if (self.credits >= self.static["laser"]["price"]) then
			return true;
		else
			return false;
		end
	end

	if (type == "rocket") then
		-- 1 - first level
		if (self.credits >= self.static["rocket"]["price"]) then
			return true;
		else
			return false;
		end
	end

	if (type == "plasma") then
		-- 1 - first level
		if (self.credits >= self.static["plasma"]["price"]) then
			return true;
		else
			return false;
		end
	end
end

function resourcesClass:buildTower(type)
	if (type == "turret") then
		self.credits = self.credits - self.static["turret"]["price"];
	end

	if (type == "laser") then
		self.credits = self.credits - self.static["laser"]["price"];
	end

	if (type == "rocket") then
		self.credits = self.credits - self.static["rocket"]["price"];
	end

	if (type == "plasma") then
		self.credits = self.credits - self.static["plasma"]["price"];
	end


	self:updateCreditsLabel();
end

function resourcesClass:checkResourcesForUpgrade(type, level)
end

function resourcesClass:updateHealthLabel()
	self.healthLabel.text = self.health;
end

function resourcesClass:updateWavesLabel()
	self.wavesLabel.text = self.waves .. "/" .. self.waves_total;
end

function resourcesClass:updateCreditsLabel()
	self.creditsLabel.text = self.credits;
end

return resourcesClass;


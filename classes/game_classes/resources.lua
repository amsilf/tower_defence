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
	-- "1" stands for 1st level
	if (type == "turret") then
		-- 1 - first level
		if (self.credits >= self.static["turret"]["1"]["price"]) then
			return true;
		else
			return false;
		end
	end

	if (type == "laser") then
		-- 1 - first level
		if (self.credits >= self.static["laser"]["1"]["price"]) then
			return true;
		else
			return false;
		end
	end

	if (type == "rocket") then
		-- 1 - first level
		if (self.credits >= self.static["rocket"]["1"]["price"]) then
			return true;
		else
			return false;
		end
	end

	if (type == "plasma") then
		-- 1 - first level
		if (self.credits >= self.static["plasma"]["1"]["price"]) then
			return true;
		else
			return false;
		end
	end
end

function resourcesClass:buildOrUpgradeTower(type, level)
	-- "1" - because of 1th level
	if (type == "turret") then
		self.credits = self.credits - self.static["turret"][level]["price"];
	end

	if (type == "laser") then
		self.credits = self.credits - self.static["laser"][level]["price"];
	end

	if (type == "rocket") then
		self.credits = self.credits - self.static["rocket"][level]["price"];
	end

	if (type == "plasma") then
		self.credits = self.credits - self.static["plasma"][level]["price"];
	end


	self:updateCreditsLabel();
end

function resourcesClass:checkResourcesForUpgrade(type, level)

	if (type == "turret") then
		if (self.credits >= self.static["turret"][level]["price"]) then
			return true;
		else
			return false;
		end
	end

	if (type == "rocket") then
		if (self.credits >= self.static["rocket"][level]["price"]) then
			return true;
		else
			return false;
		end
	end

	if (type == "laser") then
		if (self.credits >= self.static["laser"][level]["price"]) then
			return true;
		else
			return false;
		end
	end

	if (type == "plasma") then
		if (self.credits >= self.static["plasma"][level]["price"]) then
			return true;
		else
			return false;
		end
	end

end

function resourcesClass:addCreditsForDestroyedUnit(type)
	print("unit type [ " .. type .. " ]")
	self.credits = self.credits + self.static[type]["price"];
	self:updateCreditsLabel();
end

function resourcesClass:sellTower(type, level)
	self.credits = self.credits + (self.static[type][level]["price"] / 2);
	self:updateCreditsLabel();
end

function resourcesClass:upgradeCharacteristics(type, level)
	return self.static[type][level];
end

function resourcesClass:updateHealthLabel()
	self.healthLabel.text = self.health;
end

function resourcesClass:increaseWavesCounter()
	self.waves = self.waves + 1;
	self.wavesLabel.text = self.waves .. "/" .. self.waves_total;
end

function resourcesClass:updateCreditsLabel()
	self.creditsLabel.text = self.credits;
end

function resourcesClass:decreaseHealth()
	self.health = self.health - 1;
	self:updateHealthLabel();
end

return resourcesClass;


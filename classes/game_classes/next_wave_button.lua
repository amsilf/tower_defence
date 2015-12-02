

-----------------------------------------------------------------------------------------
--
-- next_wave_button.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget");

classNextWaveButton = {};

classNextWaveButton = {
	nextWaveButton = nil,
	nextWaveId = nil,
	pathId = nil,

	level = nil
};

local nextWaveButton_mt = { __index = classNextWaveButton }

function classNextWaveButton.new(params, level, pathId)
	local newNextWaveButton = {
		nextWaveButton = nil,
		pathId = pathId,
		level = level
	};

	newNextWaveButton.nextWaveButton = widget.newButton({
		shape = "circle",
		radius = 40,
		fontSize = 30,
		label = "Start",
		isEnable = true
	});

	setmetatable(newNextWaveButton, nextWaveButton_mt);

	newNextWaveButton:listen();

	return newNextWaveButton;
end

function classNextWaveButton:updateTime(timeCounter)
	self.nextWaveButton:setLabel(timeCounter);
end

function classNextWaveButton:disable()
	self.nextWaveButton.alpha = 0;
	self.newNextWaveButton.isEnable = false;
end

function classNextWaveButton:setPosition(x, y)
	self.nextWaveButton.x = x;
	self.nextWaveButton.y = y;
end

function classNextWaveButton:getCounter()
	-- for the initial check
	if(self.nextWaveButton:getLabel() == "Start") then
		return 1;
	end

	return tonumber(self.nextWaveButton:getLabel());
end

function classNextWaveButton:pushNextWave(event)
	self.level:createWaveById( self.nextWaveId );
	self.nextWaveId = nil;
	self.nextWaveButton:setLabel("0");

	return true;
end

function classNextWaveButton:setNextWaveId(id)
	self.nextWaveId = id;
end

function classNextWaveButton:listen()
	currButton = self;

	self.nextWaveButton.touch = function (self, event)
		currButton:pushNextWave(event);	

		return true;
	end

	self.nextWaveButton:addEventListener("touch", self.nextWaveButton);	
end

return classNextWaveButton;



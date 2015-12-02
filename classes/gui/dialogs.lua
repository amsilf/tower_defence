-----------------------------------------------------------------------------------------
--
-- dialogs.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget");

dialogsClass = {};

dialogsClass = {
	trigger = nil,
	time = nil,
	title = nil,
	text = nil,

	titleText = nil,

	image = nil,

	level = nil,

	dialogGroup = nil,
	dialogTextArea = nil,
	dialogOkButton = nil,
	dialogBorder = nil
}

local dialogsClass_mt = { __index = dialogsClass }

function dialogsClass.new(params, level)
	local newDialog = {
		trigger = params["trigger"],
		time = params["time"],
		title = params["title"],

		image = params["image"],
	};

	newDialog.level = level;

	newDialog.dialogGroup = display.newGroup();

	newDialog.dialogBorder = display.newRoundedRect(500, 400, 900, 600, 50);
	newDialog.dialogBorder:setFillColor(0.2);
	newDialog.dialogBorder.alpha = 0.9;

	newDialog.dialogTextArea = display.newText({
		text = params["text"],
		x = 650,
		y = 400,
		width = 500,
		height = 500,
		fontSize = 30,
		align = "left"
		});

	newDialog.dialogOkButton = widget.newButton( {
		label = "OK",
		fontSize = 32,
		left = 400,
		top = 630
		} );

	newDialog.dialogGroup:insert(newDialog.dialogBorder);
	newDialog.dialogGroup:insert(newDialog.dialogOkButton);

	setmetatable(newDialog, dialogsClass_mt);

	newDialog:listen();

	return newDialog;
end

function dialogsClass:okPressed(event)
	self.level:startTimer();
	self:hideDialog();
end

function dialogsClass:hideDialog()
end

function dialogsClass:listen()
	local currDialog = self;

	self.dialogOkButton.touch = function(self, event)
		currDialog:okPressed(event);
		return true;
	end

	self.dialogOkButton:addEventListener("touch", self.dialogOkButton);
end

return dialogsClass;



-----------------------------------------------------------------------------------------
--
-- glank_tower.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget");

local blankTowerClass = {};

blankTowerClass = {
	blankTowerGroup = nil,
	menu = nil,
	image = nil,

	buildTurretButton = nil,
	buildLaserButton  = nil,
	buildRocketButton = nil,
	buildPlasmaButton = nil
};

local blankTower_mt = { __index = blankTowerClass };

function blankTowerClass.new(params)
	newBlankTower = {
		blankTowerGroup = nil,
		menu = nil,
		image = nil,

		buildTurretButton = nil,
		buildLaserButton  = nil,
		buildRocketButton = nil,
		buildPlasmaButton = nil
	};

	local guiParams = params["gui"];

	newBlankTower.blankTowerGroup = display.newGroup();
	newBlankTower.image = display.newImage(guiParams["image"]);
	
	newBlankTower.blankTowerGroup:insert(newBlankTower.image);

	local menuParams = guiParams["menu"];
	newBlankTower.menu = display.newCircle(menuParams["circle_x"], menuParams["circle_y"], menuParams["radius"]);

	local objMenu = newBlankTower.menu;
	objMenu.fill.effect = menuParams["effect"];

	objMenu.fill.effect.color1 = { 0, 0, 1, 1 };
	objMenu.fill.effect.color2 = { 0, 0, 0, 0 };
	objMenu.fill.effect.center_and_radiuses  =  { 0.5, 0.5, 0.6, 0.4 };
	objMenu.fill.effect.aspectRatio  = menuParams["aspect_ratio"];
	objMenu.alpha = menuParams["def_alpha"];
	objMenu.strokeWidth = menuParams["stroke_width"];

	newBlankTower.blankTowerGroup:insert(newBlankTower.menu);

	-- control buttons
	-- turret
	local turrentButtonParams = guiParams["btnBuildTurret"];
	newBlankTower.buildTurretButton = widget.newButton({
		width = turrentButtonParams["width"],
		height = turrentButtonParams["height"],
		left = turrentButtonParams["left"],
		top = turrentButtonParams["top"],
		fontSize = turrentButtonParams["fontSize"],
		isEnable = turrentButtonParams["isEnable"],
		label = turrentButtonParams["label"]
	});

	newBlankTower.buildTurretButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildTurretButton);

	-- laser
	local laserButtonParams = guiParams[""];
	newBlankTower.buildLaserButton = widget.newButton({
		width = 100,
		height = 100,
		left = -150,
		top = -50,
		fontSize = 25,
		isEnable = false,
		label = "L"
	});

	newBlankTower.buildLaserButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildLaserButton);
	
	-- rocket
	newBlankTower.buildRocketButton = widget.newButton({
		width = 100,
		height = 100,
		left = -50,
		top = -150,
		fontSize = 25,
		isEnable = false,
		label = "R"
	});

	newBlankTower.buildRocketButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildRocketButton);

	-- plasma
	newBlankTower.buildPlasmaButton = widget.newButton({
		width = 100,
		height = 100,
		left = 50,
		top = -50,
		fontSize = 25,
		isEnable = false,
		label = "P"
	});

	newBlankTower.buildPlasmaButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildPlasmaButton);

	setmetatable(newBlankTower, blankTower_mt);

	newBlankTower:listen();

	return newBlankTower;
end

function blankTowerClass:hideMenu()
	self.menu.alpha = 0;

	self.buildTurretButton.alpha = 0;
	self.buildTurretButton.isEnable = false;

	self.buildRocketButton.alpha = 0;
	self.buildRocketButton.isEnable = false;

	self.buildLaserButton.alpha = 0;
	self.buildLaserButton.isEnable = false;

	self.buildPlasmaButton.alpha = 0;
	self.buildPlasmaButton.isEnable = false;
end

function blankTowerClass:setDisplayPosition(x, y)
	self.blankTowerGroup.x = x;
	self.blankTowerGroup.y = y;
end

function blankTowerClass:touch(event)
	self.menu.alpha = 1;

	self.buildTurretButton.alpha = 1;
	self.buildTurretButton.isEnable = true;

	self.buildRocketButton.alpha = 1;
	self.buildRocketButton.isEnable = true;

	self.buildLaserButton.alpha = 1;
	self.buildLaserButton.isEnable = true;

	self.buildPlasmaButton.alpha = 1;
	self.buildPlasmaButton.isEnable = true;
end

function blankTowerClass:listen()
	local blankTower = self;

	self.image.touch = function (self, event)
		blankTower:touch(event)
	end

	self.image:addEventListener("touch");
end

return blankTowerClass;


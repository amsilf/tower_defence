-----------------------------------------------------------------------------------------
--
-- blank_tower.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget");

local blankTowerClass = {};

blankTowerClass = {
	level = nil,

	blankTowerGroup = nil,
	menu = nil,
	image = nil,

	buildTurretButton = nil,
	buildLaserButton  = nil,
	buildRocketButton = nil,
	buildPlasmaButton = nil
};

local blankTower_mt = { __index = blankTowerClass };

function blankTowerClass.new(params, level)
	newBlankTower = {
		level = nil,

		blankTowerGroup = nil,
		menu = nil,
		image = nil,

		buildTurretButton = nil,
		buildLaserButton  = nil,
		buildRocketButton = nil,
		buildPlasmaButton = nil
	};

	setmetatable(newBlankTower, blankTower_mt);

	newBlankTower.level = level;

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
		isEnabled = turrentButtonParams["isEnabled"],
		defaultFile = turrentButtonParams["image"],
	});

	newBlankTower.buildTurretButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildTurretButton);

	-- laser
	local laserButtonParams = guiParams["btnBuildLaser"];
	newBlankTower.buildLaserButton = widget.newButton({
		width = laserButtonParams["width"],
		height = laserButtonParams["height"],
		left = laserButtonParams["left"],
		top = laserButtonParams["top"],
		isEnabled = laserButtonParams["isEnabled"],
		defaultFile = laserButtonParams["image"]
	});

	newBlankTower.buildLaserButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildLaserButton);
	
	-- rocket
	local rocketButtonParams = guiParams["btnBuildRocket"];
	newBlankTower.buildRocketButton = widget.newButton({
		width = rocketButtonParams["width"],
		height = rocketButtonParams["height"],
		left = rocketButtonParams["left"],
		top = rocketButtonParams["top"],
		isEnabled = rocketButtonParams["isEnabled"],
		defaultFile = rocketButtonParams["image"]
	});

	newBlankTower.buildRocketButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildRocketButton);

	-- plasma
	local plasmaButtonParams = guiParams["btnBuildPlasma"];
	newBlankTower.buildPlasmaButton = widget.newButton({
		width = plasmaButtonParams["width"],
		height = plasmaButtonParams["height"],
		left = plasmaButtonParams["left"],
		top = plasmaButtonParams["top"],
		isEnabled = plasmaButtonParams["isEnabled"],
		defaultFile = plasmaButtonParams["image"]
	});

	newBlankTower.buildPlasmaButton.alpha = 0;
	newBlankTower.blankTowerGroup:insert(newBlankTower.buildPlasmaButton);

	setmetatable(newBlankTower, blankTower_mt);

	newBlankTower:listen();

	return newBlankTower;
end

function blankTowerClass:hideMenu()
	-- FIXME: objects must be properly deleted
	if (self.menu == nil) then
		return
	end

	self.menu.alpha = 0;

	self.buildTurretButton.alpha = 0;
	self.buildTurretButton:setEnabled(false);

	self.buildRocketButton.alpha = 0;
	self.buildRocketButton:setEnabled(false);

	self.buildLaserButton.alpha = 0;
	self.buildLaserButton:setEnabled(false);

	self.buildPlasmaButton.alpha = 0;
	self.buildPlasmaButton:setEnabled(false);
end

function blankTowerClass:setDisplayPosition(x, y)
	self.blankTowerGroup.x = x;
	self.blankTowerGroup.y = y;
end

function blankTowerClass:touch(event)
	-- check resources

	self.menu.alpha = 1;

	if ( self.level:checkResourcesBuild("turret") == true ) then
		self.buildTurretButton.alpha = 1;
		self.buildTurretButton:setEnabled(true);
	else
		self.buildTurretButton.alpha = 0.5;
		self.buildTurretButton:setEnabled(false);
	end

	if ( self.level:checkResourcesBuild("rocket") == true ) then
		self.buildRocketButton.alpha = 1;
		self.buildRocketButton:setEnabled(true);
	else
		self.buildRocketButton.alpha = 0.5;
		self.buildRocketButton:setEnabled(false);		
	end

	if ( self.level:checkResourcesBuild("laser") == true ) then
		self.buildLaserButton.alpha = 1;
		self.buildLaserButton:setEnabled(true);
	else
		self.buildLaserButton.alpha = 0.5;
		self.buildLaserButton:setEnabled(false);		
	end

	if ( self.level:checkResourcesBuild("rocket") == true ) then
		self.buildPlasmaButton.alpha = 1;
		self.buildPlasmaButton:setEnabled(true);
	else
		self.buildPlasmaButton.alpha = 0.5;
		self.buildPlasmaButton:setEnabled(false);
	end

	return true;
end

function blankTowerClass:destroyBlankTower()
	if (self.image ~= nil) then 
		self.image:removeSelf(); 
		self.image = nil;
	end

	if (self.menu ~= nil) then
		self.menu:removeSelf();
		self.menu = nil;
	end	

	if (self.buildTurretButton ~= nil) then
		self.buildTurretButton:removeSelf();
		self.buildTurretButton = nil;
	end

	if (self.buildLaserButton ~= nil) then
		self.buildLaserButton:removeSelf();
		self.buildLaserButton = nil;
	end

	if (self.buildRocketButton ~= nil) then
		self.buildRocketButton:removeSelf();
		self.buildRocketButton = nil;
	end

	if (self.buildPlasmaButton ~= nil) then
		self.buildPlasmaButton:removeSelf();
		self.buildPlasmaButton = nil;
	end

	if (self.blankTowerGroup ~= nil) then
		self.blankTowerGroup:removeSelf();
		self.blankTowerGroup = nil;
	end
end

function blankTowerClass:buildTowerTouch(self, event, type)
	self.level:buildTower(self, event, type);
end

function blankTowerClass:listen()
	local blankTower = self;

	self.image.touch = function (self, event)
		blankTower:touch(event)

		return true;
	end

	self.buildTurretButton.touch = function (self, event)
		blankTower:buildTowerTouch(blankTower, event, "turret");
		return true;
	end

	self.buildLaserButton.touch = function (self, event)
		blankTower:buildTowerTouch(blankTower, event, "laser");
		return true;
	end

	self.buildRocketButton.touch = function (self, event)
		blankTower:buildTowerTouch(blankTower, event, "rocket");
		return true;
	end

	self.buildPlasmaButton.touch = function (self, event)
		blankTower:buildTowerTouch(blankTower, event, "plasma");
		return true;
	end

	self.buildTurretButton:addEventListener("touch", self.buildTurretButton);
	self.buildLaserButton:addEventListener("touch", self.buildLaserButton);
	self.buildRocketButton:addEventListener("touch", self.buildRocketButton);
	self.buildPlasmaButton:addEventListener("touch", self.buildPlasmaButton);

	self.image:addEventListener("touch", self.image);
end

return blankTowerClass;


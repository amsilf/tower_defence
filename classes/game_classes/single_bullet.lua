-----------------------------------------------------------------------------------------
--
-- single_bullet.lua
--
-----------------------------------------------------------------------------------------

local physics = require("physics");

singleBulletClass = {};

singleBulletClass = {
	x = nil,
	y = nil,

	aim = nil,

	speed = 100,

	bulletObject = nil,

	damage = nil

};

local singleBulletClass_mt = { __index = singleBulletClass }

function singleBulletClass.new(x, y)
	local newBullet = {
		x = 0,
		y = 0,

		aim = nil,

		speed = 100,

		bulletObject = nil,

		damage = 10
	};

	newBullet.bulletObject = display.newCircle( 10, 10, 10 );
	physics.addBody(newBullet.bulletObject, "dynamic", { radius=10 });

	newBullet.bulletObject.gravityScale = 0;

	newBullet.bulletObject.isBullet = true;

	newBullet.bulletObject.x = x;
	newBullet.bulletObject.y = y;

	setmetatable(newBullet, singleBulletClass_mt);

	return newBullet;
end

function singleBulletClass:setAim(aim)
	self.aim = aim;
end

return singleBulletClass;


	-----------------------------------------------------------------------------------------
--
-- single_bullet.lua
--
-----------------------------------------------------------------------------------------

local physics = require("physics");

singleBulletClass = {};

singleBulletClass = {
	id = 0,
	x = nil,
	y = nil,

	aim = nil,

	speed = 100,

	bulletObject = nil,

	damage = nil

};

local singleBulletClass_mt = { __index = singleBulletClass }

function singleBulletClass.new(x, y, id)
	local newBullet = {
		id = 0,

		x = 0,
		y = 0,

		aim = nil,

		speed = 100,

		bulletObject = nil,

		damage = 10
	};

	newBullet.id = id;

	newBullet.bulletObject = display.newCircle(10, 10, 10);

	newBullet.bulletObject.fill.effect = "generator.sunbeams";
	newBullet.bulletObject.fill.effect.posX = 0.5;
	newBullet.bulletObject.fill.effect.posY = 0.5;
	newBullet.bulletObject.fill.effect.aspectRatio = 1;
	newBullet.bulletObject.fill.effect.seed = 0;

	newBullet.bulletObject.x = x;
	newBullet.bulletObject.y = y;

	setmetatable(newBullet, singleBulletClass_mt);

	return newBullet;
end

function singleBulletClass:removeBullet()
	if (self.bulletObject ~= nil) then
		self.bulletObject:removeSelf();
	end
end

function singleBulletClass:setAim(aim)
	self.aim = aim;
end

return singleBulletClass;


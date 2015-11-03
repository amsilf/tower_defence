-----------------------------------------------------------------------------------------
--
-- single_bullet.lua
--
-----------------------------------------------------------------------------------------

local physics = require("physics");

singleBulletClas = {};

singleBulletClas = {
	x = nil,
	y = nil,

	bulletObject = nil,

	damage = nil

};

local singleBulletClas_mt = { __index = singleBulletClas }

function singleBulletClas.new(x, y)
	local newBullet = {
		x = 0,
		y = 0,

		bulletObject = nil,

		damage = 10
	};

	print("new bullet");

	newBullet.bulletObject = display.newCircle( 100, 100, 10 );
	physics.addBody(newBullet.bulletObject, "dynamic", { radius=10 });

	newBullet.bulletObject.gravityScale = 0;

	newBullet.bulletObject.isBullet = true;

	newBullet.bulletObject:setLinearVelocity( 800, 0);

	setmetatable(newBullet, singleBulletClas_mt);

	return newBullet;
end

return singleBulletClas;
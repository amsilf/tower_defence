-----------------------------------------------------------------------------------------
--
-- bullets_pool.lua
--
-----------------------------------------------------------------------------------------

local singleBulletClass = require("classes.game_classes.single_bullet");

bulletsPoolClass = {};

bulletsPoolClass = {
	bullets = {}
};

function bulletsPoolClass:shot(tower)
	local newBullet = singleBulletClass.new();

	-- FIXME: for test
	newBullet.bulletObject.x = 100;
	newBullet.bulletObject.x = 100;

	table.insert(self.bullets, newBullet);
end

function bulletsPoolClass:moveBullets()
end

return bulletsPoolClass;
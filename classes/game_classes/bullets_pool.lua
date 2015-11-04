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
	if (tower.aim == nil or tower.aim.unit == nil) then
		return;
	end

	local towerX = tower.towerGroup.x;
	local towerY = tower.towerGroup.y;

	local currLinearVelocity = self:calculateLinearVelocity(tower.aim, towerX, towerY);

	local newBullet = singleBulletClass.new(towerX, towerY);

	newBullet:setAim(tower.aim);

	newBullet.bulletObject:setLinearVelocity(currLinearVelocity.x * newBullet.speed, currLinearVelocity.y * newBullet.speed);

	table.insert(self.bullets, newBullet);
end

function bulletsPoolClass:calculateLinearVelocity(aim, currX, currY)
	local aimX = aim.unit.unitGroup.x;
	local aimY = aim.unit.unitGroup.y;

	local deltaX = aimX - currX;
	local deltaY = aimY - currY;

	local normDeltaX = deltaX / math.sqrt(math.pow(deltaX, 2) + math.pow(deltaY, 2));
	local normDeltaY = deltaY / math.sqrt(math.pow(deltaX, 2) + math.pow(deltaY, 2));

	return { x = normDeltaX, y = normDeltaY };
end

return bulletsPoolClass;



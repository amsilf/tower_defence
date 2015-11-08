-----------------------------------------------------------------------------------------
--
-- bullets_pool.lua
--
-----------------------------------------------------------------------------------------

local singleBulletClass = require("classes.game_classes.single_bullet");

bulletsPoolClass = {};

bulletsPoolClass = {
	currBulletId = 0,
	bullets = {}
};

function bulletsPoolClass:shot(tower)
	if (tower.aim == nil or tower.aim.unit == nil) then
		return;
	end

	self.currBulletId = self.currBulletId + 1;

	local towerX = tower.towerGroup.x;
	local towerY = tower.towerGroup.y;

	local currLinearVelocity = self:calculateLinearVelocity(tower.aim, towerX, towerY);

	local newBullet = singleBulletClass.new(towerX, towerY);

	newBullet:setAim(tower.aim);

	newBullet.bulletObject:setLinearVelocity(currLinearVelocity.x * newBullet.speed, currLinearVelocity.y * newBullet.speed);
	newBullet.bulletObject["id"] = self.currBulletId;

	table.insert(self.bullets, newBullet);
end

function bulletsPoolClass:onGlobalCollision(event)
	print("COLLISON obj1 = [ " .. event.object1["id"] .. " ], obj2 = [ " .. event.object2["id"] .. " ]");

	local id1 = event.object1["id"];
	local id2 = event.object2["id"];

	if(event.phase == "end") then
		-- to avoid bullet to bullet collisons
		if ( string.starts(id1, "wave") == true or string.starts(id2, "wave") == true) then
			local splittedCompoundId = nil;
			if (string.starts(id1, "wave")) then
				splittedCompoundId = self.splitCompoundId(id1);
			else
				splittedCompoundId = self.splitCompoundId(id2);
			end

			-- FIXME: must be bullet params
			print("wave id [ " .. splittedCompoundId[0] .. "], [ " .. splittedCompoundId[1] .. " ]");
			self.level:handleCollision(splittedCompoundId[0], splittedCompoundId[1], nil);
		end
	end
end

function bulletsPoolClass:splitCompoundId(compoundId)
	return split(compoundId, "_");
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

-- FIXME move to utils
-- from http://lua-users.org/wiki/StringRecipes
function string.starts(String, Start)
   return string.sub(String,1,string.len(Start)) == Start
end

return bulletsPoolClass;



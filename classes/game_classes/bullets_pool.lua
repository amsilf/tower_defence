
-----------------------------------------------------------------------------------------
--
-- bullets_pool.lua
--
-----------------------------------------------------------------------------------------

local singleBulletClass = require("classes.game_classes.single_bullet");

bulletsPoolClass = {};

bulletsPoolClass = {
	currBulletId = 0,
	bullets = {},
	level = nil
};

function bulletsPoolClass.setLevel(parentLevel)
	bulletsPoolClass.level = parentLevel;
end

function bulletsPoolClass:shot(tower)
	if (tower.aim == nil or tower.aim.unit == nil) then
		return;
	end

	self.currBulletId = self.currBulletId + 1;

	local towerX = tower.towerGroup.x;
	local towerY = tower.towerGroup.y;

	local currLinearVelocity = self:calculateLinearVelocity(tower.aim, towerX, towerY);

	local newBullet = singleBulletClass.new(towerX, towerY, self.currBulletId);
	-- FIXME do we need to store bullets?
	table.insert(self.bullets, newBullet);

	newBullet.bulletObject["aimID"] = tower.aim.unit["id"];

	transition.to(newBullet.bulletObject, {time = 100, x = tower.aim.unit.unitGroup.x, y = tower.aim.unit.unitGroup.y, 
		onComplete = bulletsPoolClass.calculateHit });
	--	onComplete = self:calculateHit(newBullet, tower.aim.unit["id"])});
end

function bulletsPoolClass.calculateHit( obj )
	obj:removeSelf();

	local splittedCompoundId = obj["aimID"]:split("_");
	bulletsPoolClass.level:handleHits(splittedCompoundId[2], splittedCompoundId[4], nil);
end

-- FIXME move into utils
function string:split( inSplitPattern, outResults )

   if not outResults then
      outResults = {}
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
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




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

function bulletsPoolClass:setLevel(level)
	self.level = level;
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
	table.insert(self.bullets, newBullet);

	newBullet:setAim(tower.aim);

	--newBullet.bulletObject:setLinearVelocity(currLinearVelocity.x * newBullet.speed, currLinearVelocity.y * newBullet.speed);
	-- FIMXE move parameters into config
	transition.to(newBullet.bulletObject, {time = 100, x = tower.aim.unit.unitGroup.x, y = tower.aim.unit.unitGroup.y, 
		onComplete = self:calculateHit(newBullet, tower.aim.unit["id"])});
end

function bulletsPoolClass:calculateHit(bullet, unitId)
	local splittedCompoundId = unitId:split("_");
	print("compound unit id [ " .. unitId .. " ]");
	print("wave id [ " .. splittedCompoundId[2] .. " ], unit id [ " .. splittedCompoundId[4] .. " ]");

	-- FIXME: must be bullet params
	self.level:handleHits(splittedCompoundId[2], splittedCompoundId[4], nil);
--	bullet:removeBullet();
--	bullet = nil;
end

--[[
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
--]]

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

-- FIXME move to utils
-- from http://lua-users.org/wiki/StringRecipes
--[[
function string.starts(String, Start)
   return string.sub(String,1,string.len(Start)) == Start
end
--]]

return bulletsPoolClass;



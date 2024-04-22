-- Original
local function releaseStorage(player)
	player:setStorageValue(1000, -1)
end

function onLogout(player)
	if player:getStorageValue(1000) == 1 then
		addEvent(releaseStorage, 1000, player)
	end
	return true
end

-- Fixed
local function releaseStorage(player)
	-- Why 1000? Should this be changed to a parameter fed by the call in onLogout? Is releaseStorage a multipurpose function?
	player:setStorageValue(1000, -1)
end

-- Does this need to be a global function?
function onLogout(player)
	-- Does this check need to be here? Can it be in the releaseStorage function?
	if player:getStorageValue(1000) == 1 then
		-- I admit that I'm not sure what's wanted here. I changed the asynchronous call to an immediate one, as the one-second grace period seems like it has a lot of potential for unintended race conditions. Even so, I don't feel that I have enough context to answer this question properly. Depending on the needs or tendencies, I could also see the use of changing this line to be an addEvent call with 0 or 1 ms (to maintain the asynchronous nature), or writing out the releaseStorage function within the addEvent call. I've added examples of such below, in commented form.
		releaseStorage(player)
		
		-- addEvent(releaseStorage, 0, player)
		
		--[[
		addEvent(function(player) 
				player:setStorageValue(1000, -1)
			end,
			1000, player
		)
		--]]
		
	end
	-- Why does the function return true no matter what? Should this be removed? Is it used for some purpose elsewhere?
	return true
end
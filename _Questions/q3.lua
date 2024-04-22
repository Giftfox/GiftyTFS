-- Original
function do_sth_with_PlayerParty(playerId, membername)
	player = Player(playerId)
	local party = player:getParty()

	for k,v in pairs(party:getMembers()) do
		if v == Player(membername) then
			party:removeMember(Player(membername))
		end
	end
end 

-- Fixed
-- This appears to be a function that searches for a party member by name, iterates through the list of a given player's party members, then deletes the member from the party if found. I have renamed the function accordingly.
-- As playerId and memberId serve similar functions, I have renamed the membername variable to align better with this shared behaviour.
function playerParty_KickMemberById(playerId, memberId)
	player = Player(playerId)
	local party = player:getParty()

	-- Replaced pairs loop with a simpler iteration format, as the paired index was not utilized
	-- Renamed "v" to better match the content iterated through
	for partymember in party:getMembers() do
		if partymember == Player(memberId) then
			-- This is a really minor change, but I switched which variable is used as a parameter, to eliminate one extra Player(x) call.
			party:removeMember(partymember)
			
			-- Added a break within the loop in the case that the task is accomplished early
			break
		end
	end
end 
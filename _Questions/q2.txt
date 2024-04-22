-- Original
function printSmallGuildNames(memberCount)
	-- this method is supposed to print names of all guilds that have less than memberCount max members
	local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
	local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
	local guildName = result.getString("name")
	print(guildName)
end 

-- Fixed
function printSmallGuildNames(memberCount)
	-- this method is supposed to print names of all guilds that have less than memberCount max members
	
	-- Added quotations to query parameters to align with literal value syntax
	local selectGuildQuery = "SELECT 'name' FROM 'guilds' WHERE 'max_members' < %d;"
	local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
	
	-- resultId was never used. I've added it to the result.getString call, so that its data can be retrieved.
	local guildName = result.getString(resultId, "name")
	print(guildName)
	
	-- Freeing stored query values during function cleanup
	result.free(resultId)
end 
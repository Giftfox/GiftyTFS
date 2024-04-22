// Original
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	Player* player = g_game.getPlayerByName(recipient);
	if (!player) {
		player = new Player(nullptr);
		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);
	if (!item) {
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
	}
} 

// Fixed
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	Player* player = g_game.getPlayerByName(recipient);
	if (!player) {
		player = new Player(nullptr);
		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			// In the case of premature exit, destroy the created pointer
			delete player;
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);
	if (!item) {
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
	}
} 
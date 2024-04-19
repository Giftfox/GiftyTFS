-- combat is for actual effect creation, combat_test is for testing tiles to create a randomized selection
local combat = Combat()
local combat_test = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)

local area = {
	{0, 0, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 2, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 0, 0}
}
-- Set the range of tested tiles based on the combat area
combat_test:setArea(createCombatArea(area))

-- Used to determine how many repeat casts are performed
local casts = 0

local saved_creature

function delayCast(creature, variant)
	if creature ~= nil then
		saved_creature = creature
	end
	-- Prep the next repeated cast, unless there are no casts left
	casts = casts - 1
	if casts > 0 then
		-- Delay the next repeated cast by a short time
		addEvent(delayCast, 300, nil, variant)
	end

	-- Each time a repeat cast is performed, run a test using combat_test
	return combat_test:execute(saved_creature, variant)
end

function onTargetTile(creature, pos)
	-- For each tile, run a random check to see if the actual effect is played on that tile
	if math.random(3) == 1 then
		combat:execute(creature, positionToVariant(pos))
	end
end

combat_test:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function onCastSpell(creature, variant)
	-- Choose how many times to repeatedly cast the spell's effects, then start repeating the casts
	casts = 10
	return delayCast(creature, variant)
end

local windows = {}

local pos = {x = 200, y = 0}
local toggleButton = nil
local jumpWindow = nil


function init()
	-- Adds a button to the top panel for testing purposes. I borrowed the spell list icon for this test
	toggleButton = modules.client_topmenu.addRightGameToggleButton('toggleButton', tr('Test'), '/images/topbuttons/spelllist', toggle)
	toggleButton:setOn(false)
	g_ui.importStyle('jumpwindow')

	jumpWindow = g_ui.createWidget('JumpWindow', rootWidget)
	jumpWindow:hide()

	connect(g_game, { onGameEnd = destroyWindows })
end

function terminate()
	disconnect(g_game, { onGameEnd = destroyWindows })

	destroyWindows()
end

-- Clear the UI when the player logs out, or on force-quit
function destroyWindows()
	toggleButton:destroy()
	jumpWindow:destroy()
end

-- Switch between open and closed states
function toggle()
	if toggleButton:isOn() then
		toggleButton:setOn(false)
		jumpWindow:hide()
	else
		toggleButton:setOn(true)
		jumpWindow:show()
		-- Make sure that the moving-button system initializes when the window is opened
		resetPos()
		step()
	end
end

function resetPos()
	pos.x = 200
	pos.y = math.random(0, 220)
end

-- Resets the button (and loop timer) when the button is clicked
function onClick()
	resetPos()
	step()
end


local timed_step = nil
function step()
	-- Check the open state first - it's important to cancel the looping function once the window is no longer active
	if toggleButton:isOn() then
		local jumpButton = jumpWindow:getChildById('mainButton')

		-- Decrement the button's x position, and reset the position once it hits the given lower threshold
		pos.x = pos.x - 10
		if pos.x < 0 then
			resetPos()
		end

		-- Adjust the position via the button's margins comparative to the main window
		jumpButton:setMarginLeft(pos.x)
		jumpButton:setMarginTop(pos.y)

		-- Prepare the function to be looped, to create a moving button effect
		-- The scheduled event id is saved, and removed in the case of a manual call of this function - this way, the function will only ever be in one loop at a time
		if timed_step then
			removeEvent(timed_step)
		end
		timed_step = scheduleEvent(step, 100)
	end
end

-- imports
active_screen = require 'active_screen'
game_view = require 'game_view'
level_select_view = require 'level_select_view'
level_list = require 'level_list'

function exports()
	local instance = {}

	local background = love.graphics.newImage('background/title_background.png')
	local newGameButton = love.graphics.newImage('initial_menu/new_game.png')
	local levelSelectButton = love.graphics.newImage('initial_menu/level_select.png')
	local endGameButton = love.graphics.newImage('initial_menu/exit.png')
	local newGameX = 470
	local newGameY = 300
	local newGameWidth = 300
	local newGameHeight = 100
	local gap = 10
	local levelSelectY = newGameY + newGameHeight + gap
	local endGameY = levelSelectY + newGameHeight + gap

	function instance:draw()
		love.graphics.setColor(255,255,255)
		love.graphics.draw(background, 0, 0)
		love.graphics.draw(newGameButton, newGameX, newGameY)
		love.graphics.draw(levelSelectButton, newGameX, levelSelectY)
		love.graphics.draw(endGameButton, newGameX, endGameY)
	end

	function is_menu_option_selected(mouse_x, mouse_y, start_x, start_y)
		return love.mouse.isDown("l") and mouse_x > start_x and mouse_x <= start_x + newGameWidth and mouse_y > start_y and mouse_y <= start_y + newGameHeight
	end

	function instance:update()
		mouse_x, mouse_y = love.mouse.getPosition()

		if is_menu_option_selected(mouse_x, mouse_y, newGameX, newGameY) then
			game_view = require 'game_view'
			active_screen.set(game_view(level_list.first_level()))
			return
		end

		if is_menu_option_selected(mouse_x, mouse_y, newGameX, levelSelectY) then
			active_screen.set(level_select_view())
			return
		end

		if is_menu_option_selected(mouse_x, mouse_y, newGameX, endGameY) then
			love.event.quit()
		end
	end

	return instance
end

return exports
-- imports
active_screen = require 'active_screen'
game_view = require 'game_view'
level_list = require 'level_list'

function exports()
	local instance = {}

	local background = love.graphics.newImage('background/title_background.png')
	local newGameButton = love.graphics.newImage('initial_menu/new_game.png')
	local endGameButton = love.graphics.newImage('initial_menu/exit.png')
	local newGameX = 470
	local newGameY = 200
	local newGameWidth = 300
	local newGameHeight = 100
	local gap = 10
	local endGameY = newGameY + newGameHeight + gap

	function instance:draw()
		love.graphics.setColor(255,255,255)
		love.graphics.draw(background, 0, 0)
		love.graphics.draw(newGameButton, newGameX, newGameY)
		love.graphics.draw(endGameButton, newGameX, endGameY)
	end

	function instance:update()
		mouse_x, mouse_y = love.mouse.getPosition()

		if love.mouse.isDown("l") and mouse_x > newGameX and mouse_x <= newGameX + newGameWidth and mouse_y > newGameY and mouse_y <= newGameY + newGameHeight then
			game_view = require 'game_view'
			active_screen.set(game_view(level_list.first_level()))
			return
		end

		if love.mouse.isDown("l") and mouse_x > newGameX and mouse_x <= newGameX + newGameWidth and mouse_y > endGameY and mouse_y <= endGameY + newGameHeight then
			love.event.quit()
		end
	end

	return instance
end

return exports
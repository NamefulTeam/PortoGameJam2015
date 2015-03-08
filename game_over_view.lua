-- imports
active_screen = require 'active_screen'

function exports(level_description)
	local instance = {}

	local background = love.graphics.newImage('background/title_background.png')
	local gameOverImage = love.graphics.newImage('background/gameOverBackground.png')
	local newGameButton = love.graphics.newImage('placeholders/new_game.png')
	local mainMenuButton = love.graphics.newImage('placeholders/main_menu.png')
	local newGameButtonX = 420
	local newGameButtonY = 550
	local newGameButtonWidth = 200
	local newGameButtonHeight = 150
	local mainMenuButtonX = newGameButtonX + newGameButtonWidth + 50

	function instance:draw()
		love.graphics.setColor(80,80,80)
		love.graphics.draw(background, 0, 0)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(gameOverImage, 350, 100)
		love.graphics.draw(newGameButton, newGameButtonX, newGameButtonY)
		love.graphics.draw(mainMenuButton, mainMenuButtonX, newGameButtonY)
	end

	function instance:update()
		mouse_x, mouse_y = love.mouse.getPosition()

		if love.mouse.isDown("l") then
			if mouse_x > newGameButtonX and mouse_x <= newGameButtonX + newGameButtonWidth and mouse_y > newGameButtonY and mouse_y <= newGameButtonY + newGameButtonHeight then
				game_view = require 'game_view'
				active_screen.set(game_view(level_description))
				return
			elseif mouse_x > mainMenuButtonX and mouse_x <= mainMenuButtonX + newGameButtonWidth and mouse_y > newGameButtonY and mouse_y <= newGameButtonY + newGameButtonHeight then
				initial_menu_view = require 'initial_menu_view'
				active_screen.set(initial_menu_view())
				return
			end
		end
	end

	return instance
end

return exports
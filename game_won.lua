-- imports
active_screen = require 'active_screen'

numberOfRounds = 5

function exports()
	local instance = {}

	local background = love.graphics.newImage('background/background_light.png')
	local gameOverImage = love.graphics.newImage('background/gameWonBackground.png')
	local newGameButton = love.graphics.newImage('placeholders/new_game.png')

	function instance:draw()
		love.graphics.setColor(80,80,80)
		love.graphics.draw(background, 0, 0)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(gameOverImage, 350, 150)
		love.graphics.draw(newGameButton, 550, 550)
	end

	function instance:update()
		mouse_x, mouse_y = love.mouse.getPosition()

		if love.mouse.isDown("l") and mouse_x > 550 and mouse_x <= 750 and mouse_y > 550 and mouse_y <= 700 then
			game_view = require 'game_view'
			active_screen.set(game_view(numberOfRounds))
			return
		end
	end

	return instance
end

return exports
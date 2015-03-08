-- imports
active_screen = require 'active_screen'

numberOfRounds = 5

function exports()
	local instance = {}

	local background = love.graphics.newImage('background/background_light.png')
	local gameOverImage = love.graphics.newImage('background/gameWonBackground.png')
	local mainMenuButton = love.graphics.newImage('placeholders/main_menu2.png')

	function instance:draw()
		love.graphics.setColor(0,10,145)
		love.graphics.draw(background, 0, 0)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(gameOverImage, 350, 150)
		love.graphics.draw(mainMenuButton, 550, 450)
	end

	function instance:update()
		mouse_x, mouse_y = love.mouse.getPosition()

		if love.mouse.isDown("l") and mouse_x > 550 and mouse_x <= 800 and mouse_y > 450 and mouse_y <= 510 then
			initial_menu_view = require 'initial_menu_view'
			active_screen.set(initial_menu_view())
			return
		end
	end

	return instance
end

return exports
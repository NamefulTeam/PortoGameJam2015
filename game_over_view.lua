function exports()
	local instance = {}

	local background = love.graphics.newImage('background/background_light.png')
	local gameOverImage = love.graphics.newImage('background/gameOverBackground.png')

	function instance:draw()
		love.graphics.setColor(80,80,80)
		love.graphics.draw(background, 0, 0)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(gameOverImage, 350, 150)
	end

	function instance:update()

	end

	return instance
end

return exports
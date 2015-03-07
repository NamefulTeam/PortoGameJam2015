function exports()
	local instance = {}

	local background = love.graphics.newImage('background/background_light.png')

	function instance:draw()
		love.graphics.setColor(50,50,50)
		love.graphics.draw(background, 0, 0)
	end

	function instance:update()

	end

	return instance
end

return exports
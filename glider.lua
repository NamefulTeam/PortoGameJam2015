function exports(x, y, direction)
	local instance = {}

	instance.x = x
	instance.y = y
	instance.direction = direction

	instance.image = love.graphics.newImage('placeholders/glider.png')
	instance.quad = love.graphics.newQuad(0, 0, 32, 32, 32, 32)

	function instance:draw(offset_x, offset_y)
		local actual_x = offset_x + self.x * 32
		local actual_y = offset_y + self.y * 32

		love.graphics.draw(self.image, self.quad, actual_x, actual_y)
	end

	return instance
end

return exports

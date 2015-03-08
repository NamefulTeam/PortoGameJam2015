function exports(x, y, direction)
	local instance = {}

	instance.x = x
	instance.y = y
	instance.type = 'diverter'
	instance.direction = direction

	instance.image = love.graphics.newImage('placeholders/switch_direction.png')
	instance.quad = love.graphics.newQuad(0, 0, 32, 32, 32, 32)

	function instance:draw(offset_x, offset_y)
		local actual_x = offset_x + self.x * 32
		local actual_y = offset_y + self.y * 32
		
		love.graphics.setColor(255,255,255)
		love.graphics.draw(self.image, self.quad, actual_x - 16, actual_y - 16, directions.get_angle(self.direction), 1, 1, 16, 16)
	end

	return instance
end

return exports

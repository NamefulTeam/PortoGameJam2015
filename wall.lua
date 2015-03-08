local function exports(x, y)
	local instance = {}
	instance.type = 'wall'
	instance.x = x
	instance.y = y
	instance.isDead = false

	instance.image = love.graphics.newImage('placeholders/wall.png')
	instance.quad = love.graphics.newQuad(0, 0, 32, 32, 32, 32)

	function instance:update()
	end

	function instance:draw(offsetx, offsety)
		love.graphics.draw(instance.image, instance.quad, offsetx + (self.x - 1) * 32, offsety + (self.y - 1) * 32)
	end

	return instance
end

return exports

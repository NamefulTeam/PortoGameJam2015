directions = require 'directions'

local function exports(x, y, direction)
	assert(directions.is_direction(direction))

	local instance = {}
	instance.type = 'glider'
	instance.x = x
	instance.y = y
	instance.direction = direction

	instance.image = love.graphics.newImage('placeholders/glider.png')
	instance.quad = love.graphics.newQuad(0, 0, 32, 32, 32, 32)

	function instance:update(grid)
		assert(grid:in_grid(self.x, self.y))

		local next_x = self.x + directions.get_x_diff(self.direction)
		local next_y = self.y + directions.get_y_diff(self.direction)

		if grid:in_grid(next_x, next_y) and not grid:get_space_at(next_x, next_y) then

			local found_object = grid:get_object_at(next_x, next_y)
			if found_object == nil then
				grid:set_space_at(self.x, self.y, true)

				self.x = next_x
				self.y = next_y
			elseif found_object.type == 'glider' then
				-- Blow up
				self:explode(grid, found_object)
			end
		else
			self.direction = directions.invert(self.direction)
		end
	end

	function instance:explode(grid, other_object)
		grid:delete_object(self)
		grid:delete_object(other_object)
	end

	function instance:draw(offset_x, offset_y)
		local actual_x = offset_x + self.x * 32
		local actual_y = offset_y + self.y * 32

		love.graphics.draw(self.image, self.quad, actual_x - 16, actual_y - 16, directions.get_angle(self.direction), 1, 1, 16, 16)
	end

	return instance
end

return exports

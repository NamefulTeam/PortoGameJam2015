directions = require 'directions'
glider = require 'glider'

local function exports(x, y, direction)
	assert(directions.is_direction(direction))

	local instance = {}
	instance.type = 'watcher'
	instance.x = x
	instance.y = y
	instance.direction = direction
	instance.isDead = false

	instance.image = love.graphics.newImage('placeholders/watcher.png')
	instance.quad = love.graphics.newQuad(0, 0, 32, 32, 32, 32)

	function instance:update(grid)
		assert(grid:in_grid(self.x, self.y))

		--find dirty cells
		if grid:get_space_at(self.x+1, self.y) then
			self.direction = directions.RIGHT
		elseif grid:get_space_at(self.x-1, self.y) then
			self.direction = directions.LEFT
		elseif grid:get_space_at(self.x, self.y+1) then
			self.direction = directions.DOWN
		elseif grid:get_space_at(self.x, self.y-1) then
			self.direction = directions.UP
		end

		--find close gliders
		if grid:get_object_at(self.x+1, self.y) and grid:get_object_at(self.x+1, self.y).type == 'glider' then
			self.direction = directions.RIGHT
		elseif grid:get_object_at(self.x-1, self.y) and grid:get_object_at(self.x-1, self.y).type == 'glider'then
			self.direction = directions.LEFT
		elseif grid:get_object_at(self.x, self.y+1) and grid:get_object_at(self.x, self.y+1).type == 'glider' then
			self.direction = directions.DOWN
		elseif grid:get_object_at(self.x, self.y-1) and grid:get_object_at(self.x, self.y-1).type == 'glider' then
			self.direction = directions.UP
		end

		local next_x = self.x + directions.get_x_diff(self.direction)
		local next_y = self.y + directions.get_y_diff(self.direction)

		if grid:in_grid(next_x, next_y) then
			if grid:get_space_at(next_x, next_y) then
				grid:set_space_at(next_x, next_y, false)
			end
			local object = grid:get_object_at(next_x, next_y)
			if object and object.type == 'glider' then
				object.isDead = true
				self.x = next_x
				self.y = next_y
			elseif object and object.type == 'watcher' then
				self.direction = directions.invert(self.direction)
			else
				self.x = next_x
				self.y = next_y
			end
		else
			self.direction = directions.invert(self.direction)
		end
	end

	function instance:suffer_explosion(grid)
		grid:replace_object(self, glider(self.x, self.y, self.direction))
	end

	function instance:draw(offset_x, offset_y)
		local actual_x = offset_x + self.x * 32
		local actual_y = offset_y + self.y * 32

		love.graphics.setColor(255,255,255)
		love.graphics.draw(self.image, self.quad, actual_x - 16, actual_y - 16, directions.get_angle(self.direction), 1, 1, 16, 16)
	end

	return instance
end

return exports

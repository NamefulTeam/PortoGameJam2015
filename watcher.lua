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

	function instance:update(grid, pending_events)
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
			if object then
				if object.type == 'glider' then
					object.isDead = true
					self.x = next_x
					self.y = next_y
				elseif object.type == 'watcher' or object.type == 'wall' then
					self.direction = directions.invert(self.direction)
				end 
			else
				self.x = next_x
				self.y = next_y

				local tile_at_new_position = grid:get_tile_at(next_x, next_y)
				if tile_at_new_position ~= nil then
					if tile_at_new_position.type == 'diverter' then
						self.direction = tile_at_new_position.direction
					end
				end
			end
		else
			self.direction = directions.invert(self.direction)
		end
	end

	function instance:compute_relative_direction(other_x, other_y)
		assert(self.x ~= other_x or self.y ~= other_y)

		if self.y < other_y and self.x <= other_x then
			return directions.UP
		elseif self.x > other_x and self.y <= other_y then
			return directions.RIGHT
		elseif self.y > other_y and self.x >= other_x then
			return directions.DOWN
		else
			return directions.LEFT
		end
	end

	function instance:suffer_explosion(grid, pending_events, explosion_center_x, explosion_center_y)
		self.highlight_death = true
		table.insert(pending_events, function()
			self.isDead = true
			grid:add_object(glider(self.x, self.y, self:compute_relative_direction(explosion_center_x, explosion_center_y)))
		end)
	end

	function instance:draw(offset_x, offset_y)
		local actual_x = offset_x + self.x * 32
		local actual_y = offset_y + self.y * 32

		if self.highlight_death then
			love.graphics.setColor(255, 0, 0)
			love.graphics.rectangle('line', actual_x - 32, actual_y - 32, 32, 32)
		end

		love.graphics.setColor(255,255,255)
		love.graphics.draw(self.image, self.quad, actual_x - 16, actual_y - 16, directions.get_angle(self.direction), 1, 1, 16, 16)
	end

	return instance
end

return exports

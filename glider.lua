directions = require 'directions'

local function exports(x, y, direction)
	assert(directions.is_direction(direction))

	local instance = {}
	instance.type = 'glider'
	instance.x = x
	instance.y = y
	instance.direction = direction
	instance.isDead = false

	instance.image = love.graphics.newImage('placeholders/glider.png')
	instance.quad = love.graphics.newQuad(0, 0, 32, 32, 32, 32)

	function instance:update(grid, pending_events)
		assert(grid:in_grid(self.x, self.y))
		assert(pending_events ~= nil)

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
				self:explode(grid, pending_events)
			elseif found_object.type == 'watcher' then
				instance.isDead = true
			end
		else
			grid:set_space_at(self.x, self.y, true)
			instance.isDead = true
		end
	end

	function instance:explode(grid, pending_events)
		assert(pending_events ~= nil)

		for dy = -1, 1 do
			for dx = -1, 1 do
				local x = self.x + dx
				local y = self.y + dy

				local object = grid:get_object_at(x, y)
				if object ~= nil and not object.isDead then
					object:suffer_explosion(grid, pending_events)
				else
					grid:set_space_at(x, y, true)
				end
			end
		end
	end

	function instance:suffer_explosion(grid, pending_events)
		instance.highlight_death = true
		table.insert(pending_events, function()
			instance.isDead = true
			table.insert(pending_events, function() self:explode(grid, pending_events) end)
		end)
	end

	function instance:draw(offset_x, offset_y)
		local actual_x = offset_x + self.x * 32
		local actual_y = offset_y + self.y * 32

		if self.highlight_death then
			love.graphics.setColor(255, 0, 0)
			love.graphics.setLineWidth(2)
			love.graphics.rectangle('line', actual_x - 32, actual_y - 32, 32, 32)
		end

		love.graphics.draw(self.image, self.quad, actual_x - 16, actual_y - 16, directions.get_angle(self.direction), 1, 1, 16, 16)
	end

	return instance
end

return exports

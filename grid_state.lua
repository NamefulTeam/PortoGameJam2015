local function exports(width, height)
	local grid = {}
	grid.data = {}
	grid.first_object = nil
	grid.last_object = nil

	function index(x, y)
		return (y - 1) * width + x
	end

	for y = 1, width do
		for x = 1, height do
			grid.data[index(x, y)] = false
		end
	end

	function grid:get_space_at(x, y)
		return self.data[index(x, y)]
	end

	function grid:set_space_at(x, y, value)
		self.data[index(x, y)] = value
	end

	function grid:add_object(object)
		assert(object.next == nil)
		assert(object.prev == nil)
		if grid.first_object == nil then
			assert(grid.last_object == nil)

			grid.first_object = object
			grid.last_object = object
		else
			assert(grid.last_object.next == nil)

			grid.last_object.next = object
			object.prev = grid.last_object

			grid.last_object = object
		end
	end

	function grid:delete_object(object)
		assert(object ~= nil)

		if grid.first_object == object then
			grid.first_object = object.next
		else
			object.prev.next = object.next
		end

		if grid.last_object == object then
			grid.last_object = object.prev
		else
			object.next.prev = object.prev
		end
	end

	function grid:replace_object(old_object, new_object)
		assert(old_object ~= nil)
		assert(new_object ~= nil)
		assert(new_object.prev == nil)
		assert(new_object.next == nil)

		if grid.first_object == old_object then
			grid.first_object = new_object
		end
		if grid.last_object == old_object then
			grid.last_object = new_object
		end

		if old_object.prev ~= nil then
			old_object.prev.next = new_object
		end
		if old_object.next ~= nil then
			old_object.next.prev = new_object
		end
	end

	function grid:get_object_at(x, y)
		local current_object = self.first_object
		while current_object ~= nil do
			if current_object.x == x and current_object.y == y then
				return current_object
			end
			current_object = current_object.next
		end

		return nil
	end

	function grid:draw_objects(offset_x, offset_y)
		local current_object = self.first_object
		while current_object ~= nil do
			current_object:draw(offset_x, offset_y)
			current_object = current_object.next
		end
	end

	function grid:update_objects()
		local current_object = self.first_object
		while current_object ~= nil do
			current_object:update(self)
			current_object = current_object.next
		end
	end

	function grid:in_grid(x, y)
		return x >= 1 and y >= 1 and x <= width and y <= height
	end

	return grid
end

return exports

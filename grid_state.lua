function exports(width, height)
	local grid = {}
	grid.data = {}
	grid.objects = {}

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

	function grid:get_object_at(x, y)
		for key, value in pairs(self.objects) do
			if value.x == x and value.y == y then
				return key, value
			end
		end

		return nil
	end

	function grid:draw_objects(offset_x, offset_y)
		for key, value in pairs(self.objects) do
			value:draw(offset_x, offset_y)
		end
	end

	function grid:update_objects()
		for key, value in pairs(self.objects) do
			value:update(self)
		end
	end

	return grid
end

return exports

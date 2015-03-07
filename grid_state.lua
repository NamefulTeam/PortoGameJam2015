function exports(width, height)
	local grid = {}
	grid.data = {}

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

	return grid
end

return exports

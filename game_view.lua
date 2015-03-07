background_color = {240, 240, 240}
grid_normal_color = {180, 230, 255}
grid_block_color = {100, 200, 250}
grid_line_width = 0.5
grid_unit_size = 32
grid_big_border = 5

function draw_line(grid_num, x1, y1, x2, y2)
	local is_main = grid_num % grid_big_border == 0

	local color = is_main and grid_block_color or grid_normal_color
	local width = grid_line_width

	love.graphics.setLineWidth(width)
	love.graphics.setColor(color[1], color[2], color[3])
	love.graphics.line(x1, y1, x2, y2)
end

function exports()
	local instance = {}

	local block_size = grid_unit_size * grid_big_border
	local xoffsets = 1280 % block_size
	if xoffsets == 0 then
		xoffsets = block_size
	end
	local xoffset = xoffsets / 2
	local xcount = (1280 - xoffsets) / grid_unit_size
	local yoffsets = 720 % block_size
	local yoffset = yoffsets / 2
	local ycount = (720 - yoffsets) / grid_unit_size

	function instance:draw()
		love.graphics.setColor(background_color[1], background_color[2], background_color[3])
		love.graphics.rectangle('fill', 0, 0, 1280, 720)

		-- Draw Grid
		local current_x = xoffset
		local grid_num = 0
		while grid_num <= xcount do
			draw_line(grid_num, current_x, yoffset, current_x, 720 - yoffset)

			current_x = current_x + grid_unit_size
			grid_num = grid_num + 1
		end

		local current_y = yoffset
		grid_num = 0
		while grid_num <= ycount do
			draw_line(grid_num, xoffset, current_y, 1280 - xoffset, current_y)

			current_y = current_y + grid_unit_size
			grid_num = grid_num + 1
		end
	end

	function instance:update()
	end

	return instance
end

return exports

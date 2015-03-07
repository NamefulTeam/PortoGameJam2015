-- imports
grid_state = require 'grid_state'
glitch_gen = require 'glitchGen'
directions = require 'directions'
glider = require 'glider'

background_color = {240, 240, 240}
grid_normal_color = {180, 230, 255}
grid_block_color = {100, 200, 250}
grid_line_width = 0.5
grid_unit_size = 32
grid_big_border = 5

-- mouse variables
mouse_x = 0;
mouse_y = 0;
mouseClicked = false;
lastFrameMouseClicked = false;

-- glider variables
rectanglesToDraw = {}
numberOfGliders = 0
gliderPlaced = false

-- grid state

-- visual glitch state
glitchUpdateTimer = 0.5

function draw_line(grid_num, x1, y1, x2, y2)
	local is_main = grid_num % grid_big_border == 0

	local color = is_main and grid_block_color or grid_normal_color
	local width = grid_line_width

	love.graphics.setLineWidth(width)
	love.graphics.setColor(color[1], color[2], color[3])
	love.graphics.line(x1, y1, x2, y2)
end

function processGoButtonClicked(grid_state)

	grid_state:update_objects()

	gliderPlaced = false;
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

	instance.grid_state = grid_state(xcount, ycount)


    instance.goButtonImage = love.graphics.newImage( "placeholders/goButton.png" )
    local goButtonX = (xcount - 2) * grid_unit_size + xoffset
    local goButtonY = (ycount + 1.4) * grid_unit_size
    local goButtonWidth = 64
    local goButtonHeight = 32

	function instance:draw()

		love.graphics.setColor(background_color[1], background_color[2], background_color[3])
		love.graphics.rectangle('fill', 0, 0, 1280, 720)

		-- Draw Grid
		local current_x = xoffset
		local grid_num = 0

		-- glider
		local drawGliderX = -1
		local drawGliderY = -1

		while grid_num <= xcount do
			draw_line(grid_num, current_x, yoffset, current_x, 720 - yoffset)

			if mouse_x >= current_x and mouse_x < current_x + grid_unit_size then
				drawGliderX = grid_num
			end

			current_x = current_x + grid_unit_size
			grid_num = grid_num + 1
		end

		local current_y = yoffset
		grid_num = 0
		while grid_num <= ycount do
			draw_line(grid_num, xoffset, current_y, 1280 - xoffset, current_y)

			if mouse_y >= current_y and mouse_y < current_y + grid_unit_size then
				drawGliderY = grid_num
			end
			
			current_y = current_y + grid_unit_size
			grid_num = grid_num + 1
		end

		if mouseClicked and drawGliderX >= 0 and drawGliderY >= 0 and drawGliderX < xcount and drawGliderY < ycount and 
			not self.grid_state:get_space_at(drawGliderX+1, drawGliderY+1) and not gliderPlaced then
			self.grid_state:add_object(glider(drawGliderX + 1, drawGliderY + 1, directions.DOWN))
			gliderPlaced = true
		end

		if glitchUpdateTimer > 0.2 then
			glitchUpdate = true
			glitchUpdateTimer = glitchUpdateTimer - 0.2
		end
		for i,rect in ipairs(rectanglesToDraw) do
			glitch_gen.drawGlich(rect["x"], rect["y"], xcount, glitchUpdate)
    	end
		glitchUpdate = false	

		self.grid_state:draw_objects(xoffset, yoffset)

		for x = 1, xcount, 1 do
			for y = 1, ycount, 1 do
				if self.grid_state:get_space_at(x, y) then
      				love.graphics.setColor(255,0,0)
					love.graphics.rectangle('fill', (x-1) * grid_unit_size + xoffset, (y-1) * grid_unit_size + yoffset, grid_unit_size, grid_unit_size)
				end
			end
    	end

    	-- Button Go to Evolution mode
    	love.graphics.setColor(background_color[1], background_color[2], background_color[3])
		love.graphics.draw(self.goButtonImage, goButtonX, goButtonY)
	end

	function instance:update()

		mouse_x, mouse_y = love.mouse.getPosition()

		lastFrameMouseClicked = mouseClicked
		mouseClicked = love.mouse.isDown("l")

		if mouseClicked and mouse_x > goButtonX and mouse_x <= goButtonX + goButtonWidth and mouse_y > goButtonY and mouse_y <= goButtonY + goButtonHeight and 
			not lastFrameMouseClicked then
			processGoButtonClicked(self.grid_state)
		end

		glitchUpdateTimer = glitchUpdateTimer + 1/60
	end

	return instance
end

return exports

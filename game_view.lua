-- imports
grid_state = require 'grid_state'
glitch_gen = require 'glitchGen'
directions = require 'directions'
glider = require 'glider'
watcher = require 'watcher'
player_state = require 'player_state'

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
lastGliderX = 0
lastGliderY = 0

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

function gliderClicked(grid_state)
	local gliderObject = nil
	if gliderPlaced then
		gliderObject = grid_state:get_object_at(lastGliderX, lastGliderY)
		gliderObject.direction = directions.rotate_clockwise(gliderObject.direction)
	end
end

function processGoButtonClicked(grid_state, player_state)

	grid_state:update_objects()

	player_state.numberOfRounds = player_state.numberOfRounds - 1

	gliderPlaced = false;
end

function exports(round_num)
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
	instance.grid_state:add_object(glider(5, 5, directions.UP))

	instance.player_state = player_state(round_num)

	for watcherI=1,10 do
		instance.grid_state:add_object(watcher(math.random(0,xcount), math.random(0,ycount), directions.DOWN))
	end

    instance.goButtonImage = love.graphics.newImage( "placeholders/goButton.png" )
    local goButtonX = (xcount - 2) * grid_unit_size + xoffset
    local goButtonY = (ycount + 1.4) * grid_unit_size
    local goButtonWidth = 64
    local goButtonHeight = 32

    instance.roundImage = love.graphics.newImage("placeholders/round.png")
    local roundX = (xcount-0.7) * grid_unit_size + xoffset
    local roundY = 0.4 * grid_unit_size
    local roundWidth = 24

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
			draw_line(grid_num, current_x, yoffset, current_x, yoffset + ycount * grid_unit_size)

			if mouse_x >= current_x and mouse_x < current_x + grid_unit_size then
				drawGliderX = grid_num
			end

			current_x = current_x + grid_unit_size
			grid_num = grid_num + 1
		end

		local current_y = yoffset
		grid_num = 0
		while grid_num <= ycount do
			draw_line(grid_num, xoffset, current_y, xoffset + xcount * grid_unit_size, current_y)

			if mouse_y >= current_y and mouse_y < current_y + grid_unit_size then
				drawGliderY = grid_num
			end
			
			current_y = current_y + grid_unit_size
			grid_num = grid_num + 1
		end

		if mouseClicked and drawGliderX >= 0 and drawGliderY >= 0 and drawGliderX < xcount and drawGliderY < ycount and 
			not self.grid_state:get_space_at(drawGliderX+1, drawGliderY+1) and self.grid_state:get_object_at(drawGliderX+1, drawGliderY+1) == nil then

			if gliderPlaced then
				self.grid_state:delete_object(self.grid_state:get_object_at(lastGliderX, lastGliderY))
			end
			lastGliderX = drawGliderX + 1
			lastGliderY = drawGliderY + 1
			self.grid_state:add_object(glider(lastGliderX, lastGliderY, directions.DOWN))
			gliderPlaced = true
		end

		if glitchUpdateTimer > 0.2 then
			glitchUpdate = true
			glitchUpdateTimer = glitchUpdateTimer - 0.2
		end
		for i,rect in ipairs(rectanglesToDraw) do
			glitch_gen.drawGlich(rect["x"], rect["y"], xcount, glitchUpdate)
    	end
		
		for x = 1, xcount, 1 do
			for y = 1, ycount, 1 do
				if self.grid_state:get_space_at(x, y) then
					glitch_gen.drawGlich( (x-1) * grid_unit_size + xoffset, (y-1) * grid_unit_size + yoffset, xcount, glitchUpdate)
				end
			end
    	end

		self.grid_state:draw_objects(xoffset, yoffset)

		glitchUpdate = false	

    	-- Button Go to Evolution mode
    	love.graphics.setColor(background_color[1], background_color[2], background_color[3])
		love.graphics.draw(self.goButtonImage, goButtonX, goButtonY)

		-- rounds
		for i = 1, self.player_state.numberOfRounds, 1 do
			love.graphics.draw(self.roundImage, roundX - (roundWidth+2)*(i-1),roundY)
		end
	end

	function instance:update()

		mouse_x, mouse_y = love.mouse.getPosition()

		lastFrameMouseClicked = mouseClicked
		mouseClicked = love.mouse.isDown("l")

		if mouseClicked and not lastFrameMouseClicked then

			if mouse_x > goButtonX and mouse_x <= goButtonX + goButtonWidth and mouse_y > goButtonY and mouse_y <= goButtonY + goButtonHeight then
				processGoButtonClicked(self.grid_state, self.player_state)
			else if gliderPlaced then
					local posX = (lastGliderX-1) * grid_unit_size + xoffset
					local posY = (lastGliderY-1) * grid_unit_size + yoffset
					if mouse_x > posX and mouse_x <= posX + grid_unit_size and mouse_y > posY and mouse_y <= posY + grid_unit_size then
						gliderClicked(self.grid_state)
					end
				end
			end
		end

		glitchUpdateTimer = glitchUpdateTimer + 1/60
	end

	return instance
end

return exports

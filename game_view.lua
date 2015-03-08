-- imports
grid_state = require 'grid_state'
glitch_gen = require 'glitchGen'
directions = require 'directions'
glider = require 'glider'
player_state = require 'player_state'
stack_trace = require 'stackTrace'
active_screen = require 'active_screen'
game_over_view = require 'game_over_view'
game_won = require 'game_won'
placeable_utils = require 'placeables'

grid_normal_color = {180, 230, 255}
grid_block_color = {100, 200, 250}
grid_line_width = 0.5
grid_unit_size = 32
grid_big_border = 5

-- mouse variables
mouse_x = 0;
mouse_y = 0;

-- glider variables
rectanglesToDraw = {}

evolution_phases = 5

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

function exports(level_description)
	local instance = {}

	instance.level_description = level_description

	local mouseClicked = false;
	local lastFrameMouseClicked = true;
	local block_size = grid_unit_size * grid_big_border

	local available_width = 1280 - 250
	local available_height = 720 - 20
	local xcount = level_description.grid_width
	local ycount = level_description.grid_height

	local xoffset = (available_width - (xcount * grid_unit_size)) / 2
	local yoffset = (available_height - (ycount * grid_unit_size)) / 2

	local gliderPlaced = false

	local pending_events = {}

	instance.grid_state = grid_state(xcount, ycount)
	instance.grid_state.mode = instance.grid_state.MODE_SIGNAL

	local function gliderClicked()
		lastGlider.direction = directions.rotate_clockwise(lastGlider.direction)
	end

	local function processGoButtonClicked(grid_state, player_state)
		if not player_state.won then
			player_state:endRound()

			gliderPlaced = false
			instance.grid_state.mode = instance.grid_state.MODE_EVOLUTION
			tick_time = 0
			evolution_phase = 1
		else
			if level_list.next_level(level_description) ~= nil then
				active_screen.set(game_view(level_list.next_level(level_description)))
			else
				active_screen.set(game_won())
			end
		end
	end

	local function hasWon(grid_state, player_state)
		local won = true

		for x = 1, xcount, 1 do
			for y = 1, ycount, 1 do
				if grid_state:get_object_at(x, y) ~= nil and grid_state:get_object_at(x, y).type == 'watcher' then
					won = false
				end
			end
    	end

    	player_state.won = won

    	return won
	end

	local function levelWon()
		instance.goButtonImage = love.graphics.newImage( "placeholders/next.png" )
	end

	instance.player_state = player_state(level_description.number_of_rounds)
	level_description.setup(instance.grid_state)

    instance.goButtonImage = love.graphics.newImage( "placeholders/goButton.png" )
    local goButtonX = love.window.getWidth()-225
    local goButtonY = love.window.getHeight()-yoffset-50
    local goButtonWidth = 150
    local goButtonHeight = 50

    local background = love.graphics.newImage('background/background_light.png')
    instance.roundImage = love.graphics.newImage("placeholders/round.png")
    local roundX = (xcount-0.7) * grid_unit_size + xoffset
    local roundWidth = 24

    local signalImage = love.graphics.newImage('header/signal.png')
    local processingImage = love.graphics.newImage('header/processing.png')

	function instance:draw()
		love.graphics.setColor(255,255,255)
		love.graphics.draw(background, 0, 0)

		if instance.grid_state.mode == instance.grid_state.MODE_SIGNAL then
			love.graphics.draw(signalImage, xoffset, yoffset - 50)
		else
			love.graphics.draw(processingImage, xoffset, yoffset - 50)
		end

		if self.grid_state.mode == self.grid_state.MODE_SIGNAL then
			love.graphics.setColor(240,240,240)
			love.graphics.rectangle("fill", xoffset,yoffset,grid_unit_size*xcount, grid_unit_size*ycount)

			--placeable stuff
			love.graphics.setColor(255,255,255)
			for place_index, place in pairs(self.grid_state.placeable) do
				love.graphics.rectangle("fill",xoffset+(place[1]-1)*grid_unit_size, yoffset+(place[2]-1)*grid_unit_size, grid_unit_size,grid_unit_size)
			end
		end

		-- Draw Grid
		local current_x = xoffset
		local grid_num = 0

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

		stack_trace.draw_stack(self.grid_state, love.window.getWidth()-250, 100,love.mouse.getX(),love.mouse.getY(),xoffset,yoffset,current_object)

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

		if self.grid_state.mode == instance.grid_state.MODE_SIGNAL then
	    	-- Button Go to Evolution mode
	    	love.graphics.setColor(255, 255, 255)
			love.graphics.draw(self.goButtonImage, goButtonX, goButtonY)
		end

		-- rounds
		for i = 1, self.player_state.numberOfRounds, 1 do
			love.graphics.draw(self.roundImage, roundX - (roundWidth+2)*(i-1), yoffset - 35)
		end
	end

	function instance:kill_dead_objects()
		local obj = self.grid_state.first_object
		while obj ~= nil do
			if obj.isDead then
				self.grid_state:delete_object(obj)
			end
			obj = obj.next
		end
	end

	function instance:update()
		mouse_x, mouse_y = love.mouse.getPosition()

		local wasClicked = mouseClicked
		mouseClicked = love.mouse.isDown("l")

		if self.grid_state.mode == instance.grid_state.MODE_SIGNAL then
		
			if mouseClicked then

				target_x = math.floor((mouse_x - xoffset) / grid_unit_size) + 1
				target_y = math.floor((mouse_y - yoffset) / grid_unit_size) + 1
				if self.grid_state:in_grid(target_x, target_y) and 
					not self.grid_state:get_space_at(target_x, target_y) and
					placeable_utils.contains(self.grid_state.placeable,target_x,target_y) then

					if gliderPlaced then
						if lastGlider.x == target_x and lastGlider.y == target_y and not lastFrameMouseClicked then
							print('rotate')
							gliderClicked()
						elseif self.grid_state:get_object_at(target_x, target_y) == nil then
							print('move')
							lastGlider.x = target_x
							lastGlider.y = target_y
						end
					elseif self.grid_state:get_object_at(target_x, target_y) == nil and not lastFrameMouseClicked then
						print('place')
						lastGlider = glider(target_x, target_y, directions.DOWN)
						self.grid_state:add_object(lastGlider)
						gliderPlaced = true
					end
				elseif mouse_x > goButtonX and mouse_x <= goButtonX + goButtonWidth and mouse_y > goButtonY and mouse_y <= goButtonY + goButtonHeight and not lastFrameMouseClicked then
					processGoButtonClicked(self.grid_state, self.player_state)
				end
			end
		else
			if #pending_events > 0 then
				if tick_time >= 8 then
					tick_time = 0

					local next_event = pending_events[1]

					table.remove(pending_events, 1)

					next_event()
					self:kill_dead_objects()
				else
					tick_time = tick_time + 1
				end
			elseif tick_time >= 3 then
				tick_time = 0
				if evolution_phase > evolution_phases then
					self.grid_state.mode = instance.grid_state.MODE_SIGNAL
					current_object = nil

					if hasWon(self.grid_state, self.player_state) then
						levelWon()
						return
					end

					if self.player_state.gameOver then
						active_screen.set(game_over_view(level_description))
						return
					end
				else
					if current_object == nil then
						current_object = self.grid_state.first_object
					end
					if current_object == nil then
						evolution_phase = evolution_phase + 1
					else
						current_object:update(self.grid_state, pending_events)
						--erase cycle
						self:kill_dead_objects()
						current_object = current_object.next
						if current_object == nil then
							evolution_phase = evolution_phase + 1
						end
					end
				end
			else
				tick_time = tick_time + 1
			end
		end

		lastFrameMouseClicked = mouseClicked

		glitchUpdateTimer = glitchUpdateTimer + 1/60
	end

	return instance
end

return exports

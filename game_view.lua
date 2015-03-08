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

	local pending_events = {}

	instance.grid_state = grid_state(xcount, ycount)
	instance.grid_state.mode = instance.grid_state.MODE_SIGNAL

	local function gliderClicked()
		lastGlider.direction = directions.rotate_clockwise(lastGlider.direction)
	end

	local function processGoButtonClicked(grid_state, player_state)
		if not player_state.won then
			if player_state.gameOver then
				active_screen.set(game_over_view(level_description))
			end

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

	local goButtonWidth = 150
    local goButtonHeight = 50

	instance.menuButtonImage = love.graphics.newImage("placeholders/menu.png")
    local menuButtonY = love.window.getHeight()-yoffset-50

    instance.retryButtonImage = love.graphics.newImage("placeholders/retry.png")
    local retryButtonY = menuButtonY - goButtonHeight - 20

    instance.goButtonImage = love.graphics.newImage( "placeholders/goButton.png" )
    local goButtonX = love.window.getWidth()-225
    local goButtonY = retryButtonY - goButtonHeight - 20

    local background = love.graphics.newImage('background/background_light.png')
    instance.roundImage = love.graphics.newImage("placeholders/round.png")
    local roundX = 1220
    local roundY = 75
    local roundWidth = 24

    local signalImage = love.graphics.newImage('header/signal.png')
    local processingImage = love.graphics.newImage('header/processing.png')
    local gameOverImage = love.graphics.newImage('header/game_over.png')

    local stopImage = love.graphics.newImage('game_speed/stop.png')
    local stopSelectedImage = love.graphics.newImage('game_speed/stop_selected.png')
    local playImage = love.graphics.newImage('game_speed/play.png')
    local playSelectedImage = love.graphics.newImage('game_speed/play_selected.png')
    local fastImage = love.graphics.newImage('game_speed/fast.png')
    local fastSelectedImage = love.graphics.newImage('game_speed/fast_selected.png')

    local NORMAL_SPEED = 1
    local FAST_SPEED = 4
    local game_speed = NORMAL_SPEED

    local speedButtonX = goButtonX
    local speedButtonY = goButtonY - 40

	function instance:draw()
		love.graphics.setColor(255,255,255)
		love.graphics.draw(background, 0, 0)

		if self.player_state.gameOver then
			love.graphics.draw(gameOverImage, 10, 10)
		elseif instance.grid_state.mode == instance.grid_state.MODE_SIGNAL then
			love.graphics.draw(signalImage, 10, 10)
		else
			love.graphics.draw(processingImage, 10, 10)
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

		self.grid_state:draw_tiles(xoffset, yoffset)

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

		-- Button Go to Evolution mode
		love.graphics.setColor(255, 255, 255)
		if not self.player_state.gameOver then
			if self.grid_state.mode == instance.grid_state.MODE_SIGNAL then
				love.graphics.draw(self.goButtonImage, goButtonX, goButtonY)
			end


			love.graphics.draw(game_speed == 0 and stopSelectedImage or stopImage, speedButtonX, speedButtonY)
			love.graphics.draw(game_speed == NORMAL_SPEED and playSelectedImage or playImage, speedButtonX + 40, speedButtonY)
			love.graphics.draw(game_speed == FAST_SPEED and fastSelectedImage or fastImage, speedButtonX + 80, speedButtonY)
		end
		love.graphics.draw(self.retryButtonImage, goButtonX, retryButtonY)
		love.graphics.draw(self.menuButtonImage, goButtonX, menuButtonY)

		-- rounds
		for i = 1, self.player_state.numberOfGliders, 1 do
			love.graphics.draw(self.roundImage, roundX - (roundWidth+2)*(i-1), roundY)
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

		if mouseClicked and not lastFrameMouseClicked then
			if mouse_x >= speedButtonX - 4 and mouse_y >= speedButtonY and mouse_y < speedButtonY + 32 then
				if mouse_x <= speedButtonX + 36 then
					game_speed = 0
				elseif mouse_x <= speedButtonX + 76 then
					game_speed = NORMAL_SPEED
				else
					game_speed = FAST_SPEED
				end
			end
		end

		if self.grid_state.mode == instance.grid_state.MODE_SIGNAL then
		
			target_x = math.floor((mouse_x - xoffset) / grid_unit_size) + 1
			target_y = math.floor((mouse_y - yoffset) / grid_unit_size) + 1

			if love.mouse.isDown("r") then
				if placeable_utils.contains(self.grid_state.placeable,target_x,target_y) and self.grid_state:get_object_at(target_x, target_y) ~= nil then
					self.grid_state:delete_object(self.grid_state:get_object_at(target_x, target_y))
					lastGlider = nil
					self.player_state.removeGlider()
				end
			end
			if mouseClicked then
				if  not self.player_state.gameOver and self.grid_state:in_grid(target_x, target_y) and
					not self.grid_state:get_space_at(target_x, target_y) and
					placeable_utils.contains(self.grid_state.placeable,target_x,target_y) then

					if self.player_state.noMoreGliders then
						if lastGlider.x == target_x and lastGlider.y == target_y and not lastFrameMouseClicked then
							gliderClicked()
						elseif self.grid_state:get_object_at(target_x, target_y) == nil then
							lastGlider.x = target_x
							lastGlider.y = target_y
						end
					elseif self.grid_state:get_object_at(target_x, target_y) == nil and not lastFrameMouseClicked then
						lastGlider = glider(target_x, target_y, directions.DOWN)
						self.grid_state:add_object(lastGlider)
						self.player_state.placeGlider()
					end
				elseif mouse_x > goButtonX and mouse_x <= goButtonX + goButtonWidth and mouse_y > goButtonY and mouse_y <= goButtonY + goButtonHeight and not lastFrameMouseClicked and not self.player_state.gameOver then
					processGoButtonClicked(self.grid_state, self.player_state)
				elseif mouse_x > goButtonX and mouse_x <= goButtonX + goButtonWidth and mouse_y > retryButtonY and mouse_y <= retryButtonY + goButtonHeight and not lastFrameMouseClicked then
					active_screen.set(game_view(level_description))
					return
				elseif mouse_x > goButtonX and mouse_x <= goButtonX + goButtonWidth and mouse_y > menuButtonY and mouse_y <= menuButtonY + goButtonHeight and not lastFrameMouseClicked then
					initial_menu_view = require 'initial_menu_view'
					active_screen.set(initial_menu_view())
					return
				end
			end
		else
			if #pending_events > 0 then
				if tick_time >= 10 then
					tick_time = 0

					local next_event = pending_events[1]

					table.remove(pending_events, 1)

					next_event()
					self:kill_dead_objects()
				else
					tick_time = tick_time + game_speed
				end
			elseif tick_time >= 4 then
				tick_time = 0

				if hasWon(self.grid_state, self.player_state) then
					levelWon()
					return
				end

				if self.player_state.gameOver then
					return
				end
				
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

						if self.player_state.noMoreGliders then 

							self.player_state.gameOver = true

							for x = 1, xcount, 1 do
								for y = 1, ycount, 1 do
									if self.grid_state:get_object_at(x, y) ~= nil and self.grid_state:get_object_at(x, y).type == 'glider' then
										self.player_state.gameOver = false
									end
								end
				    		end
						end
					end
				end
			
			else
				tick_time = tick_time + game_speed
			end
		end

		lastFrameMouseClicked = mouseClicked

		glitchUpdateTimer = glitchUpdateTimer + 1/60
	end

	return instance
end

return exports

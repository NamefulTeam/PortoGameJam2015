-- imports
active_screen = require 'active_screen'
initial_menu_view = require 'initial_menu_view'

width = 1280
height = 720
numberOfRounds = 5

function love.load()
	love.window.setMode(width, height, { fullscreen = true })

	music = love.audio.newSource('techy.ogg')
	music:setLooping(true)
	love.audio.play(music)

	active_screen.set(initial_menu_view())
end

function love.draw()
	active_screen.get():draw()
end

update_time = 1.0/60
cumulative_time = 0
function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	cumulative_time = cumulative_time + dt
	while cumulative_time >= update_time do
		cumulative_time = cumulative_time - update_time
		active_screen.get():update()
	end
end

exports = {}
function exports.draw_stack(grid, x, y, mouse_x, mouse_y, offset_x, offset_y, current)
	love.graphics.setColor(255,0,0)
	--love.graphics.rectangle("fill",x,y, 250,20)
	--love.graphics.setColor(0,0,0)
	love.graphics.print('Unhandled InternalErrorException:', x+5, y+5)
	local index = 1
	local current_object = grid.first_object
	local radius = 32
	while current_object ~= nil do
		if mouse_y > y+index*25 and mouse_y < y+index*25 + 20
			and mouse_x > x and mouse_x < x + 235 then
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("line",x,y+index*25, 235,20)
			
		if current_object.type == 'glider' then
			love.graphics.setColor(64,128,64)
		else
			love.graphics.setColor(128,128,255)
		end

			love.graphics.rectangle("fill", current_object.x*32+offset_x-radius, current_object.y*32+offset_y-radius, radius, radius);
		end

		if current_object.type == 'glider' then
			love.graphics.setColor(0,128,0)
		else
			love.graphics.setColor(64,64,255)
		end

		local atText
		if current == nil and current_object == grid.last_object  and grid.mode == grid.MODE_EVOLUTION then
			atText = '> at '
		elseif current ~= nil and current == current_object then
			atText = '> at '
		else
			atText = '  at '
		end

		love.graphics.print(atText..current_object.type..".lua: line "..current_object.x.." column "..current_object.y, x+5, y+index*25+5)
		
		current_object = current_object.next
		index = index + 1
	end
end

return exports
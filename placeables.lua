exports = {}

function exports.add_placeableblock(list,x,y,w,h)
	table.insert(list, {x,y,w,h})
end

function exports.get_single_cell_list(list)
	local retlist = {}
	for i, v in pairs(list) do
		for w=0,v[3]-1 do
			for h=0,v[4]-1 do
				table.insert(retlist, {v[1]+w,v[2]+h})
			end
		end
	end
	return retlist
end

function exports.contains(list,x,y)
	for i, v in pairs(list) do
		if v[1] == x and v[2] == y then
			return true
		end
	end
	return false
end

return exports

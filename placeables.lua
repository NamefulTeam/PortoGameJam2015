exports = {}

function exports.add_placeableblock(list,x,y,w,h)
	table.insert(list, {x,y,w,h})
end

function exports.get_single_cell_list(list)
	local retlist = {}
	for i, v = pairs(list) do
		for w=1,v[3]
			for h=1,v[4]
				table.insert(list, {v[1],v[2]})
			end
		end
	end
	return retlist
end

return exports

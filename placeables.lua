exports = {}

function exports.add_placeableblock(list,x,y,w,h)
	table.insert(list, {x,y,w,h})
end

function exports.get_single_cell_list(list)
	local retlist = {}
	for i, v in pairs(list) do
		for w=1,v[3] do
			for h=1,v[4] do
				table.insert(retlist, {v[1]+w,v[2]+h})
			end
		end
	end
	return retlist
end

return exports

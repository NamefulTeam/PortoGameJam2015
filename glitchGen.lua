exports = {}

canvasCache={}

function exports.drawGlich(x,y, width, update)

	if  canvasCache[x+y*width] == nil then
		canvasCache[x+y*width] = love.graphics.newCanvas(32,32)
		love.graphics.setCanvas(canvasCache[x+y*width])
		love.graphics.setBackgroundColor(255,255,255,0)
		glitch(0,0)
		love.graphics.setCanvas()
	elseif update then
		love.graphics.setCanvas(canvasCache[x+y*width])
		love.graphics.clear(canvasCache[x+y*width])
		glitch(0,0)
		love.graphics.setCanvas()
	end

	love.graphics.setColor(255,255,255)
	love.graphics.draw(canvasCache[x+y*width],x,y)
end

function glitch(x,y)
	if(math.random(0,10)>=1) then
		for xi=0,7 do
			for yi=0,7 do
				glitchSquare(xi*4+x,yi*4+y,4,4)
			end
		end
	else
		for xi=0,15 do
			for yi=0,15 do
				glitchSquare(xi*2+x,yi*2+y,2,2)
			end
		end
	end
end

noiseFileIndex = 2000
contents, size = love.filesystem.read( "glitchbase.ogg", 10000)
function glitchSquare(x,y,width,height)
	if(noiseFileIndex + 2 > size)then
		noiseFileIndex = 2000
	end
	r = string.byte(contents, noiseFileIndex)
	g = string.byte(contents, noiseFileIndex+1)
	b = string.byte(contents, noiseFileIndex+2)
	noiseFileIndex = noiseFileIndex + 3
	love.graphics.setColor(r,g,b)
	love.graphics.rectangle("fill", x,y,width,height)
end

return exports
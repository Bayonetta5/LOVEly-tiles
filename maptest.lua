local gr= love.graphics
local s = {name = 'map loading/editing'}

function s:load()
	atlas   = require 'lib.atlas'
	map     = require 'lib.map'
	md      = require 'lib.mapdata'

	sheet = gr.newImage('tile.png')
	sheet:setFilter('linear','nearest')
	
	sheetatlas = atlas.new(32,32,16,16)
		
	local mapsource =[[
@@@@@  ----   qqqq   xxxxx
  @    -      q        x
  @    ----   qqqq     x
  @    -         q     x
  @    ----   qqqq     x
]]
	
	map = map.new(sheet,sheetatlas)
	
	for x,y,v in md.string(mapsource) do
		local index
		if v == '-' then index = 1
		elseif v == '@' then index = 2
		elseif v == 'q' then index = 3
		elseif v == 'x' then index = 4 end
		map:setAtlasIndex(x,y,index)
	end
	
	map:setFlip(1,1,true,false)
	map:setAngle(2,1,3.14/2)
	map:setAtlasIndex(3,1)
	
	x,y     = 0,0
	vx,vy   = 0,0
	velocity= 400
end

function s:keypressed(k)
	if k == ' ' then state = require 'isometric' state:load() end
	if type(tonumber(k)) == 'number' then
		if tonumber(k) <= 4 then
			map:setAtlasIndex(1,1,tonumber(k))
		end
	end
	if k == 'd' then
		vx = velocity
	end
	if k == 'a' then
		vx = -velocity
	end
	if k == 'w' then
		vy = -velocity
	end
	if k == 's' then
		vy = velocity
	end
end

function s:keyreleased(k)
	if k == 'd' or k == 'a' then
		vx = 0
	end
	if k == 'w' or k == 's' then
		vy = 0
	end
end

function s:mousepressed(mx,my,b)
	local x,y = mx+x,my+y
	if b == 'l' then
		index = map:getAtlasIndex(math.ceil(x/16),math.ceil(y/16))
		local nexti = index and index+1 <= 4 and index+1 or 1
		map:setAtlasIndex(math.ceil(x/16),math.ceil(y/16),nexti)
	end
	if b == 'r' then map:setAtlasIndex(math.ceil(x/16),math.ceil(y/16)) end
end

function s:update(dt)
	dx,dy= vx*dt,vy*dt
	x    =x+dx y=y+dy
end

function s:draw()
	gr.push()
		gr.translate(-math.floor(x),-math.floor(y))
		gr.rectangle('line',0,0,800,600)
		map:setViewRange(1,1,100,100)		
		map:draw()	
	gr.pop()
	
	gr.print('Right mouse click to erase a tile',0,576)
	gr.print('Left mouse click to add/change a tile',0,588)
end

return s
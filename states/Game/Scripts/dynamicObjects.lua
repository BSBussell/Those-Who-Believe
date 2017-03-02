anim8 = require "states/Game/Scripts/anim8"

objects = {}

function loadSpriteSheets()
	tileMap = love.graphics.newImage('states/Game/Maps/SpriteSheet(WIP) .png')
	local gt = anim8.newGrid(18,18,tileMap:getWidth(),tileMap:getHeight())
	Rock = anim8.newAnimation(gt(3,7), 1)
end

function addObject(type,x,y)
	newObject = {}
	newObject["name"] = type.." "..#objects
	newObject["type"] = type
	newObject["x"] = x
	newObject["y"] = y
	newObject["id"] = type.." "..#objects+1
	world:add(type.." "..#objects+1,x,y,16,16)

	--print("X: "..x)
	--print("Y: "..y)
	table.insert(objects,newObject)
end

function updateObject()



	for k,v in ipairs(objects) do
		--if objects[]
		if string.find(objects[k].type,"heart") then
			--print(objects[k].type)
			local objectFilter = function(item,other)
	          	return "cross"
	  	end
		  local actualX, actualY, cols, len = world:check(objects[k].id,objects[k].x,objects[k].y,objectFilter)
		  for i = 1,len do
			  if cols[i].other == "player" then
				  world:remove(objects[k].id)


				  if objects[k].type == "heart" then
					  local fooh = 0
					  while player.hp<player.maxHp and fooh <=20 do
						  player.hp = math.floor(player.hp + 1)
						  fooh = fooh+1
					  end
				  end
				  if objects[k].type == "heartCon" then
					  local fooh = 0
					  while player.hp<player.maxHp and fooh <=20 do
						  player.maxHp = player.maxHp + 1
						  player.hp = player.hp + 1
						  fooh = fooh+1
					  end
				  end
				  table.remove(objects,k)
			  end
		  end

		elseif objects[k].type == "Rock" then
			local objectFilter = function(item,other)
	          	return "slide"
	  	end
		  local actualX, actualY, cols, len = world:check(objects[k].id,objects[k].x,objects[k].y,objectFilter)
			for i = 1,len do
				if cols[i].other == "player" then
					local actualX, actualY, cols, len = world:move(objects[k].id,objects[k].x,objects[k].y,objectFilter)
					objects[k].x = actualX
					objects[k].y = actualY
					player.friction = 47


				--else player.friction = 3.9
			end
				print(player.friction)
			end
		end
	end
end

function drawObject()
	for k,v in ipairs(objects) do

    if objects[k].type == "heart" then
			love.graphics.setColor(255, 0, 0, 255)
			fullHeart:draw(heartSheet, objects[k].x+4, objects[k].y+4, 0,.5,.5)
		elseif objects[k].type == "heartCon" then
			love.graphics.setColor(255, 255, 255, 255)
			heartCon:draw(heartSheet, objects[k].x+4, objects[k].y+4, 0,1,1)
		elseif objects[k].type == "Rock" then
			love.graphics.setColor(255, 255, 255, 255)
			--print(objects[k].id)
			--love.graphics.rectangle('line', objects[k].x, objects[k].y, 16, 16)
			Rock:draw(tileMap,objects[k].x,objects[k].y,0,1,1)
		end


		love.graphics.setColor(255, 255, 255, 255)
		--love.graphics.rectangle("line",objects[k].x,objects[k].y,16,16)
	end
end

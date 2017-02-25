
objects = {}

function addObject(type,x,y)
	newObject = {}
	newObject["name"] = type.." "..#objects
	newObject["type"] = type
	newObject["x"] = x
	newObject["y"] = y
	newObject["id"] = type.." "..#objects+1
	world:add(type.." "..#objects+1,x,y,16,16)
	table.insert(objects,newObject)
end

function updateObject()
	local objectFilter = function(item,other)
          return "cross"
    end

	for k,v in ipairs(objects) do
		local actualX, actualY, cols, len = world:check(objects[k].id,objects[k].x,objects[k].y,objectFilter)
		for i = 1,len do
			if cols[i].other == "player" then
				world:remove(objects[k].id)
	      --world:add(objects[k].id,-200,-200,8,8)
				--objects[k].x = -200
				--objects[k].y = -200

				if objects[k].type == "heart" then
					local fooh = 0
					while player.hp<player.maxHp and fooh <=20 do
						player.hp = math.floor(player.hp + 1)
						fooh = fooh+1
					end
				end
				table.remove(objects,k)
			end
		end
	end
end

function drawObject()
	for k,v in ipairs(objects) do
		love.graphics.setColor(255, 0, 0, 255)
		fullHeart:draw(heartSheet, objects[k].x+4, objects[k].y+4, 0,.5,.5)

		love.graphics.setColor(255, 255, 255, 255)
		--love.graphics.rectangle("line",objects[k].x,objects[k].y,16,16)
	end
end

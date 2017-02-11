local bump = require 'Scripts/bump'
local sti  = require 'sti'
world = require "Maps/maphandler"
require "Scripts/inventory"


function swingSword()
    multiplier = 1
    timer = 8
		--swordActive = true
		
		if player.xvel == 0 and player.yvel == 0 then
            SwordCord = {player.x+(player.width*.25),player.y-player.height,6,16}  
            sword = Sword_Up
        end
    if swordActive ~= true then
        world:add("Sword",SwordCord[1], SwordCord[2], SwordCord[3], SwordCord[4])
        swordActive = true
    end
    fr = false
end

function throwBoomerang()
    if boomerangActive == false then
        boomerangX = player.x+player.xvel
        boomerangY = player.y+player.yvel
        
        startX = boomerangX
        startY = boomerangY
        baseX = startX
        baseY = startY
        --if player.xvel>player.yvel then
        --if player.xvel>player.yvel
        if player.xvel<2 and player.xvel>-2 then
            endX = boomerangX 
        else
            endX = boomerangX +(inventory.Boomerang.speed*(math.abs(player.xvel)/player.xvel))
        end
        
        if player.yvel<2 and player.yvel>-2 then
            endY = boomerangY 
        else
            endY = boomerangY +(inventory.Boomerang.speed*(math.abs(player.yvel)/(player.yvel)))
        end
        --increase = slopeOf(startX,startY,endX,endY)
        increaseX = endX-startX
        increaseY = endY-startY
        boomerangvelX = player.xvel
        boomerangvelY = player.yvel
        world:add("Boomerang",boomerangX,boomerangY,16,16)
        distance = inventory.Boomerang.range
        boomerangActive = true
        rotation = 0
        boomerangReturn = false
    end
end

function boomerangUpdate(dt)
    local boomerangFilter = function(item,other)
        --for i,v in ipairs(enemy) do
        --        if other == "Enemy 0 "..i then return ""  end
        --end
        if other == "player" then return "slide" end
        return "bounce"
    end
    rotation = rotation +.2
    --baseX = baseX+increase
    --baseY = baseY+increase
    boomerangGoalX = boomerangX+(increaseX/6)
    boomerangGoalY = boomerangY+(increaseY/6)
    if distanceFrom(player.x,player.y,boomerangX,boomerangY) >= inventory.Boomerang.range or boomerangReturn == true then
        if player.x < boomerangX then
            boomerangGoalX = boomerangX-2.5
        else
            boomerangGoalX = boomerangX+2.5
        end
        if player.y < boomerangGoalY then
            boomerangGoalY = boomerangY-2.5
        else
            boomerangGoalY = boomerangY+2.5
        end
        boomerangReturn = true
    end
    local actualX, actualY, col, len = world:move("Boomerang",boomerangGoalX,boomerangGoalY,boomerangFilter)
    boomerangX = actualX
    boomerangY = actualY
    for i = 1, len do 
        local obj = col[i].other
        if obj == "player" then
            boomerangActive = false
            world:remove("Boomerang")
        else boomerangReturn = true end
        
    end
end

function boomerangDraw()
    
end


function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end
function slopeOf(x1,y1,x2,y2) return (y2-y1)/(x2-x1) end
local bump = require 'states/Game/Scripts/bump'
local sti = require 'states/Game/sti'
world = require "states/Game/Maps/maphandler"
require "states/Game/Scripts/inventory"

function swingSword()
  multiplier = 1
  timer = 20
  --swordActive = true

  if player.xvel == 0 and player.yvel == 0 then
    SwordCord = {player.x+(player.width*.25),player.y-player.height,6,16}
    sword = Sword_Up
  end
  if swordActive ~= true then
    world:add("Sword",SwordCord[1], SwordCord[2], SwordCord[3], SwordCord[4])
    swordActive = true
    player.xvel,player.yvel = player.xvel*-.05,player.yvel*.05
  end

  sword:resume()
  fr = false
end

function throwBoomerang(btn)
  if boomerangActive == false then
    boomerangX = player.x+(player.xvel*.75)
    boomerangY = player.y+(player.yvel*.75)

    startX = boomerangX
    startY = boomerangY
    baseX = startX
    baseY = startY
    local stuff = btn.."Item"
    boomerangType = inventory.Hotbar[stuff]
    --if player.xvel>player.yvel then
    --if player.xvel>player.yvel
    if player.xvel<2 and player.xvel>-2 then
      endX = boomerangX
    else
      endX = boomerangX +(inventory[boomerangType].speed*(math.abs(player.xvel)/player.xvel))
    end

    if player.yvel<2 and player.yvel>-2 then
      endY = boomerangY
    else
      endY = boomerangY +(inventory[boomerangType].speed*(math.abs(player.yvel)/(player.yvel)))
    end
    --if endX == boomerangX and endY == boomerangY then
    if player.animation == charani.charRight or player.animation == charani.NulRight then
      endX = boomerangX +(inventory[boomerangType].speed*(math.abs(player.xvel)/player.xvel))
    elseif player.animation == charani.charLeft or player.animation == charani.NulLeft then
      endX = boomerangX +(inventory[boomerangType].speed*(math.abs(player.xvel)/player.xvel))
    end
    if player.animation == charani.charForeward or player.animation == charani.NulUp then
      endY = boomerangY +(inventory[boomerangType].speed*(math.abs(player.yvel)/(player.yvel)))
    elseif player.animation == charani.charBackward or player.animation == charani.NulDown then
      endY = boomerangY +(inventory[boomerangType].speed*(math.abs(player.yvel)/(player.yvel)))
    end
    --print("Running")
    --end

    --increase = slopeOf(startX,startY,endX,endY)
    increaseX = endX-startX
    increaseY = endY-startY
    boomerangvelX = player.xvel
    boomerangvelY = player.yvel
    world:add("Boomerang",boomerangX,boomerangY,16,16)
    distance = inventory[boomerangType].range
    boomerangActive = true
    rotation = 0
    boomerangReturn = false
    boomerangTimer = 130
  end
end

function boomerangUpdate(dt)
  if boomerangActive == true then
    local boomerangFilter = function(item,other)
      for i,v in ipairs(enemy) do
        if other == "Enemy 0 "..i then return "cross" end
      end
      if other == "player" then return "slide" end
      return "slide"
    end
    rotation = rotation +.1
    --baseX = baseX+increase
    --baseY = baseY+increase
    boomerangGoalX = boomerangX+(increaseX/6)
    boomerangGoalY = boomerangY+(increaseY/6)
    if distanceFrom(startX,startY,boomerangX,boomerangY) >= inventory[boomerangType].range or boomerangReturn == true then
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
    --boomerangTimer = boomerangTimer - 1
    --if boomerangTimer <= 0 then
    --bomerangActive = false
    --world:remove("Boomerang")
    --end
  end
end

function dashBoots()

end

function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end
function slopeOf(x1,y1,x2,y2) return (y2-y1)/(x2-x1) end

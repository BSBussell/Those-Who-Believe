local anim8 = require 'states/Game/Scripts/anim8'
NPC = {}

function addNPC(name,id,x,y,image,textSRC)
  local newNpc = {}
  newNpc.id = id
  newNpc.tileId = name
  newNpc.colId = "NPC "..name.." "..id
  newNpc.x = x
  newNpc.y = y
  newNpc.image = love.graphics.newImage(image)
  newNpc.dialogueSRC = textSRC
  newNpc.crntTxt = 1

  local g1 = anim8.newGrid(64,64,newNpc.image:getWidth(),newNpc.image:getHeight())
  newNpc.UpAnimation = anim8.newAnimation(g1(1,11), 12)
  newNpc.DownAnimation = anim8.newAnimation(g1(1,9), 12)
  newNpc.LeftAnimation = anim8.newAnimation(g1(1,10), 12)
  newNpc.RightAnimation = anim8.newAnimation(g1(1,12), 16)

  newNpc.crntAnimation = newNpc.UpAnimation

  world:add(newNpc.colId,x+1,y-3,8,22)

  table.insert(NPC,newNpc)
end

function drawNPC()
  for k,v in ipairs(NPC) do

    local ldAni = NPC[k].crntAnimation
    local srcImg = NPC[k].image
    local x = NPC[k].x
    local y = NPC[k].y

    ldAni:draw(srcImg,x-15,y-15,0,.45)
    --love.graphics.rectangle("line", x+1, y-3, 8, 22)
  end
end

function updateNpc()
  for k,v in ipairs(NPC) do
    local rng = math.random(1,8)
    --print(rng)
    if rng <= 2 then
      NPC[k].crntAnimation = NPC[k].UpAnimation
    elseif rng <= 4 then
      NPC[k].crntAnimation = NPC[k].DownAnimation
    elseif rng <= 6 then
      NPC[k].crntAnimation = NPC[k].LeftAnimation
    else
      NPC[k].crntAnimation = NPC[k].RightAnimation
    end
  end
end

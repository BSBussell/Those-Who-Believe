local anim8 = require 'states/Game/Scripts/anim8'
NPC = {}

function addNPC(name,id,x,y,image,textSRC)
  local newNpc = {}
  newNpc.id = id
  newNpc.tileId = name
  newNpc.colId = "NPC "..name.." "..id
  newNpc.x = x
  newNpc.y = y
  newNpc.dir = 1
  newNpc.image = love.graphics.newImage(image)
  newNpc.dialogueSRC = textSRC
  newNpc.crntTxt = 1

  local g1 = anim8.newGrid(64,64,newNpc.image:getWidth(),newNpc.image:getHeight())
  newNpc.UpAnimation = anim8.newAnimation(g1(1,9), 12)
  newNpc.DownAnimation = anim8.newAnimation(g1(1,11), 12)
  newNpc.LeftAnimation = anim8.newAnimation(g1(1,10), 12)
  newNpc.RightAnimation = anim8.newAnimation(g1(1,12), 12)

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
    math.randomseed(love.timer.getTime())
    if math.random(1,6) == 1 then
      add = math.random(-1,1)
    else
      add = 0
    end

    if NPC[k].dir+add <= 0 then
      NPC[k].dir = 4
    elseif NPC[k].dir+add >=5 then
      NPC[k].dir = 1
    else  NPC[k].dir = NPC[k].dir + add end
    --print("RNG: "..add)
    --print(NPC[k].dir)
    if NPC[k].dir == 1 then
      NPC[k].crntAnimation = NPC[k].UpAnimation
    elseif NPC[k].dir == 3 then
      NPC[k].crntAnimation = NPC[k].DownAnimation
    elseif NPC[k].dir == 2 then
      NPC[k].crntAnimation = NPC[k].LeftAnimation
    elseif NPC[k].dir == 4 then
      NPC[k].crntAnimation = NPC[k].RightAnimation
    end
  end
end

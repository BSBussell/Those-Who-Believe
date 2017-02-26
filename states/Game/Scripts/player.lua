local bump = require 'states/Game/Scripts/bump'
local sti = require 'states/Game/sti'
player = {}
--world = require "Maps/maphandler"
require "states/Game/Scripts/Ui"
require "states/Game/Scripts/inventory"
require "states/Game/Scripts/itemHandler"

require "states/Game/Maps/Protyping"

local anim8 = require 'states/Game/Scripts/anim8'

--this is where we set atributes of the player
function player.load(X, Y)

  char = love.graphics.newImage("states/Game/Images/CharDemo.png")
  local g = anim8.newGrid(64,64,char:getWidth(),char:getHeight())
  local charBackward = g('2-9',1)
  local charLeft = g('2-9',2)
  local charForeward = g('2-9',3)
  local charRight = g('2-9',4)
  local charNillUp = g(1,1)
  local charNillLeft = g(1,2)
  local charNillDown = g(1,3)
  local charNillRight = g(1,4)
  charani = {
    NulUp = anim8.newAnimation(charNillUp, .12),
    NulRight = anim8.newAnimation(charNillRight, .09),
    NulDown = anim8.newAnimation(charNillDown, .09),
    NulLeft = anim8.newAnimation(charNillLeft, .09),
    Right = anim8.newAnimation(charRight, .09),
    Up = anim8.newAnimation(charForeward, .09),
    Down = anim8.newAnimation(charBackward, .09),
    Left = anim8.newAnimation(charLeft, .09),
  }

  player.animation = charani.NulUp

  swd = love.graphics.newImage("states/Game/Images/Sword(slash).png")
  local ge = anim8.newGrid(16,16,swd:getWidth(),swd:getHeight())
  Sword_Right = anim8.newAnimation(ge('1-5',1), .09)
  Sword_Left = anim8.newAnimation(ge('1-5',2), .09)
  Sword_Down = anim8.newAnimation(ge('1-5',3), .09)
  Sword_Up = anim8.newAnimation(ge('1-5',4), .09)

  local sword = Sword_Down
  timer = 0
  SwordCord = {420,420,2,2}
  local multiplier = 0
  local still = 0
  swordActive = false
  world:add("Sword",SwordCord[1],SwordCord[2],SwordCord[3],SwordCord[4])
  fr = true

  player.hp = 60
  player.maxHp = 60
  --local x,y = map:convertTileToPixel(tileX,tileY)
  world:add("player",X,Y,30,22)
  player.x = X
  player.y = Y
  cam:setPosition(X,Y)
  player.width = 14
  player.height = 14
  player.xvel = 0
  player.yvel = 0
  player.friction = 3.9
  player.speed = 390

  boomerangActive = false

end

--this is player is drawn from
function player.draw()
  drawx = player.x
  drawy = player.y
  if timer > 0 and sword == Sword_Up then
    sword:draw(swd, SwordCord[1], SwordCord[2],0,1.15)
    love.graphics.rectangle("line", SwordCord[1], SwordCord[2], SwordCord[3], SwordCord[4])
  end
  player.animation:draw(char,drawx,drawy-12,0,.45)
  if timer > 0 and sword ~= Sword_Up then
    sword:draw(swd, SwordCord[1], SwordCord[2],0,1.15)
    love.graphics.rectangle("line", SwordCord[1], SwordCord[2], SwordCord[3], SwordCord[4])
  end
  if timer > 0 then
    world:remove("Sword")
    world:add("Sword",SwordCord[1], SwordCord[2], SwordCord[3], SwordCord[4])
  end

  if boomerangActive == true then
    if inventory.Hotbar.kItem ~= "EnchantedBoomerang" then
      love.graphics.draw(inventory.Boomerang.image,boomerangX,boomerangY,rotation,.65,.65)
    else
      love.graphics.draw(inventory.EnchantedBoomerang.image,boomerangX,boomerangY,rotation,.65,.65)
    end
    love.graphics.rectangle("line", boomerangX, boomerangY, 10.4, 10.4)
  end
  if timer == 0 then
    multiplier = 0
    still = 0
    swordActive = false
    world:remove("Sword")

  end
  timer = timer-1

end

--this is physics start
function player.physics(dt)
  --if swordActive ~= true then

  local playerFilter = function(item,other)
    for i,v in ipairs(objects) do
      if other == objects[i].id then return "cross" end
    end
    for i,v in ipairs(enemy) do
      if other == enemy[i].colId then return "slide" end
    end
    if other == "Sword" then
      return nil
    elseif other == "heart 0" then
      return "cross"
    else return "slide" end

  end
  local goalX = player.x + player.xvel*dt
  local goalY = player.y + player.yvel*dt

  player.xvel = player.xvel * (1 - math.min(dt*player.friction, 1))
  player.yvel = player.yvel * (1 - math.min(dt*player.friction, 1))

  local actualX, actualY, cols,len = world:check("player",goalX, goalY, playerFilter)

  thX = actualX
  thY = actualY


  local actualX, actualY, cols,len = world:move("player",goalX, goalY, playerFilter)
  player.x, player.y = actualX, actualY
--else
  if sword == Sword_Right then
    SwordCord = {player.x+16,player.y+2,20,8}

  elseif sword == Sword_Left then
    SwordCord = {player.x-4,player.y-4,14,20}
  elseif sword == Sword_Up then
    SwordCord = {player.x+(player.width*.25),player.y-player.height,6,20}
  elseif sword == Sword_Down then
    SwordCord = {player.x+(player.width*.25),player.y+8,6,20}
  end

end
--end

--end

--this is where the movement is handled
function player.move(dt)
if boomerangActive == true then boomerangUpdate(dt) end
if ((love.keyboard.isDown("d","right")) and
  player.xvel < player.speed) and swordActive == false then
  player.xvel = player.xvel + player.speed * dt
  SwordCord = {player.x+16,player.y+5,20,6}
  sword = Sword_Right
  player.animation = charani.Right
end

if ((love.keyboard.isDown("a","left")) and
  player.xvel > -player.speed) and swordActive == false then
  player.xvel = player.xvel - player.speed * dt
  SwordCord = {player.x-4,player.y+4,20,6}
  sword = Sword_Left
  player.animation = charani.Left
end

if ((love.keyboard.isDown("s","down")) and
  player.yvel < player.speed) and swordActive == false then
  SwordCord = {player.x+(player.width*.25),player.y+8,6,20}
  sword = Sword_Down
  player.yvel = player.yvel + player.speed * dt

  player.animation = charani.Up
end
if ((love.keyboard.isDown("w","up")) and
  player.yvel > -player.speed) and swordActive == false then
  SwordCord = {player.x+(player.width*.25),player.y-player.height,6,20}
  sword = Sword_Up
  player.yvel = player.yvel - player.speed * dt
  player.animation = charani.Down
end
player.friction = 3.9
player.speed = 390
if love.keyboard.isDown("i") then
  if inventory.Hotbar.kItem ~= "dashBoots" then
    player.speed = 960
    player.friction = 0
  end
end

player.animation:update(dt)
if swordActive == true then
  sword:update(dt)
end

for k, object in pairs(map.objects) do
  if object.name == "ChestSpace" then
    if player.x >= object.x-10 and player.x <= object.x+object.width-10 and player.y >=object.y and player.y<=object.y+object.height and love.keyboard.isDown("space") and object.properties.opened ==false then
      loadstring(object.properties.item)()
      inventory[item.name] = item
      table.insert(inventory.Space,item.name)
      object.properties.opened = true
      alert("You Found a "..item.name.."!!\nOpen up your inventory with E to equip it")
    end
  elseif object.properties.LoadZones == true and object.name == string.upper(object.name) then
    if player.x >= object.x-10 and player.x <= object.x+object.width and player.y >= object.y-object.height and player.y <= object.y+object.height then
      mapHandlers(object.properties.map,object.name)
    end
  elseif object.properties.LoadZones == true and object.name == string.lower(object.name) then
    if player.x >= object.x-10 and player.x <= object.x+object.width and player.y >=object.y-object.height and player.y<=object.y+object.height then
      mapHandlers(object.properties.map,object.name)
    end
  end
end

cam:setPosition(player.x,player.y)
--cam:setPosition(cam.x+(player.xvel*.55),cam.y+(player.yvel*.55))
end

function player.LOAD()
player.load()
end

function player.UPDATE(dt)
player.physics(dt)
player.move(dt)
end

function player.DRAW()
player.draw()
end

function love.keyreleased(key)
if inventoryOpen == false and gamePause == false then
  if key == "j" then
    if inventory.Hotbar.jItem == "Sword" or inventory.Hotbar.jItem == "SharpSword" then swingSword() end
    if inventory.Hotbar.jItem == "Boomerang" or inventory.Hotbar.jItem == "EnchantedBoomerang" then throwBoomerang("j") end
  end
  if key == "k" then
    if inventory.Hotbar.kItem == "Sword" or inventory.Hotbar.kItem == "SharpSword" then swingSword() end
    if inventory.Hotbar.kItem == "Boomerang" or inventory.Hotbar.kItem == "EnchantedBoomerang" then throwBoomerang("k") end
  end
  if key == "w" or key == "up" then
    player.animation = charani.NulUp
  end
  if key == "s" or key == "down" then
    player.animation = charani.NulDown
  end
  if key == "a" or key == "left" then
    player.animation = charani.NulLeft
  end
  if key == "d" or key == "right" then
    player.animation = charani.NulRight
  end
end
if key == "e" then
  inventoryOpen = flipBool(inventoryOpen)
end
end

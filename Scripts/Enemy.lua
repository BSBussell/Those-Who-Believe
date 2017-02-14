local sti = require "sti"
map = sti("Maps/Protyping.lua", {"bump"})
world = require "Maps/maphandler"
local anim8 = require "Scripts/anim8"
require "Scripts/inventory"
require "Scripts/knockback"

enemy = {}
adder = 0

function enemy.load()
  enemy0Image = love.graphics.newImage("Images/EnemyPNG.png")
  local g = anim8.newGrid(16,16,16,64)
  enemy0Frames = g(1,2,1,4)
  enemy0Animation = anim8.newAnimation(enemy0Frames, 4)

  enemy1Image = love.graphics.newImage("Images/Enemy1.png")
  local g1 = anim8.newGrid(64,64,832,1344)
  enemy1DownFrames = g1('2-9',11)
  enemy1UpFrames = g1('2-9',9)
  enemy1LeftFrames = g1('2-9',10)
  enemy1RightFrames = g1('2-9',12)
  enemy1UpAnimation = anim8.newAnimation(enemy1UpFrames, 12)
  enemy1DownAnimation = anim8.newAnimation(enemy1DownFrames, 12)
  enemy1LeftAnimation = anim8.newAnimation(enemy1LeftFrames, 12)
  enemy1RightAnimation = anim8.newAnimation(enemy1RightFrames, 16)

  enemy1CrntAni = enemy1DownAnimation
end

function enemy.update(dt)

  for i=#enemy,1,-1 do
    local goalX
    local goalY
    while enemy[i] == nil do i = i-1 end

    local result = world:hasItem("Enemy "..enemy[i].id.." "..i)

    enemy0Animation:update(dt)
    enemy1CrntAni:update(dt)

    if enemy[i].hp <= 0 and result == true or enemy[i] == nil then
      world:remove("Enemy "..enemy[i].id.." "..i)
      world:add("Enemy "..enemy[i].id.." "..i,-200,-200,16,16)
      enemy[i].x = -200
      enemy[i].y = -200
      adder = adder+1
    elseif enemy[i].x>0 and enemy[i].stunned == false then
      if enemy[i].x + enemy[i].range >= player.x and enemy[i].x - enemy[i].range <= player.x and enemy[i].y + enemy[i].range >=player.y and enemy[i].y - enemy[i].range <= player.y then
        if player.x < enemy[i].x then
          goalX = enemy[i].x-enemy[i].speed*dt
          if enemy[i].id == 1 then enemy1CrntAni = enemy1LeftAnimation end
        else
          goalX = enemy[i].x+enemy[i].speed*dt
          if enemy[i].id == 1 then enemy1CrntAni = enemy1RightAnimation end
        end
        if player.y < enemy[i].y then
          goalY = enemy[i].y-enemy[i].speed*dt
          if enemy[i].id == 1 then enemy1CrntAni = enemy1UpAnimation end
        else
          goalY = enemy[i].y+enemy[i].speed*dt
          if enemy[i].id == 1 then enemy1CrntAni = enemy1DownAnimation end
        end
        local enemyFilter = function(item,other)
          if other=="Sword" then return 'bounce' end
          if other=="player" then return 'slide'
          else return "slide" end
        end
      else
        math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
        goalX = enemy[i].x + (enemy[i].speed*math.random(-.5,.5))*dt
        goalY = enemy[i].y + (enemy[i].speed*math.random(-.5,.5)) *dt
      end
      local actualX, actualY, cols, len = world:check("Enemy "..enemy[i].id.." "..i,goalX ,goalY,enemyFilter)

      for k = 1,len do
        local object = cols[k].other
        if object == "Sword" then
          enemy[i].hp = enemy[i].hp-inventory.Sword.damage
          goalX,goalY = calKnockback(goalX,goalY,enemy[i].x,enemy[i].y,100)
        end
        if object == "Boomerang" then
          enemy0Animation:pause()
          goalX,goalY = calKnockback(goalX,goalY,enemy[i].x,enemy[i].y,100)
          --enemy[i].stunned = true
          --enemy[i].stunTimer = inventory.Boomerang.stunTime
          enemy[i].hp = enemy[i].hp -inventory.Boomerang.damage
        end

      end
      local actualX, actualY, cols, len = world:move("Enemy "..enemy[i].id.." "..i,goalX ,goalY,enemyFilter)
      if stunned ~= true then
        enemy[i].x = actualX
        enemy[i].y = actualY
      end
      if enemy[i].stunTimer <= 0 then
        local stunned = false
        enemy0Animation:resume()
      elseif enemy[i].stunTimer >= 0 then
        enemy[i].stunTimer = enemy[i].stunTimer-1
      end
    end

  end
end

function enemy.newEnemy(id,x,y)
  enemyNum = table.getn(enemy)
  if id == 0 then
    --if enemyNum == nil then enemyNum = 1 end
    local newEnemy = {}
    newEnemy.id = id
    newEnemy.hp = 200
    --local x,y = map:convertTileToPixel(tx,ty)
    newEnemy.x = x
    newEnemy.y = y
    newEnemy.stunned = false
    newEnemy.stunTimer = 0
    newEnemy.speed = 16
    newEnemy.damage = .5
    newEnemy.range = 180
    table.insert(enemy,newEnemy)
    world:add("Enemy 0 "..enemyNum+1,x,y,16,16)
  elseif id == 1 then
    local newEnemy = {}
    newEnemy.id = id
    newEnemy.hp = 2500
    newEnemy.x = x
    newEnemy.y = y
    newEnemy.stunned = false
    newEnemy.stunTimer = 0
    newEnemy.speed = 16
    newEnemy.range = 200
    newEnemy.damage = 1.5
    table.insert(enemy,newEnemy)
    world:add("Enemy 1 "..enemyNum+1,x,y,30,32)
  end
end

function enemy.draw()
  for i=#enemy,1,-1 do
    if enemy[i]==nil then i=i-1 end
    local results = world:hasItem("Enemy "..enemy[i].id.." "..i)
    if enemy[i].x > 0 then
      if enemy[i].id == 0 then
        enemy0Animation:draw(enemy0Image, enemy[i].x,enemy[i].y)
      elseif enemy[i].id == 1 then
        enemy1CrntAni:draw(enemy1Image, enemy[i].x,enemy[i].y,0,.45)
      end
    end
  end
  love.graphics.setColor(255,255,255,255)
end

function enemy.swordCheck()

end

return enemy

local sti = require "states/Game/sti"

world = require "states/Game/Maps/maphandler"
local anim8 = require "states/Game/Scripts/anim8"
require "states/Game/Scripts/inventory"
require "states/Game/Scripts/knockback"

enemy = {}
adder = 0

function Enemyload()
  enemy0Image = love.graphics.newImage("states/Game/Images/EnemyPNG.png")
  local g = anim8.newGrid(16,16,16,64)
  enemy0Frames = g(1,2,1,4)
  enemy0Animation = anim8.newAnimation(enemy0Frames, 4)

  enemy1Image = love.graphics.newImage("states/Game/Images/Enemy1.png")
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

function Enemyupdate(dt)

  for i=#enemy,1,-1 do
    local goalX
    local goalY
    while enemy[i] == nil do i = i-1 end

    local result = world:hasItem(enemy[i].colId)

    enemy0Animation:update(dt)
    enemy1CrntAni:update(dt)

    if enemy[i].hp <= 0 and result == true or enemy[i] == nil then
      if math.random(1,5) == 1 and enemy[i].id ~= 1 then
        addObject("heart",enemy[i].x,enemy[i].y)
      end
      if enemy[i].id == 1 then
        addObject("heartCon",enemy[i].x,enemy[i].y)
      end
      world:remove(enemy[i].colId)
      --world:add(enemy[i].colId,-200,-200,16,16)
      --enemy[i].x = -200
      --enemy[i].y = -200
      adder = adder+1
      table.remove(enemy,i)
    elseif enemy[i].x>0 and enemy[i].stunned == false then
      if enemy[i].x + enemy[i].range >= player.x and enemy[i].x - enemy[i].range <= player.x and enemy[i].y + enemy[i].range >=player.y and enemy[i].y - enemy[i].range <= player.y then
        if player.x+(player.width/2) < enemy[i].x and enemy[i].xvel > -enemy[i].speed then
          enemy[i].xvel = enemy[i].xvel - enemy[i].speed *dt

        elseif enemy[i].xvel <enemy[i].speed then
          enemy[i].xvel = enemy[i].xvel + enemy[i].speed *dt

        end
        if player.y+(player.height/2) < enemy[i].y and enemy[i].yvel > -enemy[i].speed then
          enemy[i].yvel = enemy[i].yvel - enemy[i].speed*dt

        elseif enemy[i].yvel < enemy[i].speed then
          enemy[i].yvel = enemy[i].yvel+enemy[i].speed*dt

        end
        if enemy[i].id == 1 then
          if enemy[i].xvel > enemy[i].yvel then enemy1CrntAni = enemy1RightAnimation
          elseif enemy[i].xvel*-1 > enemy[i].yvel*-1 then enemy1CrntAni = enemy1LeftAnimation
          elseif enemy[i].xvel < enemy[i].yvel then enemy1CrntAni = enemy1DownAnimation
          elseif enemy[i].xvel*-1 < enemy[i].yvel*-1 then enemy1CrntAni = enemy1UpAnimation end
        end
        local enemyFilter = function(item,other)
          if other=="Sword" then return 'bounce'
          elseif other=="player" then return 'slide'
          elseif other=="Boomerang" then return 'touch'
          else return "slide" end
        end
      else
        math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) +((enemy[i].id+1)*math.random(-.5,.5)) )
        enemy[i].xvel = enemy[i].xvel + (enemy[i].speed*math.random(-.75,.75))*dt
        enemy[i].yvel = enemy[i].yvel + (enemy[i].speed*math.random(-.75,.75)) *dt
      end
      local goalX = enemy[i].x + enemy[i].xvel*dt
      local goalY = enemy[i].y + enemy[i].yvel*dt

      enemy[i].xvel = enemy[i].xvel * (1 - math.min(dt*enemy[i].friction, 1))
      enemy[i].yvel = enemy[i].yvel * (1 - math.min(dt*enemy[i].friction, 1))


      local actualX, actualY, cols, len = world:check(enemy[i].colId,goalX ,goalY,enemyFilter)

      local lefty = inventory["Hotbar"].jItem
      local righty = inventory["Hotbar"].kItem

      for k = 1,len do
        local object = cols[k].other
        if object == "Sword" then
          if string.find(lefty,"Sword") then
            damageAmt = inventory["Hotbar"].jItem
            --print(damageAmt)
          elseif string.find(righty,"Sword") then
            damageAmt = inventory["Hotbar"].kItem
            --print(damageAmt)
          end
          --print(damageAmt)
          enemy[i].hp = enemy[i].hp-inventory[damageAmt].damage
          local x,y,w,h = world:getRect("Sword")
          enemy[i].xvel,enemy[i].yvel = calKnockback(actualX,actualY,SwordCord[1],SwordCord[2],13)
          local colidSword = true
        end
        if object == "Boomerang" then
          enemy0Animation:pause()
          enemy[i].xvel,enemy[i].yvel = calKnockback(actualX,actualY,boomerangX,boomerangY,16.25)

          --enemy[i].stunned = true
          --enemy[i].stunTimer = inventory.Boomerang.stunTime
          enemy[i].hp = enemy[i].hp -inventory.Boomerang.damage
        end
        if object == "player" and not colidSword then
          local knckX,knckY = calKnockback(thX,thY, enemy[i].x,enemy[i].y,15)
          player.xvel = knckX
          player.yvel = knckY
          if (love.timer.getTime() - invFrames)> 1 then
            player.hp = player.hp - enemy[i].damage
            invFrames = love.timer.getTime()
            playerTint = {255,0,0,100}
          end

        end
      end
      local actualX, actualY, cols, len = world:move(enemy[i].colId,goalX ,goalY,enemyFilter)
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

function EnemynewEnemy(id,x,y)
  enemyNum = table.getn(enemy)
  if id == 0 then
    --if enemyNum == nil then enemyNum = 1 end
    local newEnemy = {}
    newEnemy.id = id
    newEnemy.hp = 40
    --local x,y = map:convertTileToPixel(tx,ty)
    newEnemy.x = x
    newEnemy.y = y
    newEnemy.xvel = 0
    newEnemy.yvel = 0
    newEnemy.friction = 3.9
    newEnemy.stunned = false
    newEnemy.stunTimer = 0
    newEnemy.speed = 250
    newEnemy.damage = 5
    newEnemy.range = 100
    newEnemy.colId = "Enemy 0 "..enemyNum+1
    table.insert(enemy,newEnemy)
    world:add("Enemy 0 "..enemyNum+1,x,y,16,16)
  elseif id == 1 then
    local newEnemy = {}
    newEnemy.id = id
    newEnemy.hp = 500
    newEnemy.x = x+5
    newEnemy.y = y+16
    newEnemy.xvel = 0
    newEnemy.yvel = 0
    newEnemy.friction = 3.9
    newEnemy.stunned = false
    newEnemy.stunTimer = 0
    newEnemy.speed = 490
    newEnemy.range = 150
    newEnemy.damage = 10
    newEnemy.colId = "Enemy 1 "..enemyNum+1
    table.insert(enemy,newEnemy)
    world:add("Enemy 1 "..enemyNum+1,x+5,y+16,15,25)
  end
end

function Enemydraw()
  for i=#enemy,1,-1 do
    if enemy[i]==nil then i=i-1 end
    local results = world:hasItem("Enemy "..enemy[i].id.." "..i)
    if enemy[i].x > 0 then
      if enemy[i].id == 0 then
        enemy0Animation:draw(enemy0Image, enemy[i].x,enemy[i].y)
        love.graphics.setColor(255, 0, 0, 255)
        if drawingMini then love.graphics.rectangle("line", enemy[i].x, enemy[i].y, 16, 16) end
      elseif enemy[i].id == 1 then
        enemy1CrntAni:draw(enemy1Image, enemy[i].x-7,enemy[i].y-7,0,.5)
        love.graphics.setColor(255, 0, 255, 255)

        if drawingMini then love.graphics.rectangle("line", enemy[i].x, enemy[i].y, 15, 25) end
      end
    end
    love.graphics.setColor(255,255,255,255)
  end
  love.graphics.setColor(255,255,255,255)
end

function enemyswordCheck()

end

return enemy

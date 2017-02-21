gamera = require "states/Game/Scripts/gamera"
Ui = {}

function Ui.load()
  swordUI = love.graphics.newImage("states/Game/Images/SwordICN.png")
  swordUI:setFilter("nearest")
  lFont = love.graphics.newFont( "states/Game/Fonts/coders_crux.ttf", 20 )
  BFont = love.graphics.newFont( "states/Game/Fonts/coders_crux.ttf", 40 )
  aFont = love.graphics.newFont( "states/Game/Fonts/Courier.dfont",25)
  aSmallFont = love.graphics.newFont( "states/Game/Fonts/Courier.dfont",15)
  newText = false

  --down = love.keyboard.isDown("space")
  --love.keyboard.setKeyRepeat(false)
  Life = love.graphics.newText(lFont,"HP: ")
  message = "Hey! You shouldn't see this, \nif you did then its a glitch please report"
end

function Ui.update(dt)
  dimen = cam:getWindow()

  x, y = love.mouse.getPosition()
  down = love.keyboard.isDown("space")
  --print(love.mouse.isDown(1))

  lifeWidth = (player.hp/player.maxHp)*player.maxHp
  utilex,utiley = map:convertPixelToTile(math.floor(player.x),math.floor(player.y))
end

function Ui.draw()
  love.graphics.setColor(0,0,0,255)
  love.graphics.rectangle("fill",0,0,1000,100)
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("line",1,1,998,99)
  love.graphics.setColor(0,0,255,255)
  love.graphics.rectangle("fill",300,10,50,75)
  love.graphics.rectangle("fill",225,10,50,75)
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(swordUI,300,15,0,3,4)
  love.graphics.print("HP: "..player.hp,900,10)
  love.graphics.print("X :"..player.x,900,20)
  love.graphics.print("Y :"..player.y,900,30)
  if inventory.Hotbar.kItem ~= "Empty" then
    local item = inventory.Hotbar.kItem
    love.graphics.draw(inventory[item].image,230,15,0,3,4)
  end
  love.graphics.setFont( lFont )
  love.graphics.print( "J", 320,10 )
  love.graphics.print( "K", 245,10 )
  love.graphics.print( "HP: ", 400,20 )

  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 80, 20)
  love.graphics.print("Enemy Count: "..#enemy,80,60)
  love.graphics.rectangle("line",410,35,player.maxHp+1,20)

  love.graphics.setColor(255,0,0,255)
  love.graphics.rectangle("fill",410,35,lifeWidth,20)
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("line",410,35,player.maxHp+1,20)
  for i = 1,player.maxHp/50 do
    love.graphics.line(410+(i*50),35,410+(i*50),55)
    love.graphics.line(410+(i*50),35,410+(i*50),55)
  end
  if newText == true then
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont( aFont )
    love.graphics.print(message,200,500)
    gamePause = true
    if love.mouse.isDown(1)~=true or inventoryOpen then
      newText = false
      gamePause = false
    end
  end

  if player.hp <= 0 then
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle("fill", 0, 0, 1000, 600)
    love.graphics.setColor(255,122,122,255)
    love.graphics.setFont( aFont )
    love.graphics.print("Game Over",500,250)
    love.graphics.setFont(aSmallFont)
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("Click to Restart",500,300)
    gamePause = true
    if down==false then
      --love.load()
      player.hp = player.maxHp
      map,world = mapHandlers("betaOverworld","Spawn")
      gamePause = false
    end
  end

  love.graphics.setColor(255,255,255,255)

end

function inventoryUIDraw()
  love.mouse.setVisible(true)
  love.graphics.setColor(255,255,255,155)
  love.graphics.rectangle("fill",20,120,960,400)
  love.graphics.setColor(255,255,255,195)
  love.graphics.rectangle("fill",750,130,215,380)
  love.graphics.setColor(255,255,255,55)
  love.graphics.setColor(255,255,255,255)

  local rpts = 1
  for k,v in ipairs(inventory["Space"]) do
    local item = inventory[inventory["Space"][k]].image
    --local drawable = love.graphics.newImage(item)
    --print(item)
    love.graphics.draw(item,50*k,140,0,3,4)
  end
  if inventory.Sword ~= nil then
    --love.graphics.draw(swordUI,25,140,0,3,4)
  end
  if inventory.Boomerang ~= nil then
    --love.graphics.draw(inventory.Boomerang.image,75,140,0,3,4)
  end
  if inventory.EnchantedBoomerang ~= nil then
    --love.graphics.draw(inventory.EnchantedBoomerang.image,125,140,0,3,4)
  end

  love.graphics.print("X: "..x,80,25)
  love.graphics.print("Y: "..y,80,40)

  if x>25 and x <57 and y>140 and y<204 then
    love.graphics.setFont( BFont )
    love.graphics.setColor(0,0,0,255)
    if down then love.graphics.rectangle("line",25,140,30,70) end
    love.graphics.print( inventory.Sword.name, 780,150 )
    love.graphics.setFont( lFont )
    love.graphics.print( "Damage: "..inventory.Sword.damage, 800,180 )
  elseif x > 75 and x<123 and y>140 and y <204 and inventory.Boomerang~= nil then
    love.graphics.setFont( BFont )
    love.graphics.setColor(0,0,0,255)
    if down == false then inventory.Hotbar.kItem = "Boomerang" end
    love.graphics.print( inventory.Boomerang.name, 780,150 )
    love.graphics.setFont( lFont )
    love.graphics.print( "Damage: "..inventory.Boomerang.damage, 800,180 )
    love.graphics.print( "Range: "..inventory.Boomerang.range, 800,200 )
  elseif x>125 and x <173 and y>140 and y<204 and inventory.EnchantedBoomerang ~= nil then
    love.graphics.setFont( BFont )
    love.graphics.setColor(0,0,0,255)
    if down then inventory.Hotbar.kItem = "EnchantedBoomerang" end
    love.graphics.print( inventory.EnchantedBoomerang.name, 780,150 )
    love.graphics.setFont( lFont )
    love.graphics.print( "Damage: "..inventory.EnchantedBoomerang.damage, 800,180 )
  elseif x>225 and x<275 and y>10 and y <85 then
    if down then inventory.Hotbar.kItem = "Empty" end
    if inventory.Hotbar.kItem ~= "Empty" then
      love.graphics.setFont( BFont )
      love.graphics.setColor(0,0,0,255)
      local item = inventory.Hotbar.kItem
      love.graphics.print( inventory[item].name, 780,150 )
      love.graphics.setFont( lFont )
      love.graphics.print( "Damage: "..inventory[item].damage, 800,180 )
    end
  end
  if boomerangActive == true then
    world:remove("Boomerang")
    boomerangActive = false
  end

  love.graphics.setColor(255,255,255,255)
end

function alert(text)
  newText = true
  message = text
  gamePause = true
end

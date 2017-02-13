gamera = require "Scripts/gamera"
Ui = {}

function Ui.load()
  swordUI = love.graphics.newImage("Images/Sword_Up.png")
  swordUI:setFilter("nearest")
  lFont = love.graphics.newFont( "Fonts/coders_crux.ttf", 20 )
  BFont = love.graphics.newFont( "Fonts/coders_crux.ttf", 40 )
  newText = false
  message = "Hey! You should see this, \nif you did then its a glitch please report"
end

function Ui.update(dt)
  dimen = cam:getWindow()

  x, y = love.mouse.getPosition()
  down = love.mouse.isDown(1)
  Life = love.graphics.newText(lFont,"HP: ")
  lifeWidth = (player.hp/player.maxHp)*100
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
  love.graphics.draw(swordUI,310,15,0,4,4)
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
  love.graphics.rectangle("line",410,35,100,20)
  love.graphics.setColor(255,0,0,255)
  love.graphics.rectangle("fill",410,35,lifeWidth,20)
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("line",410,35,100,20)
  if newText == true then
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont( BFont )
    love.graphics.print(message,200,500)
    gamePause = true
    if down then
      newText = false
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
  love.graphics.rectangle("fill",800,130,160,380)
  love.graphics.setColor(255,255,255,55)
  love.graphics.setColor(255,255,255,255)
  if inventory.Sword ~= nil then
    love.graphics.draw(swordUI,25,140,0,4,4)
  end
  if inventory.Boomerang ~= nil then
    love.graphics.draw(inventory.Boomerang.image,75,140,0,3,4)
  end
  if inventory.EnchantedBoomerang ~= nil then
    love.graphics.draw(inventory.EnchantedBoomerang.image,125,140,0,3,4)
  end

  love.graphics.print("X: "..x,80,25)
  love.graphics.print("Y: "..y,80,40)

  if x>25 and x <57 and y>140 and y<204 then
    love.graphics.setFont( BFont )
    love.graphics.setColor(0,0,0,255)
    if down then love.graphics.rectangle("line",25,140,30,70) end
    love.graphics.print( inventory.Sword.name, 820,150 )
    love.graphics.setFont( lFont )
    love.graphics.print( "Damage: "..inventory.Sword.damage, 840,180 )
  elseif x > 75 and x<123 and y>140 and y <204 and inventory.Boomerang~= nil then
    love.graphics.setFont( BFont )
    love.graphics.setColor(0,0,0,255)
    if down then inventory.Hotbar.kItem = "Boomerang" end
    love.graphics.print( inventory.Boomerang.name, 820,150 )
    love.graphics.setFont( lFont )
    love.graphics.print( "Damage: "..inventory.Boomerang.damage, 840,180 )
  elseif x>125 and x <173 and y>140 and y<204 and inventory.EnchantedBoomerang ~= nil then
    love.graphics.setFont( BFont )
    love.graphics.setColor(0,0,0,255)
    if down then inventory.Hotbar.kItem = "EnchantedBoomerang" end
    love.graphics.print( inventory.EnchantedBoomerang.name, 820,150 )
    love.graphics.setFont( lFont )
    love.graphics.print( "Damage: "..inventory.EnchantedBoomerang.damage, 840,180 )
  elseif x>225 and x<275 and y>10 and y <85 then
    if down then inventory.Hotbar.kItem = "Empty" end
    if inventory.Hotbar.kItem ~= "Empty" then
      love.graphics.setFont( BFont )
      love.graphics.setColor(0,0,0,255)
      local item = inventory.Hotbar.kItem
      love.graphics.print( inventory[item].name, 820,150 )
      love.graphics.setFont( lFont )
      love.graphics.print( "Damage: "..inventory[item].damage, 840,180 )
    end

  end

  love.graphics.setColor(255,255,255,255)
end

function alert(text)
  newText = true
  message = text
  gamePause = true
end

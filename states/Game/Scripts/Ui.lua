gamera = require "states/Game/Scripts/gamera"
local anim8 = require "states/Game/Scripts/anim8"
Ui = {}

function Ui.load()
  heartSheet = love.graphics.newImage("states/Game/Images/Heart.png")
  local hGrid = anim8.newGrid(16,16,heartSheet:getWidth(),heartSheet:getHeight())
  fullHeart = anim8.newAnimation(hGrid(1,1), 1)
  threeQuarterHeart = anim8.newAnimation(hGrid(2,1), 1)
  halfHeart = anim8.newAnimation(hGrid(1,2), 1)
  quarterHeart = anim8.newAnimation(hGrid(2,2), 1)
  emptyHeart = anim8.newAnimation(hGrid(1,3), 1)

  swordUI = love.graphics.newImage("states/Game/Images/SwordICN.png")
  swordUI:setFilter("nearest")
  lFont = love.graphics.newFont( "states/Game/Fonts/coders_crux.ttf", 20 )
  BFont = love.graphics.newFont( "states/Game/Fonts/coders_crux.ttf", 40 )
  aFont = love.graphics.newFont( "states/Game/Fonts/Courier.dfont",25)
  --clickFont = love.graphics.newFont( "states/Game/Fonts/Courier.dfont",15)
  aSmallFont = love.graphics.newFont( "states/Game/Fonts/Courier.dfont",15)
  newText = false

  mouseDown = nil
  start = true

  Life = love.graphics.newText(lFont,"HP: ")
  message = "Hey! You shouldn't see this, \nif you did then its a glitch please report"
  --love.mouse = nil
end

function Ui.update(dt)
  dimen = cam:getWindow()

  x, y = love.mouse.getPosition()
  -- Bug in Löve2D causes mouse to constantly return true, so this is a temporary work around that
  if love.mouse.isDown(1) and start ~= true then
    mouseDown = true
  elseif love.mouse.isDown(1) == false then
    mouseDown = false
    if start == true then
      start = nil
      mouseDown = true
    end
  end
  --print(love.mouse.isDown(1))

  lifeWidth = (player.hp/player.maxHp)*player.maxHp
  utilex,utiley = map:convertPixelToTile(math.floor(player.x),math.floor(player.y))
end

function Ui.draw()

  love.graphics.setColor(122,122,122,155)
  love.graphics.rectangle("fill",0,0,width,height-(height/1.2))
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("line",1,1,width-2,height-((height/1.2)-1))
  love.graphics.setColor(165,165,165,255)
  love.graphics.rectangle("fill",300,10,50,75)
  love.graphics.rectangle("fill",225,10,50,75)
  love.graphics.setColor(255,255,255,255)
  --love.graphics.draw(swordUI,300,15,0,3,4)
  love.graphics.print("HP: "..player.hp,900,10)
  love.graphics.print("X :"..player.x,900,20)
  love.graphics.print("Y :"..player.y,900,30)
  love.graphics.print("XVel :"..player.xvel,900,40)
  love.graphics.print("YVel :"..player.yvel,900,50)
  if inventory.Hotbar.jItem ~= "Empty" then
    local item = inventory.Hotbar.jItem
    love.graphics.draw(inventory[item].image,230,15,0,3,4)
  end
  if inventory.Hotbar.kItem ~= "Empty" then
    local item = inventory.Hotbar.kItem
    love.graphics.draw(inventory[item].image,300,15,0,3,4)
  end
  love.graphics.setFont( lFont )
  love.graphics.print( "K", 320,10 )
  love.graphics.print( "J", 245,10 )
  love.graphics.print( "HP: ", 400,20 )

  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 80, 20)
  love.graphics.print("Enemy Count: "..#enemy,80,60)
  --love.graphics.rectangle("line",410,35,player.maxHp+1,20)

  -- Hp Bar
  x = 2
  heartY = 15
  for i = 1,player.maxHp/20 do
    if player.hp-(20*(i-1)) >15 then
      fullHeart:draw(heartSheet,410+(x*20),heartY,0,1,1)
    elseif player.hp-(20*(i-1)) >10 then
      threeQuarterHeart:draw(heartSheet,410+(x*20),heartY,0,1,1)
    elseif player.hp-(20*(i-1)) >5 then
      halfHeart:draw(heartSheet,410+(x*20),heartY,0,1,1)
    elseif player.hp-(20*(i-1)) >0 then
      quarterHeart:draw(heartSheet,410+(x*20),heartY,0,1,1)
    else
      emptyHeart:draw(heartSheet,410+(x*20),heartY,0,1,1)
    end
    if x>=11 then

      heartY = heartY+15
      x = 1
    end
    x = x+1
  end

  -- Message Handler(Need's Update)
  if newText == true then
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", 190, 490, 620, 110)
    love.graphics.setColor(204, 230, 255, 155)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("fill", 191, 491, 619, 109)
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont(aSmallFont)
    love.graphics.print("Click to close. . .",630,580)
    love.graphics.setFont(aFont)
    love.graphics.printf(message,200,500,600)
    gamePause = true
    if mouseDown or inventoryOpen then
      newText = false
      gamePause = false
    end
  end

  if player.hp <= 0 then
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setColor(255,122,122,255)
    love.graphics.setFont( aFont )
    love.graphics.print("Game Over",425,250)
    love.graphics.setFont(aSmallFont)
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("Click to Restart",420,300)
    gamePause = true
    if mouseDown then
      --love.load()
      player.hp = player.maxHp
      map,world = mapHandlers("betaOverworld","Spawn")
      gamePause = false
      objects = {}
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
    love.graphics.setColor(255, 255, 255, 255)
    local item = inventory[inventory["Space"][k]].image
    local data = inventory[inventory["Space"][k]]
    if k == 1 then k = k/2 end
    love.graphics.draw(item,50*k,140,0,3,4)
    if x>50*k and x<k*50+(item:getWidth()*3) and y>140 and y<204 then
      love.graphics.setFont( BFont )
      love.graphics.setColor(0,0,0,255)
      if mouseDown then
        love.graphics.rectangle("line",k*50,140,item:getWidth()*3,item:getHeight()*4)
        store = data.name
        --inventory.Hotbar.kItem = data.name
      end
      love.graphics.print( data.name, 780,150 )
      love.graphics.setFont( lFont )
      love.graphics.print( "Damage: "..data.damage, 800,180 )
    end
  end

  if store ~= nil and x>225 and x<225+50 and y>10 and y<85 and mouseDown and store ~= inventory.Hotbar.kItem then
    inventory.Hotbar.jItem = store
    if inventory.Hotbar.kItem == inventory.Hotbar.jItem --[[or (string.find(inventory))]] then
      inventory.Hotbar.jItem = "Empty"
    end
  end
  if store ~= nil and x>300 and x<300+50 and y>10 and y<85 and mouseDown and store ~= inventory.Hotbar.jItem then
    inventory.Hotbar.kItem = store
    if inventory.Hotbar.jItem == inventory.Hotbar.kItem then
      inventory.Hotbar.kItem = "Empty"
    end
  end

  love.graphics.print("X: "..x,80,25)
  love.graphics.print("Y: "..y,80,40)

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

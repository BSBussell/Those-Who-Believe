buttons = {}

function load()
  --print("Hello World!")
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  courier = love.graphics.newFont("/states/Game/Fonts/Courier.dfont",25)
  MaxFps = 60
  --courier:setFilter('nearest','nearest')
end

function love.update(dt)
  --mdown = love.mouse.isDown(1)
  x = love.mouse.getX()
  y = love.mouse.getY()

end

function love.draw()

  drawButton("Single Player",(width/2)-100,(height/2-60),200,60,{0,122,255,255})
  drawButton("Multiplayer",(width/2)-100,(height/2)+20,200,60,{92,122,195,255})
  drawButton("Options",(width/2)-100,(height/2)+100,200,60,{101,122,195,255})
  if x>=(width/2)-100 and x<=(width/2)+100 and y>=(height/2)-60 and y<=(height/2) then
    love.graphics.rectangle("line", (width/2)-99, (height/2)-59, 200, 60)
  end
  if x>=(width/2)-100 and x<=(width/2)+100 and y>=(height/2)+20 and y<=(height/2)+80 then
    love.graphics.rectangle("line", (width/2)-99, (height/2)+19, 200, 60)
  end
  if x>=(width/2)-100 and x<=(width/2)+100 and y>=(height/2)+100 and y<=(height/2)+160 then
    love.graphics.rectangle("line", (width/2)-99, (height/2)+99, 200, 60)
  end
end

function love.mousepressed( x, y, button, istouch )
  if x>=(width/2)-100 and x<=(width/2)+100 and y>=(height/2)-60 and y<=(height/2) then
    loadState("Game")
  end
  if x>=(width/2)-100 and x<=(width/2)+100 and y>=(height/2)+20 and y<=(height/2)+80 then
    loadState("Multiplayer")
  end

  if x>=(width/2)-100 and x<=(width/2)+100 and y>=(height/2)+100 and y<=(height/2)+160 then
    loadState("Options")
  end
end

function drawButton(text,x,y,recWidth,recHeight,color)
  love.graphics.setColor(color)
  text = love.graphics.newText( courier, text )
  love.graphics.rectangle("fill", x, y, recWidth, recHeight)
  love.graphics.setColor(255,255,255,255)
  love.graphics.setFont(courier)
  love.graphics.draw(text,x+math.floor((recWidth/1.5)-text:getWidth()),y+math.floor((recHeight/2)),0,1,1,-62,1)
end

function sleep(a) local sec = tonumber(os.clock() + a); while (os.clock() < sec) do end end

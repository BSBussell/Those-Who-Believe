buttons = {}

function load()
  print("Hello World!")
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  courier = love.graphics.newFont("/states/Game/Fonts/Courier.dfont",25)
  --courier:setFilter('nearest','nearest')
end

function love.update(dt)
  mdown = love.mouse.isDown( 1 )
  x = love.mouse.getX()
  y = love.mouse.getY()
end

function love.draw()

  drawButton("Start Game",(width/2)-100,(height/2-60),200,60,{0,122,255,255})
  if x>=(width/2)-100 and x<=(width/2)+100 and y>=(height/2)-60 and y<=(height/2) then
    love.graphics.rectangle("line", (width/2)-99, (height/2)-59, 200, 60)
    if mdown then
      mdown = nil
      love.mouse.isDown(1)
      loadState("Game")
    end

  end
end

function drawButton(text,x,y,recWidth,recHeight,color)
  love.graphics.setColor(color)
  love.graphics.rectangle("fill", x, y, recWidth, recHeight)
  love.graphics.setColor(255,255,255,255)
  love.graphics.setFont(courier)
  love.graphics.print(text,x+math.floor((recWidth/1.15)-courier:getWidth(text)),y+math.floor((recHeight/2.5)))
end

function sleep(a) local sec = tonumber(os.clock() + a); while (os.clock() < sec) do end end

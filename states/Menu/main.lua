buttons = {}

function load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  courier = love.graphics.newFont("/states/Game/Fonts/Courier.dfont",25)

end

function love.update(dt)
  down = love.mouse.isDown( 1 )
  x = love.mouse.getX()
  y = love.mouse.getY()
end

function love.draw()

  drawButton("Start Game",(width/2)-100,(height/2-60),200,60,{0,122,255,255})
  if down then
    down = nil
    loadState("Game")

  end
end

function drawButton(text,x,y,recWidth,recHeight,color)
  love.graphics.setColor(color)
  love.graphics.rectangle("fill", x, y, recWidth, recHeight)
  love.graphics.setColor(255,255,255,255)
  love.graphics.setFont(courier)
  love.graphics.print(text,x+(recWidth/1.25)-courier:getWidth(text),y+(recHeight/2))
end

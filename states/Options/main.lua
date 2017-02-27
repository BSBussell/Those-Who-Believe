
function love.load()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
end

function love.update(dt)
  x = love.mouse.getX()
  y = love.mouse.getY()
end

function love.draw()
  drawButton("Fps: "..MaxFps.." ",(width/2)-100,(height/2-60),200,60,{0,122,255,255})
  drawButton(">    ",(width/2)+200,(height/2-60),50,60,{0,0,255,255})
  drawButton("<    ",(width/2)-200,(height/2-60),50,60,{0,0,255,255})
  drawButton("Back    ",(width/2)-100,(height/2)+20,200,60,{0,122,255,255})

  if x>=(width/2)+200 and x<=(width/2)+250 and y>=(height/2)-60 and y<=(height/2) then
    love.graphics.rectangle("line", (width/2)+201, (height/2)-59, 50, 60)
  end

  if x>=(width/2)-200 and x<=(width/2)-150 and y>=(height/2)-60 and y<=(height/2) then
    love.graphics.rectangle("line", (width/2)-199, (height/2)-59, 50, 60)
  end

  if x>=(width/2)-100 and x<=(width/2)+100 and y>=(height/2)+20 and y<=(height/2)+80 then
    love.graphics.rectangle("line", (width/2)-99, (height/2)+19, 200, 60)
  end
  if MaxFps > 60 then
    love.graphics.print("Note: than sixty will not work\non most Computers", width/5, 400)
  end
end

function love.mousepressed(x, y, button, isTouch)
  if x>=(width/2)+200 and x<=(width/2)+250 and y>=(height/2)-60 and y<=(height/2) then
    MaxFps = MaxFps + 5
  end
  if x>=(width/2)-200 and x<=(width/2)-150 and y>=(height/2)-60 and y<=(height/2) and MaxFps > 0 then
    MaxFps = MaxFps - 5
  end
  if x>=(width/2)-100 and x<=(width/2)+100 and y>=(height/2)+20 and y<=(height/2)+80 then
    loadState("Game")
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

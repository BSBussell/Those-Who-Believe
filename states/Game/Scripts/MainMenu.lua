menu = {}
function menu:button(text,x,y,width,height,color)
  love.graphics.setFont(aFont)
  love.graphics.setColor(color)
  love.graphics.rectangle(x,y,width,height)
  textWidth = aFont:getWidth(text)
  textX = (width/2)-textWidth
  love.graphics.print()
end

function Menuload()

end

function Menudraw()

end

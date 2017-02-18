function calKnockback(x,y,prevX,prevY,multiplier)
  reverseX = x-prevX
  reverseY = y-prevY
  --if reverseY <= 1 or
  knockbackX = reverseX*multiplier
  knockbackY = reverseY*multiplier
  --print ("KnockbackX:"..x+knockbackX)
  --print ("KnockbackY:"..y+knockbackY)
  return knockbackX, knockbackY
end

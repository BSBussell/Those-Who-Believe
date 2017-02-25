NPC = {}

function addNPC(id,x,y,image)
  newNpc = {}
  newNpc.id = id
  newNpc.x = x
  newNpc.y = y
  newNpc.image = love.graphics.newImage(image)
end

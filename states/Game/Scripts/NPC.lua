NPC = {}

function addNPC(name,id,x,y,image)
  newNpc = {}
  newNpc.id = id
  newNpc.tileId = name
  newNpc.x = x
  newNpc.y = y
  newNpc.image = love.graphics.newImage(image)
end

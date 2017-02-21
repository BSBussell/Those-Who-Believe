inventory = {}

function inventory.load()
  inventory["Sword"] = {
    name = "The Old Sword",
    damage = 20,
    image = love.graphics.newImage("states/Game/Images/SwordICN.png")
  }
  inventory["Hotbar"] = {
    --J = swingSword(),
    jItem = "Sword",
    --K = "Empty",
    kItem = "Empty",
  }
  inventory["Space"] = {
    "Sword"
  }
  --[[
  inventory["EnchantedBoomerang"] = {
    name = "EnchantedBoomerang",
    damage = 0,
    stunTime = 12,
    range = 24,
    image = love.graphics.newImage("Images/EnchantedBoomerang.png")
  }
  ]]--
end

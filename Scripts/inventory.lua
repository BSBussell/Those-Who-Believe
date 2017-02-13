inventory = {}

function inventory.load() 
    inventory["Sword"] = {
        name = "Sword",
        damage = 10,
        image = "Swords.png"
        
    }
    inventory["Hotbar"] = {
        --J = swingSword(),
        jItem = "Sword",
        --K = "Empty",
        kItem = "Empty",
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

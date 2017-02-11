local map = require 'Maps/Protyping02'
local bump = require 'Scripts/bump'
local sti = require 'sti'
map = sti("Maps/Protyping02.lua", {"bump"})
world = bump.newWorld()

map:bump_init(world)


function loadEnemies() 
    for k, object in pairs(map.objects) do
        if object.name == "0" then
            enemy.newEnemy(0,object.x,object.y)
        elseif object.name == "1" then
            enemy.newEnemy(1,object.x,object.y)
        end
    end     
end

return world


local map = require 'Maps/Protyping'
local bump = require 'Scripts/bump'
local sti = require 'sti'
map = sti("Maps/Protyping.lua", {"bump"})
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

function loadChestSpace()
    for k, object in pairs(map.objects) do
        if object.name == "ChestSpace" then
            return object.x, object.y
        end
    end     
end
    

function replace_tile(map, layer, tilex, tiley, newTileGid) layer = map.layers[layer] for i, instance in ipairs(map.tileInstances[layer.data[tiley][tilex].gid]) do if instance.layer == layer and instance.x/map.tilewidth+1 == tilex and instance.y/map.tileheight+1 == tiley then instance.batch:set(instance.id, map.tiles[newTileGid].quad, instance.x, instance.y) break end end end

-- Replace tile at x=65 y=78 in layer 1 by tile with gid 304 replace_tile(map, 65, 78, 10, 304)

return world


local map = require 'Maps/Protyping'
local bump = require 'Scripts/bump'
local sti = require 'sti'
overworldMaps = {}
--betaOverworld = sti("Maps/Protyping.lua", {"bump"})
--betaMap2 = sti('Maps/Overworld.lua',{"bump"})
--map = betaOverworld
--world = bump.newWorld()

--map:bump_init(world)

function mapHandlers(crntMap)
  if map ~= false then
    for i,v in pairs(map.layers) do
      --bump_removeLayer (v, world)
    end
    sti:flush()
  end
  if crntMap == "betaOverworld" then
    map = sti("Maps/Protyping.lua", {"bump"})
  elseif crntMap == "betaMap2" then
    map = sti('Maps/Overworld.lua',{"bump"})
    worldinit = true
    --cam:setWorld(-200,-200,1200,1200)
  end
  enemy = {}
  adder = 0

  if worldinit == false then world = bump.newWorld() end
  worldinit = true

  map:bump_init(world)
  --loadEnemies()
end

function loadEnemies()
  for k, object in pairs(map.objects) do
    if object.name == "0" then
      EnemynewEnemy(0,object.x,object.y)
    elseif object.name == "1" then
      EnemynewEnemy(1,object.x,object.y)
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

function loadZone(object)
  prop = object.properties
  identitier = object.name

  --player.x = -20
  --player.y = -20
  crntmap = prop.Map
  mapHandlers(betaMap2)

  print "Test"
end

function replace_tile(map, layer, tilex, tiley, newTileGid) layer = map.layers[layer] for i, instance in ipairs(map.tileInstances[layer.data[tiley][tilex].gid]) do if instance.layer == layer and instance.x/map.tilewidth+1 == tilex and instance.y/map.tileheight+1 == tiley then instance.batch:set(instance.id, map.tiles[newTileGid].quad, instance.x, instance.y) break end end end

-- Replace tile at x=65 y=78 in layer 1 by tile with gid 304 replace_tile(map, 65, 78, 10, 304)

return world

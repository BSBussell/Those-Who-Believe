local bump = require 'states/Game/Scripts/bump'
local sti = require 'states/Game/sti'

overworldMaps = {}

function mapHandlers(crntMap,name)

  sti:flush()

  if crntMap == "betaOverworld" then
    map = sti("states/Game/Maps/Protyping.lua", {"bump"})
    world = bump.newWorld()
    map:bump_init(world)
    for k, object in pairs(map.objects) do
      if object.name == string.upper(name) and object.name ~= "Spawn" then
        local objectX, objectY = map:convertPixelToTile(object.x,object.y)
        fooX = objectX+object.properties.offsetX
        fooY = objectY+object.properties.offsetY
        --print(fooX.."22")
      elseif object.name == "Spawn" and name == "Spawn" then
        local objectX, objectY = map:convertPixelToTile(object.x,object.y)
        fooX = objectX+object.properties.offsetX
        fooY = objectY+object.properties.offsetY
      end
    end

    X,Y = map:convertTileToPixel(fooX,fooY)
  elseif crntMap == "betaMap2" then
    map = sti('states/Game/Maps/LoadZoneTest.lua',{"bump"})
    world = bump.newWorld()
    map:bump_init(world)
    for k, object in pairs(map.objects) do
      if object.name == string.lower(name) then
        local objectX, objectY = map:convertPixelToTile(object.x,object.y)
        fooX = objectX+object.properties.offsetX
        fooY = objectY+object.properties.offsetY
      elseif object.name == "Spawn" and name == "Spawn" then
        local objectX, objectY = map:convertPixelToTile(object.x,object.y)
        fooX = objectX+object.properties.offsetX
        fooY = objectY+object.properties.offsetY
      end
    end
    X,Y = map:convertTileToPixel(fooX,fooY)
  end
  enemy = {}
  adder = 0

  player.load(X,Y)

  loadEnemies()
  return map,world

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
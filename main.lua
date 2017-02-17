gamera = require "Scripts/gamera"
require "Scripts/player"
require "Scripts/Enemy"
require "Scripts/Ui"
require "Scripts/inventory"
love.graphics.setDefaultFilter( 'nearest', 'nearest' )
local bump = require 'Scripts/bump'
local anim8 = require 'Scripts/anim8'
worldinit = false
local sti = require "sti"
require "Maps/maphandler"
--print "Test"

--mapHandlers("betaOverworld")
function love.load()
  love.window.setMode(1000, 600)
  love.window.setTitle( "Project Z v0.01 Beta" )

  inventory.load()
  cam = gamera.new(0,0,1000,500)
  map,world = mapHandlers("betaOverworld","a")

  map:resize (1000, 600)
  loadEnemies()
  math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
  gamePause = false
  inventoryOpen = false
  cam:setWindow(0,0,1000,600)
  cam:setWorld(0,0,10384,6240)
  cam:setScale(1.8)
  --player.load()
  --miniCam = gamera.new(0,0,10384,6240)
  --miniCam:setWindow(600,10,200,80)
  --miniCam:setScale(1)
  Enemyload()
  Ui.load()
end

function love.update(dt)
  if inventoryOpen == false and gamePause == false then
    map:update(dt)
    love.mouse.setVisible(false)
    if player == nil then player.load() end
    player.physics(dt)
    player.move(dt)
    Enemyupdate(dt)
  end
  Ui.update(dt)
end

function love.draw()

  cam:draw(function()
      map:draw()
      player.draw()
      --map:bump_draw(world)

      Enemydraw()
      love.graphics.setColor(255, 0, 0, 255)
      love.graphics.setColor(255, 255, 255, 255)

    end)
  if inventoryOpen == true then inventoryUIDraw() end
  Ui.draw()
  --miniCam:draw(function()
  -- map:draw()
  -- end)

end

function flipBool(bool)
  if bool == true then return false
  else return true end
end

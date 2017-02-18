-- Benjamin S. Bussell
-- January 26, 2017

--Set Depenndiencies
gamera = require "states/Game/Scripts/gamera"
require "states/Game/Scripts/player"
require "states/Game/Scripts/Enemy"
require "states/Game/Scripts/Ui"
require "states/Game/Scripts/inventory"
require "states/Game/Maps/maphandler"
local bump = require 'states/Game/Scripts/bump'
local anim8 = require 'states/Game/Scripts/anim8'
local sti = require "states/Game/sti"

-- Set Everything to be HD by default
love.graphics.setDefaultFilter( 'nearest', 'nearest' )

function load()
  -- Setup the Window
  love.window.setMode(1000, 600)
  love.window.setTitle( "Project Z v0.01 Beta" )
  -- Create inventory table
  inventory.load()
  -- Create Camera
  cam = gamera.new(0,0,1000,500)
  cam:setWindow(0,0,1000,600)
  cam:setWorld(0,0,10384,6240)
  cam:setScale(1.8)
  -- Create Map
  map,world = mapHandlers("betaOverworld","Spawn")
  map:resize (1000, 600)
  -- Give the game true random
  math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
  -- init pausing variables
  gamePause = false
  inventoryOpen = false
  -- Load Enememies
  Enemyload()
  -- Load Ui
  Ui.load()
end

function love.update(dt)
  -- Check if game is pause
  if inventoryOpen == false and gamePause == false then
    -- Update map and plater and enemies
    map:update(dt)
    love.mouse.setVisible(false)
    if player == nil then player.load() end
    player.physics(dt)
    player.move(dt)
    Enemyupdate(dt)
  end
  -- Always Update UI
  Ui.update(dt)
end

function love.draw()

  -- What is drawn within the Camera
  cam:draw(function()
      -- Drawing the map, player and enemies then resetting the color
      map:draw()
      player.draw()
      Enemydraw()
      love.graphics.setColor(255, 255, 255, 255)
    end)
  -- Check if the inventory is opened
  if inventoryOpen == true then inventoryUIDraw() end

  Ui.draw()

end

-- A Function which can be used to flip a Boolean
-- From True to False or vise-versa
function flipBool(bool)
  if bool == true then return false
  else return true end
end
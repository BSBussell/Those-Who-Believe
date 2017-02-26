--[[
    Benjamin S. Bussell
    January 26, 2017
--]]


local bump = require 'states/Game/Scripts/bump'      -- Bump
local anim8 = require 'states/Game/Scripts/anim8'    -- anim8
local sti = require "states/Game/sti"                -- STI
local gamera = require "states/Game/Scripts/gamera"  -- Gamera

require "states/Game/Scripts/player"                 -- Player
require "states/Game/Scripts/Enemy"                  -- Enemy
require "states/Game/Scripts/Ui"                     -- UI
require "states/Game/Scripts/inventory"              -- Inventory
require "states/Game/Maps/maphandler"                -- Maphandler
require "states/Game/Scripts/dynamicObjects"

-- Set Everything to be HD by default
love.graphics.setDefaultFilter( 'nearest', 'nearest' )

function load()
  -- Setup the Window
  flags = {
    resizable=true,
    vsync=true,
    minwidth=400,
    minheight=300
  }

  width, height = love.graphics.getDimensions( )
  love.window.setMode(width, height,flags)
  love.window.setTitle( "Project Z v0.1.5 Beta" )

  min_dt = 1/60
  next_time = love.timer.getTime()

  -- Create inventory table
  inventory.load()
  -- Create Camera
  cam = gamera.new(0,0,width,height/1.2)
  cam:setWindow(0,0,width,height)
  cam:setWorld(0,0,10384,6240)
  cam:setScale(1.8)
  -- Create Map
  map,world = mapHandlers("betaOverworld","Spawn")
  map:resize (width, height)
  -- Give the game true random-ish
  math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
  -- init pausing variables
  gamePause = false
  inventoryOpen = false
  -- Load Enememies
  Enemyload()
  -- Load Ui
  Ui.load()

  --addObject("heart",180,1770)
  --addObject("heart",190,1770)
end

function love.update(dt)
  next_time = next_time + min_dt

  -- Check if game is pause
  if inventoryOpen == false and gamePause == false then
    -- Update map and plater and enemies
    map:update(dt)
    love.mouse.setVisible(false)
    if player == nil then player.load() end
    player.physics(dt)
    player.move(dt)
    Enemyupdate(dt)
    updateObject()
  end
  -- Always Update UI
  Ui.update(dt)
end

function love.draw()

  -- What is drawn within the Camera
  cam:draw(function()
      -- Drawing the map, player and enemies then resetting the color
      map:draw()
      drawObject()
      player.draw()
      Enemydraw()
      love.graphics.setColor(255, 255, 255, 255)
    end)
  -- Check if the inventory is opened
  if inventoryOpen == true then inventoryUIDraw() end

  Ui.draw()

  local cur_time = love.timer.getTime()
   if next_time <= cur_time then
      next_time = cur_time
      return
   end
   love.timer.sleep(next_time - cur_time)
end

function love.resize()
    width, height = love.graphics.getDimensions( )
  cam:setWindow(0,0,width,height)
  map:resize (width, height)
end

-- A Function which can be used to flip a Boolean
-- From True to False or vise-versa
function flipBool(bool)
  local foo4 = not bool
  return foo4
  --if bool == true then return false
  --else return true end
end

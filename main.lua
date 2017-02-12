
gamera = require "Scripts/gamera"
require "Scripts/player"
require "Scripts/Enemy"
require "Scripts/Ui"
require "Scripts/inventory"
love.graphics.setDefaultFilter( 'nearest', 'nearest' )
local bump = require 'Scripts/bump'
local anim8 = require 'Scripts/anim8'

require "Maps/Protyping02"
local sti = require "sti"
world = require "Maps/maphandler"
print "Test"



function love.load()
 	love.window.setMode(1000, 600)
    love.window.setTitle( "Project Z v0.01 Beta" )
    
    
    inventory.load()
	map:resize (10400, 6230)
    loadEnemies()
    math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
    --enemy.newEnemy(0,44,79)
    
 	--enemy.newEnemy(0,64,81)
    
    --enemy.newEnemy(0,40,89)
    --enemy.newEnemy(0,85,74)
    gamePause = false
    inventoryOpen = false
 	cam = gamera.new(0,0,1000,500)
    cam:setWindow(0,0,1000,600)
    cam:setWorld(0,-32,10400,6240)
    cam:setScale(1.8)
    enemy.load()
 	player.load()
 	Ui.load()
end
 
function love.update(dt)
 	if inventoryOpen ==  false and gamePause == false then
 	  map:update(dt)
      love.mouse.setVisible(false) 
 	
 	
 	  player.physics(dt)
 	  player.move(dt)
 	  enemy.update(dt)
    end
    Ui.update(dt)
end
 
function love.draw()
    
    cam:draw(function()
       map:draw()
	   player.draw(link)
       enemy.draw()
	   love.graphics.setColor(255, 0, 0, 255)
	   love.graphics.setColor(255, 255, 255, 255)
        
    end)
    Ui.draw()
    if inventoryOpen == true then inventoryUIDraw() end
    
end

function flipBool(bool)
        if bool == true then return false
        else return true end
end

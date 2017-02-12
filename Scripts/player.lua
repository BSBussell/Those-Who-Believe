local bump = require 'Scripts/bump'
local sti  = require 'sti'
player = {} 
world = require "Maps/maphandler"
require "Scripts/Ui"
require "Scripts/inventory"
require "Scripts/itemHandler"

require "Maps/Protyping02"

local anim8 = require 'Scripts/anim8'




--this is where we set atributes of the player 
function player.load() 
	
    char = love.graphics.newImage("Images/CharDemo.png")
    local g =  anim8.newGrid(64,64,char:getWidth(),char:getHeight())
    local charBackward = g('2-9',1)
    local charLeft = g('2-9',2)
    local charForeward = g('2-9',3)
    local charRight = g('2-9',4)
    local charNillUp = g(1,1)
    local charNillLeft = g(1,2)
    local charNillDown = g(1,3)
    local charNillRight = g(1,4)
    charani = {
        NulUp = anim8.newAnimation(charNillUp, .12),
        NulRight = anim8.newAnimation(charNillRight, .06),
        NulDown = anim8.newAnimation(charNillDown, .06),
        NulLeft = anim8.newAnimation(charNillLeft, .06),
        Right = anim8.newAnimation(charRight, .06),
        Up = anim8.newAnimation(charForeward, .06),
        Down = anim8.newAnimation(charBackward, .06),
        Left = anim8.newAnimation(charLeft, .06),
    }
    
    player.animation = charani.NulUp
    
    Sword_Up = love.graphics.newImage("Images/Sword_Up.png")
    Sword_Down = love.graphics.newImage("Images/Sword_Down.png")
    Sword_Left = love.graphics.newImage("Images/Sword_Left.png")
    Sword_Right = love.graphics.newImage("Images/Sword_Right.png")
    Sword_Down:setFilter("nearest")
    Sword_Left:setFilter("nearest")
    Sword_Right:setFilter("nearest")
    Sword_Up:setFilter("nearest")
    local sword = Sword_Down
    timer = 0
    SwordCord = {420,420,2,2}
	local multiplier = 0
	local still = 0
	swordActive = false
    world:add("Sword",SwordCord[1],SwordCord[2],SwordCord[3],SwordCord[4])
	fr = true

    
	

    player.hp = 800
    player.maxHp = 800
    local x,y = map:convertTileToPixel(13,51)
    world:add("player", x,y,30,22)
	player.x = x
	player.y = y
	player.width = 14 
	player.height = 14
	player.xvel = 0 
	player.yvel = 0 
	player.friction = 3.9 
	player.speed = 390
    
    boomerangActive = false
    
end 

--this is player is drawn from 
function player.draw() 
    player.animation:draw(char,player.x,player.y-12,0,.45)
	
	if timer > 0 then 
        love.graphics.draw(sword, SwordCord[1], SwordCord[2]) 
        
    end
	if boomerangActive == true then
        love.graphics.draw(inventory.Boomerang.image,boomerangX,boomerangY,rotation,.65,.65)
    end
	if timer == 0  then 
		multiplier = 0
		still = 0 
		swordActive = false
		world:remove("Sword")
		
	end
    timer = timer-1
	
end 

--this is physics start
function player.physics(dt) 
    if swordActive ~= true then
        
            
        local playerFilter = function(item,other)
            for i,v in ipairs(enemy) do
                if other == "Enemy "..enemy[i].id.." "..i then return "bounce"  end
            end
            if other == "Sword" then
                return nil
            else return "slide" end
        --return "slide"
        end
	   local actualX, actualY, cols,len = world:move("player",player.x + player.xvel*dt, player.y + player.yvel*dt, playerFilter)
	player.x, player.y = actualX, actualY
        
       --tiley,tilex = map:convertPixelToTile(math.floor(actualX),math.floor(actualY))
        --local currentTile = {}
       --currentTile = map:getTileProperties ("Base", tilex,tiley)
        --if currentTile.isSwimable then
        --    player.friction = 1.2
        --    player.speed = 30
        --else
        --    player.friction = 4.9
        --    player.speed = 390
        --end
       for i = 1, len do
            local object = cols[i].other
            for i,v in ipairs(enemy) do
                if object == "Enemy "..enemy[i].id.." "..i  then
                    player.hp = player.hp - enemy[i].damage
                    if player.hp<=0 then
                        error("\n\n\nYou Died\n")
                    end
                end
            end
        end
        
	   player.xvel = player.xvel * (1 - math.min(dt*player.friction, 1)) 
	   player.yvel = player.yvel * (1 - math.min(dt*player.friction, 1))
    
    end
    
end 

--this is where the movement is handled 
function player.move(dt) 
   if boomerangActive == true then boomerangUpdate(dt) end
    if ((love.keyboard.isDown("d") or love.keyboard.isDown("right")) and 
		player.xvel < player.speed) and swordActive == false then 
		player.xvel = player.xvel + player.speed * dt
		SwordCord = {player.x+16,player.y+5,20,6}
		sword = Sword_Right
        player.animation = charani.Right
    end

	if ((love.keyboard.isDown("a") or love.keyboard.isDown("left")) and 
		player.xvel > -player.speed) and swordActive == false then 
		player.xvel = player.xvel - player.speed * dt
		SwordCord = {player.x-4,player.y+4,20,6}
		sword = Sword_Left
        player.animation = charani.Left
    end

	if ((love.keyboard.isDown("s") or love.keyboard.isDown("down")) and 
		player.yvel < player.speed) and swordActive == false then     
		SwordCord = {player.x+(player.width*.25),player.y+8,6,20}
		sword = Sword_Down
		player.yvel = player.yvel + player.speed * dt 
		
        player.animation = charani.Up
    end
	if ((love.keyboard.isDown("w") or love.keyboard.isDown("up")) and 
		player.yvel > -player.speed) and swordActive == false then 
		SwordCord = {player.x+(player.width*.25),player.y-player.height,6,20}
		sword = Sword_Up
		player.yvel = player.yvel - player.speed * dt 
		player.animation = charani.Down
    end
    
     player.animation:update(dt)
	if player.x >= 1025 and player.x <= 1045 and player.y >=1263 and player.y<=1298 and love.keyboard.isDown("space") and inventory.Boomerang ==nil then
        inventory["Boomerang"] = {
            name = "Boomerang",
            damage = 500,
            stunTime = 12,
            range = 198,
            speed = 10,
            image = love.graphics.newImage("Images/Boomerang.png")
        }
        alert("\tYou Found a Boomerang!\nOpen up your inventory with E to equip it\nClick to close")
    end
    
	
    cam:setPosition(player.x,player.y)
    cam:setPosition(cam.x+(player.xvel*.35),cam.y+(player.yvel*.35))
    map:setDrawRange(player.x-500,player.y-300,player.x+500,player.y+300)
	
	
end 

--functions are put here to be easily managaed in the main file 
function player.LOAD() 
	player.load() 
end 

function player.UPDATE(dt) 
	player.physics(dt) 
	player.move(dt) 
end 

function player.DRAW() 
	player.draw() 
end 

function love.keyreleased(key)
	if inventoryOpen == false and gamePause == false then
        if key == "j" and inventory.Sword ~= nil then
		  if inventory.Hotbar.jItem == "Sword" then swingSword() end
          if inventory.Hotbar.jItem == "Boomerang" then throwBoomerang() end
	    end
        if key == "k" and inventory.Boomerang ~= nil then
          if inventory.Hotbar.kItem == "Sword" then swingSword() end
          if inventory.Hotbar.kItem == "Boomerang" then throwBoomerang() end
        end
        if key == "w" or key == "up" then
            player.animation = charani.NulUp
        end
        if key == "s" or key == "down" then
            player.animation = charani.NulDown
        end
        if key == "a" or key == "left" then
            player.animation = charani.NulLeft
        end
        if key == "d" or key == "right" then
            player.animation = charani.NulRight
        end
    end
    if key == "e" then
            inventoryOpen = flipBool(inventoryOpen)
    end
end

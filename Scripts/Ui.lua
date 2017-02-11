gamera = require "Scripts/gamera"
Ui = {}

function Ui.load()
    swordUI = love.graphics.newImage("Images/Sword_Up.png")
    swordUI:setFilter("nearest")
end

function Ui.update(dt)
    dimen = cam:getWindow()
    lFont = love.graphics.newFont( "Fonts/coders_crux.ttf", 20 )
    Life = love.graphics.newText(lFont,"HP: ")
    lifeWidth = (player.hp/player.maxHp)*100
    utilex,utiley = map:convertPixelToTile(math.floor(player.x),math.floor(player.y))
end

function Ui.draw()
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle("fill",0,0,1000,100)
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("line",1,1,998,99)
    love.graphics.setColor(0,0,255,255)
    love.graphics.rectangle("fill",300,10,50,75)
    love.graphics.rectangle("fill",225,10,50,75)
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(swordUI,310,15,0,4,4)
    if inventory.Boomerang ~= nil then
        love.graphics.draw(inventory.Boomerang.image,230,15,0,3,4)
    end
    love.graphics.setFont( lFont )
    love.graphics.print( "J", 320,10 )
    love.graphics.print( "K", 245,10 )
    love.graphics.print( "HP: ", 400,20 )
    --love.graphics.print("X: "..utilex,80,20)
    --love.graphics.print("Y: "..utileY,80,40)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 80, 20)
    love.graphics.print("Enemy Hp: "..#enemy,80,60)
    love.graphics.rectangle("line",410,35,100,20)
    love.graphics.setColor(255,0,0,255)
    love.graphics.rectangle("fill",410,35,lifeWidth,20)
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("line",410,35,100,20)
    
    
    love.graphics.setColor(255,255,255,255)
end

function inventory.Draw()
    love.graphics.setColor(255,255,255,155)
    love.graphics.rectangle("fill",20,120,960,400)
    love.graphics.setColor(255,255,255,55)
    love.graphics.setColor(255,255,255,255)
    if inventory.Sword ~= nil then
        love.graphics.draw(swordUI,25,140,0,4,4)
    end
    if inventory.Boomerang ~= nil then
        love.graphics.draw(inventory.Boomerang.image,75,140,0,3,4)
    end
end
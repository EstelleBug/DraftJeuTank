local bulletManager = require "bulletManager"
local map = require "map"

local hero = {}

local positionX = 0
local positionY = 0
local angle = 0
local angleBarrel = 0
local rotationSpeed = 2
local moveSpeed = 100
local imageBody = love.graphics.newImage("images/tankBody_blue_outline.png")
local imageBarrel1 = love.graphics.newImage("images/tankBlue_barrel2_outline.png")
local imageBarrel2 = love.graphics.newImage("images/tankBlue_barrel2.png")
--local imageBodyWidth = imageBody:getWidth()
--local imageBodyHeight = imageBody:getHeight()
local radius = 30
local shootSpeed = 300
local owner = "hero"

function hero.Init(x, y)
    positionX = x
    positionY = y
    angle = 0
    rotationSpeed = 2
    moveSpeed = 100
end

function hero.Update(dt)
    -- Hero command's

    angleBarrel = math.atan2(love.mouse.getY() - positionY, love.mouse.getX() - positionX)


    if love.keyboard.isDown("left") then
        angle = angle - rotationSpeed * dt
    elseif love.keyboard.isDown("right") then
        angle = angle + rotationSpeed * dt
    end

    if love.keyboard.isDown("up") then
        local vx = math.cos(angle) * moveSpeed
        local vy = math.sin(angle) * moveSpeed
        positionX = positionX + vx * dt
        positionY = positionY + vy * dt
        if map.CollisionHero == true then
            print("collisions !2")
            positionX = positionX - vx * dt - 0.2
            positionY = positionY - vy * dt - 0.2
            map.CollisionHero = false
        end
    end

    -- Keep my hero on screen
    if positionX + radius <= 0 then
        positionX = love.graphics.getWidth() + radius
    elseif positionX - radius >= love.graphics.getWidth() then
        positionX = 0 - radius
    end

    if positionY + radius <= 0 then
        positionY = love.graphics.getHeight() + radius
    elseif positionY - radius >= love.graphics.getHeight() then
        positionY = 0 - radius
    end
end

function hero.Draw()
    love.graphics.draw(imageBody, positionX, positionY, angle, 1, 1, imageBody:getWidth() * 0.5,
        imageBody:getHeight() * 0.5)

    love.graphics.circle("line", positionX, positionY, radius)

    -- Draw the trajectory of the shot

    love.graphics.setColor(0, 0, 255)
    love.graphics.setLineWidth(2)
    local mouseX, mouseY = love.mouse.getPosition()

    love.graphics.line(mouseX - 10, mouseY, mouseX + 10, mouseY) -- cross horizontal line
    love.graphics.line(mouseX, mouseY - 10, mouseX, mouseY + 10) -- cross vertical line

    love.graphics.setLineStyle("smooth")
    love.graphics.line(mouseX, mouseY, positionX, positionY) -- trajectory line

    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(0)

    love.graphics.draw(imageBarrel1, positionX, positionY, angleBarrel, 1, 1, imageBarrel1:getWidth() * 0.2,
        imageBarrel1:getHeight() * 0.5)
    love.graphics.draw(imageBarrel2, positionX, positionY, angleBarrel, 1, 1, imageBarrel2:getWidth() * 0.2,
        imageBarrel2:getHeight() * 0.5)
end

function hero.Shoot()
    bulletManager.NewBullet(positionX, positionY, angleBarrel, shootSpeed, owner)
end

function hero.GetPosition()
    return positionX, positionY
end

function hero.GetSize()
    return radius
    --return imageBodyWidth, imageBodyHeight
end

return hero
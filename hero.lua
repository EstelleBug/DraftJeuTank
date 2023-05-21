local bulletManager = require "bulletManager"
local map = require "map"

-- Create the hero object
local hero = {}

-- Hero properties
local positionX = 0
local positionY = 0
local angle = 0
local angleBarrel = 0
local rotationSpeed = 0
local moveSpeed = 0
local radius = 25
local shootSpeed = 300
local owner = "hero"
local nbrLifeHero = 1

-- Load images and sound for the hero
local imageBody = love.graphics.newImage("images/tankBody_blue_outline.png")
local imageBarrel1 = love.graphics.newImage("images/tankBlue_barrel2_outline.png")
local imageBarrel2 = love.graphics.newImage("images/tankBlue_barrel2.png")
local sndTankShoot = love.audio.newSource("images/fire.wav", "static")

-- Function to initialize the hero's position and properties
function hero.Init(x, y)
    positionX = x
    positionY = y
    angle = 0
    rotationSpeed = 2
    moveSpeed = 100
    nbrLifeHero = 5
end

-- Function to save the highest score
function hero.SaveHighestScore(score)
    love.filesystem.write("highest_score.txt", tostring(score))
end

-- Function to retrieve the highest score
function hero.GetHighestScore()
    if love.filesystem.getInfo("highest_score.txt") then
        local score = love.filesystem.read("highest_score.txt")
        return tonumber(score)
    else
        return 0 -- Return 0 if the highest score file doesn't exist or an error occurs while reading
    end
end

-- Function to update the hero's position and behavior
function hero.Update(dt)
    -- Handle hero's movement and rotation based on input
    local oldPositionX = positionX
    local oldPositionY = positionY
    angleBarrel = math.atan2(love.mouse.getY() - positionY, love.mouse.getX() - positionX)

    if love.keyboard.isDown("left") then
        angle = angle - rotationSpeed * dt
    elseif love.keyboard.isDown("right") then
        angle = angle + rotationSpeed * dt
    end

    local vx = math.cos(angle) * moveSpeed
    local vy = math.sin(angle) * moveSpeed
    if love.keyboard.isDown("up") then
        positionX = positionX + vx * dt
        positionY = positionY + vy * dt
    elseif love.keyboard.isDown("down") then
        positionX = positionX - vx * dt
        positionY = positionY - vy * dt
    end

    -- Check collision with obstacles in the map
    if map.CheckCollisionObstacle(positionX, positionY, radius) then
        positionX = oldPositionX
        positionY = oldPositionY
    end
end

-- Function to shoot (create bullet)
function hero.Shoot()
    bulletManager.NewBullet(positionX, positionY, angleBarrel, shootSpeed, owner)
    love.audio.play(sndTankShoot)
end

-- Function to reduce the life of the hero if he gets shot
function hero.HeroGotShot()
    nbrLifeHero = nbrLifeHero - 1
end

function hero.GetPosition()
    return positionX, positionY
end

function hero.GetSize()
    return radius
end

function hero.GetNbrLife()
    return nbrLifeHero
end

-- Function to draw the hero on the screen
function hero.Draw()
    love.graphics.draw(imageBody, positionX, positionY, angle, 1, 1, imageBody:getWidth() * 0.5,
        imageBody:getHeight() * 0.5)

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

return hero

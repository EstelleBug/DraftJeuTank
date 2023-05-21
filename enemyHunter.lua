require("utils")
local map = require "map"

-- Load enemy images and sound effects
local imageBody = love.graphics.newImage("images/tankBody_sand_outline.png")
local imageBarrel1 = love.graphics.newImage("images/tankSand_barrel2_outline.png")
local imageBarrel2 = love.graphics.newImage("images/tankSand_barrel2.png")
local sndTankShoot = love.audio.newSource("images/fire.wav", "static")

-- Function to create a new enemy hunter object
function NewEnemyHunter(x, y, angle, speed)
    local enemy = {}

    -- Enemy properties
    enemy.x = x
    enemy.y = y
    enemy.angle = angle
    enemy.angleBarrel = angle
    enemy.radius = 25
    enemy.moveSpeed = speed
    enemy.rotationSpeed = 2
    enemy.shootSpeed = 200
    enemy.shootRange = 180
    enemy.chaseRange = 250
    enemy.state = "patrol"
    enemy.shootTimer = 0
    enemy.shootRate = 1
    enemy.owner = "hunter"
    enemy.nbrLife = 1
    enemy.free = false
    enemy.points = 75

    -- Function to handle enemy patrol behavior
    function enemy.Patrol(dt, hero)
        enemy.Move(dt)

        -- Check for collision with obstacles on the map
        if map.CheckCollisionObstacle(enemy.x, enemy.y, enemy.radius) then
            enemy.angle = enemy.angle - math.pi
            enemy.angleBarrel = enemy.angleBarrel - math.pi
            enemy.x = enemy.oldX
            enemy.y = enemy.oldY
        end

        -- Calculate distance to the hero
        local targetDist = math.dist(enemy.x, enemy.y, hero.GetPosition())

        -- Transition to "chase" state if the hero is within chasing range
        if targetDist <= enemy.chaseRange then
            enemy.state = "chase"
        end
    end

    -- Function to handle enemy chase behavior
    function enemy.Chase(dt, hero)
        local targetX, targetY = hero.GetPosition()
        local targetDist = math.dist(enemy.x, enemy.y, targetX, targetY)

        -- Follow target
        enemy.angleBarrel = math.atan2(targetY - enemy.y, targetX - enemy.x)
        enemy.angle = math.atan2(targetY - enemy.y, targetX - enemy.x)
        enemy.Move(dt)

        -- Check for collision with obstacles on the map
        if map.CheckCollisionObstacle(enemy.x, enemy.y, enemy.radius) then
            enemy.state = "patrol"
            enemy.angleBarrel = enemy.angle
            enemy.angle = enemy.angle - math.pi
            enemy.angleBarrel = enemy.angleBarrel - math.pi
            enemy.x = enemy.oldX
            enemy.y = enemy.oldY
        end

        -- Transition to "shoot" state if the hero is within shooting range
        if targetDist <= enemy.shootRange then
            enemy.state = "shoot"

            -- Transition to "patrol" state if the hero moves out of chasing range
        elseif targetDist >= enemy.chaseRange then
            enemy.state = "patrol"
            enemy.angleBarrel = enemy.angle
        end
    end

    -- Function to handle enemy shoot behavior
    function enemy.Shoot(dt, hero, bulletManager)
        local targetX, targetY = hero.GetPosition()
        enemy.angleBarrel = math.atan2(targetY - enemy.y, targetX - enemy.x)

        -- Shoot bullets at a regular interval
        enemy.shootTimer = enemy.shootTimer - dt
        if enemy.shootTimer <= 0 then
            enemy.shootTimer = enemy.shootRate
            bulletManager.NewBullet(enemy.x, enemy.y, enemy.angleBarrel, enemy.shootSpeed, enemy.owner)
            love.audio.play(sndTankShoot)
        end

        -- Transition to "chase" state if the hero moves out of shooting range
        local targetDist = math.dist(enemy.x, enemy.y, hero.GetPosition())
        if targetDist >= enemy.shootRange then
            enemy.state = "chase"
        end
    end

    -- Function to move the enemy
    function enemy.Move(dt)
        enemy.oldX = enemy.x
        enemy.oldY = enemy.y
        local vx = math.cos(enemy.angle) * enemy.moveSpeed
        local vy = math.sin(enemy.angle) * enemy.moveSpeed
        enemy.x = enemy.x + vx * dt
        enemy.y = enemy.y + vy * dt
    end

    -- Function to update the enemy
    function enemy.Update(dt, hero, bulletManager)
        if enemy.state == "patrol" then
            enemy.Patrol(dt, hero)
        elseif enemy.state == "chase" then
            enemy.Chase(dt, hero)
        elseif enemy.state == "shoot" then
            enemy.Shoot(dt, hero, bulletManager)
        end
        if enemy.nbrLife == 0 then
            enemy.free = true
        end
    end

    -- Function to draw the enemy
    function enemy.Draw()
        love.graphics.draw(imageBody, enemy.x, enemy.y, enemy.angle, 1, 1, imageBody:getWidth() * 0.5,
            imageBody:getHeight() * 0.5)
        love.graphics.draw(imageBarrel1, enemy.x, enemy.y, enemy.angleBarrel, 1, 1, imageBarrel1:getWidth() * 0.2,
            imageBarrel1:getHeight() * 0.5)
        love.graphics.draw(imageBarrel2, enemy.x, enemy.y, enemy.angleBarrel, 1, 1, imageBarrel2:getWidth() * 0.2,
            imageBarrel2:getHeight() * 0.5)
    end

    return enemy
end

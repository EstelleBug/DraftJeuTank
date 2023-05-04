require("utils")
local hero = require("hero")
local bulletManager = require("bulletManager")

local imageBody = love.graphics.newImage("images/tankBody_red_outline.png")
local imageBarrel1 = love.graphics.newImage("images/tankRed_barrel2_outline.png")
local imageBarrel2 = love.graphics.newImage("images/tankRed_barrel2.png")
--local imageEnemyWidth = imageBody:getWidth()
--local imageEnemyHeight = imageBody:getHeight()

function NewEnemy(x, y)
    local enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.angle = 0
    enemy.angleBarrel = 0
    enemy.radius = 30
    enemy.moveSpeed = 50
    enemy.rotationSpeed = 2
    enemy.shootSpeed = 200
    enemy.shootRange = 200
    enemy.chaseRange = 250
    enemy.state = "patrol"
    enemy.turnTimer = 3
    enemy.shootTimer = 0
    enemy.shootRate = .5
    enemy.owner = "enemy"

    function enemy.Patrol(dt)
        enemy.turnTimer = enemy.turnTimer - dt
        if math.floor(enemy.turnTimer) == 0 then
            enemy.angle = enemy.angle - math.pi
            enemy.angleBarrel = enemy.angleBarrel - math.pi
            enemy.turnTimer = 3
        end
        enemy.Move(dt)

        local targetDist = math.dist(enemy.x, enemy.y, hero.GetPosition())

        if targetDist <= enemy.chaseRange then
            enemy.state = "shoot"
        end
    end

    function enemy.Shoot(dt)
        local targetX, targetY = hero.GetPosition()
        enemy.angleBarrel = math.atan2(targetY - enemy.y, targetX - enemy.x)

        enemy.shootTimer = enemy.shootTimer - dt
        if enemy.shootTimer <= 0 then
            enemy.shootTimer = enemy.shootRate
            bulletManager.NewBullet(enemy.x, enemy.y, enemy.angleBarrel, enemy.shootSpeed, enemy.owner)
        end

        local targetDist = math.dist(enemy.x, enemy.y, hero.GetPosition())
        if targetDist >= enemy.shootRange + 50 then
            enemy.state = "patrol"
            enemy.angleBarrel = enemy.angle
        end
    end

    function enemy.Move(dt)
        local vx = math.cos(enemy.angle) * enemy.moveSpeed
        local vy = math.sin(enemy.angle) * enemy.moveSpeed
        enemy.x = enemy.x + vx * dt
        enemy.y = enemy.y + vy * dt
    end

    function enemy.Update(dt)
        if enemy.state == "patrol" then
            enemy.Patrol(dt)
        elseif enemy.state == "shoot" then
            enemy.Shoot(dt)
        end
    end

    function enemy.Draw()
        love.graphics.draw(imageBody, enemy.x, enemy.y, enemy.angle, 1, 1, imageBody:getWidth() * 0.5,
            imageBody:getHeight() * 0.5)
        love.graphics.draw(imageBarrel1, enemy.x, enemy.y, enemy.angleBarrel, 1, 1, imageBarrel1:getWidth() * 0.2,
            imageBarrel1:getHeight() * 0.5)
        love.graphics.draw(imageBarrel2, enemy.x, enemy.y, enemy.angleBarrel, 1, 1, imageBarrel2:getWidth() * 0.2,
            imageBarrel2:getHeight() * 0.5)

        love.graphics.circle("line", enemy.x, enemy.y, enemy.radius)
    end

    return enemy
end

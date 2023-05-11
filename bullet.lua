local map = require("map")
function NewBullet(x, y, angle, speed, owner)
    local bullet = {}
    bullet.x = x
    bullet.y = y
    bullet.angle = angle
    bullet.speedX = speed
    bullet.speedY = speed
    bullet.owner = owner
    bullet.free = false
    bullet.radius = 5
    bullet.collisionCount = 0
    --bullet.imageHero = love.graphics.newImage("images/bulletBlue.png")
    --bullet.imageEnemy = love.graphics.newImage("images/bulletRed.png")
    --bullet.width = bullet.imageHero:getWidth()
    --bullet.height = bullet.imageHero:getHeight()

    function bullet.Update(dt)
        bullet.x = bullet.x + math.cos(bullet.angle) * bullet.speedX * dt
        bullet.y = bullet.y + math.sin(bullet.angle) * bullet.speedY * dt
        --bullet.oldX = bullet.x
        --bullet.oldY = bullet.y

        if map.CheckCollisionObstacleWithBullet(bullet.x, bullet.y, bullet.radius, bullet.speedX, bullet.speedY) then
            bullet.collisionCount = bullet.collisionCount + 1
            print(bullet.collisionCount)
            --bullet.x = bullet.oldX
            --bullet.y = bullet.oldy
            bullet.speedX = map.bounceX
            bullet.speedY = map.bounceY
        end

        local TILE_WIDTH, TILE_HEIGHT = map.GetTileSize()

        if bullet.x < TILE_WIDTH then
            bullet.collisionCount = bullet.collisionCount + 1
            bullet.speedX = bullet.speedX * -1
            print(bullet.collisionCount)
        end
        if bullet.y < TILE_HEIGHT then
            bullet.collisionCount = bullet.collisionCount + 1
            bullet.speedY = bullet.speedY * -1
            print(bullet.collisionCount)
        end
        if bullet.x > love.graphics.getWidth() - bullet.radius - TILE_WIDTH then
            bullet.collisionCount = bullet.collisionCount + 1
            bullet.speedX = bullet.speedX * -1
            print(bullet.collisionCount)
        end
        if bullet.y > love.graphics.getHeight() - bullet.radius - TILE_HEIGHT then
            bullet.collisionCount = bullet.collisionCount + 1
            bullet.speedY = bullet.speedY * -1
            print(bullet.collisionCount)
        end
        if bullet.collisionCount == 3 then
            bullet.free = true
        end
    end

    function bullet.Draw()
        if owner == ("hero") then
            love.graphics.setColor(0, 0, 255)
            love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
            --love.graphics.draw(bullet.imageHero, bullet.x, bullet.y, bullet.angle, 1, 1,
            --bullet.imageHero:getWidth() * 0.5,
            --bullet.imageHero:getHeight() * 0.5)
        elseif owner == ("enemy") then
            love.graphics.setColor(255, 0, 0)
            love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
            --love.graphics.draw(bullet.imageEnemy, bullet.x, bullet.y, bullet.angle, 1, 1,
            --bullet.imageEnemy:getWidth() * 0.5,
            --bullet.imageEnemy:getHeight() * 0.5)
        end
        love.graphics.setColor(255, 255, 255)
    end

    return bullet
end

local map = require("map")

-- Function to create a new bullet object
function NewBullet(x, y, angle, speed, owner)
    local bullet = {}
    bullet.x = x
    bullet.y = y
    bullet.angle = angle

    bullet.speedX = math.cos(angle) * speed
    bullet.speedY = math.sin(angle) * speed

    bullet.owner = owner
    bullet.free = false
    bullet.radius = 5
    bullet.collisionCount = 0
    --bullet.imageHero = love.graphics.newImage("images/bulletBlue.png")
    --bullet.imageEnemy = love.graphics.newImage("images/bulletRed.png")
    --bullet.width = bullet.imageHero:getWidth()
    --bullet.height = bullet.imageHero:getHeight()

    -- Function to handle obstacle collision for the bullet
    function bullet.ObstacleCollision(obstacle)
        local dx = bullet.x - obstacle.x
        local dy = bullet.y - obstacle.y
        local distance = math.sqrt(dx ^ 2 + dy ^ 2)
        local totalRadius = bullet.radius + obstacle.radius

        if distance <= totalRadius then
            bullet.collisionCount = bullet.collisionCount + 1

            -- Calculate the collision normal
            local normalX = dx / distance
            local normalY = dy / distance

            -- Calculate the penetration between the bullet and the obstacle
            local penetration = totalRadius - distance

            -- Réduire la pénétration pour éviter que la balle ne reste coincée à l'intérieur de l'obstacle
            bullet.x = bullet.x + penetration * normalX
            bullet.y = bullet.y + penetration * normalY

            -- Calculate the dot product between the bullet's velocity and the collision normal
            local dotProduct = bullet.speedX * normalX + bullet.speedY * normalY

            -- Calculate the component of velocity parallel to the collision normal
            local parallelX = dotProduct * normalX
            local parallelY = dotProduct * normalY

            -- Calculate the component of velocity perpendicular to the collision normal
            local perpendicularX = bullet.speedX - parallelX
            local perpendicularY = bullet.speedY - parallelY

            -- Reverse the direction of the parallel velocity to simulate bouncing
            parallelX = -parallelX
            parallelY = -parallelY

            -- Update the bullet's velocity
            bullet.speedX = parallelX + perpendicularX
            bullet.speedY = parallelY + perpendicularY
        end
    end

    -- Update function to move the bullet and check for collisions
    function bullet.Update(dt)
        bullet.x = bullet.x + bullet.speedX * dt
        bullet.y = bullet.y + bullet.speedY * dt

        -- Check for obstacle collisions
        for _, o in ipairs(map.GetObsacles()) do
            bullet.ObstacleCollision(o)
        end

        -- Check for collisions with the boundaries of the screen and the wall
        local TILE_WIDTH, TILE_HEIGHT = map.GetTileSize()

        if bullet.x < TILE_WIDTH or bullet.x > love.graphics.getWidth() - bullet.radius - TILE_WIDTH then
            bullet.collisionCount = bullet.collisionCount + 1
            bullet.speedX = bullet.speedX * -1
        end
        if bullet.y < TILE_HEIGHT or bullet.y > love.graphics.getHeight() - bullet.radius - TILE_HEIGHT then
            bullet.collisionCount = bullet.collisionCount + 1
            bullet.speedY = bullet.speedY * -1
        end

        -- Mark the bullet as free if it exceeds the collision count limit
        if bullet.collisionCount >= 3 then
            bullet.free = true
        end
    end

    -- Function to draw the bullet, different color depending of the owner
    function bullet.Draw()
        if owner == ("hero") then
            love.graphics.setColor(0, 0, 255)
            love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
            --love.graphics.draw(bullet.imageHero, bullet.x, bullet.y, bullet.angle, 1, 1,
            --bullet.imageHero:getWidth() * 0.5,
            --bullet.imageHero:getHeight() * 0.5)
        elseif owner == ("normal") then
            love.graphics.setColor(255, 0, 0)
            love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
            --love.graphics.draw(bullet.imageEnemy, bullet.x, bullet.y, bullet.angle, 1, 1,
            --bullet.imageEnemy:getWidth() * 0.5,
            --bullet.imageEnemy:getHeight() * 0.5)
        elseif owner == ("static") then
            love.graphics.setColor(0, 0, 0)
            love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
        elseif owner == ("hunter") then
            love.graphics.setColor(245, 205, 152)
            love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
        end
        love.graphics.setColor(255, 255, 255)
    end

    return bullet
end

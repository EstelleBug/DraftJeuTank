require("bullet")
require("utils")
local enemyManager   = require("enemyManager")

-- Create the bullet manager object
local bulletManager  = {}
-- List to store all bullets
local bullets        = {}

-- Sound effects
local sndTankExplode = love.audio.newSource("images/tankexplode.wav", "static")

-- Function to create a new bullet and add it to the bullets list
function bulletManager.NewBullet(x, y, angle, speed, owner)
    local newBullet = NewBullet(x, y, angle, speed, owner)
    table.insert(bullets, newBullet)
end

-- Function to check collision between two bullets
function bulletManager.checkCollision(bullet1, bullet2)
    if bullet1 == bullet2 then
        return false
    end
    local distance = math.dist(bullet1.x, bullet1.y, bullet2.x, bullet2.y)
    return distance < bullet1.radius + bullet2.radius
end

-- Function to reset the bullets list
function bulletManager.ResetBullets()
    bullets = {}
end

-- Function to update the bullets
function bulletManager.Update(dt, hero, sceneGame)
    local enemies = enemyManager.GetEnemiesInfo()
    local bulletsToRemove = {}

    -- Iterate over each bullet in reverse order
    for i = #bullets, 1, -1 do
        local _bullet = bullets[i]
        _bullet.Update(dt)

        local bulletRemoved = false

        -- Check collision with other bullets
        for j = i + 1, #bullets do
            local _bullet2 = bullets[j]
            if enemyManager.checkCollision(_bullet, _bullet2) then
                _bullet.free = true
                _bullet2.free = true
                bulletRemoved = true
                break
            end
        end

        for k = #enemies, 1, -1 do
            local _enemy = enemies[k]

            if _bullet.free then
                bulletRemoved = true
                break
            end

            if _bullet.owner == "normal" or _bullet.owner == "static" or _bullet.owner == "hunter" then
                local radius = hero.GetSize()
                local distance = math.dist(_bullet.x, _bullet.y, hero.GetPosition())
                if distance < _bullet.radius + radius then
                    hero.HeroGotShot()
                    _bullet.free = true
                    bulletRemoved = true
                    break
                end
            elseif _bullet.owner == "hero" then
                local distance = math.dist(_bullet.x, _bullet.y, _enemy.x, _enemy.y)
                if distance < _bullet.radius + _enemy.radius then
                    love.audio.play(sndTankExplode)
                    _enemy.nbrLife = _enemy.nbrLife - 1
                    _bullet.free = true
                    bulletRemoved = true
                    sceneGame.AddPoints(_enemy.points)
                    break
                end
            end
        end
        -- Add bullet to remove list if it is flagged as free or collided with an enemy
        if bulletRemoved then
            table.insert(bulletsToRemove, i)
        end
    end
    -- Remove bullets from the list
    for i = #bulletsToRemove, 1, -1 do
        table.remove(bullets, bulletsToRemove[i])
    end
end

-- Function to draw all bullets
function bulletManager.Draw()
    for _, bullet in ipairs(bullets) do
        bullet.Draw()
    end
end

function bulletManager.BulletsAmount()
    return #bullets
end

return bulletManager

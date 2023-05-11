require("bullet")
require("utils")
local enemyManager = require("enemyManager")
local bulletManager = {}
local bullets = {}

function bulletManager.NewBullet(x, y, angle, speed, owner)
    local newBullet = NewBullet(x, y, angle, speed, owner)
    table.insert(bullets, newBullet)
end

function bulletManager.checkCollision(bullet1, bullet2)
    local distance = math.dist(bullet1.x, bullet1.y, bullet2.x, bullet2.y)
    return distance < bullet1.radius + bullet2.radius
end

function bulletManager.Update(dt, hero)
    local enemies = enemyManager.GetEnemiesInfo()
    local bulletsToRemove = {}

    for i = #bullets, 1, -1 do
        local _bullet = bullets[i]
        _bullet.Update(dt)

        local bulletRemoved = false

        for j = i + 1, #bullets do
            local _bullet1 = bullets[i]
            local _bullet2 = bullets[j]
            if enemyManager.checkCollision(_bullet1, _bullet2) then
                _bullet1.free = true
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

            if _bullet.owner == "enemy" then
                local radius = hero.GetSize()
                local distance = math.dist(_bullet.x, _bullet.y, hero.GetPosition())
                if distance < _bullet.radius + radius then
                    print("Hero got Shot")
                    hero.HeroGotShot()
                    _bullet.free = true
                    bulletRemoved = true
                    break
                end
            elseif _bullet.owner == "hero" then
                local distance = math.dist(_bullet.x, _bullet.y, _enemy.x, _enemy.y)
                if distance < _bullet.radius + _enemy.radius then
                    print("Enemy got Shot")
                    _enemy.nbrLife = _enemy.nbrLife - 1
                    _bullet.free = true
                    bulletRemoved = true
                    break
                end
            end
        end
        if bulletRemoved then
            table.insert(bulletsToRemove, i)
        end
    end
    for i = #bulletsToRemove, 1, -1 do
        table.remove(bullets, bulletsToRemove[i])
    end
end

function bulletManager.Draw()
    for _, bullet in ipairs(bullets) do
        bullet.Draw()
    end
end

function bulletManager.BulletsAmount()
    return #bullets
end

return bulletManager

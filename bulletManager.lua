require("bullet")
require("utils")
local life = require("life")
local bulletManager = {}
local bullets = {}

function bulletManager.NewBullet(x, y, angle, speed, owner)
    local newBullet = NewBullet(x, y, angle, speed, owner)
    table.insert(bullets, newBullet)
end

function bulletManager.Update(dt, hero, enemy)
    for _, bullet in ipairs(bullets) do
        bullet.Update(dt)
    end

    for i = #bullets, 1, -1 do
        local _bullet = bullets[i]
        if _bullet.free then
            table.remove(bullets, i)
        end

        if _bullet.owner == "enemy" then
            local radius = hero.GetSize()
            local distance = math.dist(_bullet.x, _bullet.y, hero.GetPosition())
            if distance < _bullet.radius + radius then
                print("Hero got Shot")
                life.HeroGotShot()
                table.remove(bullets, i)
            end
        elseif _bullet.owner == "hero" then
            local distance = math.dist(_bullet.x, _bullet.y, enemy.x, enemy.y)
            if distance < _bullet.radius + enemy.radius then
                print("Enemy got Shot")
                life.EnemyGotShot()
                table.remove(bullets, i)
            end
        end
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

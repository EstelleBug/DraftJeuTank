require("enemy")
require("utils")

local enemyManager = {}
local enemies = {}

function enemyManager.NewEnemy(x, y, angle, speed)
    local NewEnemy = NewEnemy(x, y, angle, speed)
    table.insert(enemies, NewEnemy)
end

function enemyManager.checkCollision(enemy1, enemy2)
    local distance = math.dist(enemy1.x, enemy1.y, enemy2.x, enemy2.y)
    return distance < enemy1.radius + enemy2.radius
end

function enemyManager.Update(dt, hero, bulletManager)
    for _, enemy in ipairs(enemies) do
        enemy.Update(dt, hero, bulletManager)
    end
    for i = #enemies, 1, -1 do
        local _enemy = enemies[i]
        if _enemy.free then
            table.remove(enemies, i)
        end

        for j = i + 1, #enemies do
            local _enemy1 = enemies[i]
            local _enemy2 = enemies[j]
            if enemyManager.checkCollision(_enemy1, _enemy2) then
                _enemy1.angle = _enemy1.angle - math.pi
                _enemy1.angleBarrel = _enemy1.angleBarrel - math.pi
                _enemy1.x = _enemy1.oldX
                _enemy1.y = _enemy1.oldY

                _enemy2.angle = _enemy2.angle - math.pi
                _enemy2.angleBarrel = _enemy2.angleBarrel - math.pi
                _enemy2.x = _enemy2.oldX
                _enemy2.y = _enemy2.oldY
            end
        end
    end
end

function enemyManager.Draw()
    for _, enemy in ipairs(enemies) do
        enemy.Draw()
    end
end

function enemyManager.EnemiesAmount()
    return #enemies
end

function enemyManager.GetEnemiesInfo()
    return enemies
end

return enemyManager

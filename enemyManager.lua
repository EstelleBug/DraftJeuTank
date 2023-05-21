require("enemy")
require("enemyStatic")
require("enemyHunter")
require("utils")

-- Create the enemy manager object
local enemyManager = {}
-- List to store enemy objects
local enemies = {}

-- Function to create and add a new enemy to the list
function enemyManager.NewEnemy(x, y, angle, speed)
    local NewEnemy = NewEnemy(x, y, angle, speed)
    table.insert(enemies, NewEnemy)
end

-- Function to create and add a new static enemy to the list
function enemyManager.NewEnemyStatic(x, y, angle, speed)
    local NewEnemy = NewEnemyStatic(x, y, angle, speed)
    table.insert(enemies, NewEnemy)
end

-- Function to create and add a new hunter enemy to the list
function enemyManager.NewEnemyHunter(x, y, angle, speed)
    local NewEnemy = NewEnemyHunter(x, y, angle, speed)
    table.insert(enemies, NewEnemy)
end

-- Function to check collision between two enemies
function enemyManager.checkCollision(enemy1, enemy2)
    local distance = math.dist(enemy1.x, enemy1.y, enemy2.x, enemy2.y)
    return distance < enemy1.radius + enemy2.radius
end

-- Function to reset the list of enemies
function enemyManager.ResetEnemies()
    enemies = {}
end

-- Function to update all enemies
function enemyManager.Update(dt, hero, bulletManager)
    for _, enemy in ipairs(enemies) do
        enemy.Update(dt, hero, bulletManager)
    end

    -- Check collision and handle enemy interactions
    for i = #enemies, 1, -1 do
        local _enemy1 = enemies[i]
        if _enemy1.free then
            table.remove(enemies, i)
        else
            for j = i + 1, #enemies do
                local _enemy2 = enemies[j]
                -- Handle collision between enemies by reversing their positions and angles
                if enemyManager.checkCollision(_enemy1, _enemy2) then
                    if _enemy1.state ~= "shoot" and _enemy1.state ~= "static" then
                        _enemy1.angle = _enemy1.angle - math.pi
                        _enemy1.angleBarrel = _enemy1.angleBarrel - math.pi
                        _enemy1.x = _enemy1.oldX
                        _enemy1.y = _enemy1.oldY
                    end

                    if _enemy2.state ~= "shoot" and _enemy2.state ~= "static" then
                        _enemy2.angle = _enemy2.angle - math.pi
                        _enemy2.angleBarrel = _enemy2.angleBarrel - math.pi
                        _enemy2.x = _enemy2.oldX
                        _enemy2.y = _enemy2.oldY
                    end
                end
            end
        end
    end
end

-- Function to draw all enemies
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

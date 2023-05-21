local sceneManager = require("sceneManager")
local hero = require("hero")
local enemyManager = require("enemyManager")
local bulletManager = require("bulletManager")
local life = require("life")
local map = require("map")
local sceneGame = {}

-- Points properties
local points = 0
local pointsX = 50
local pointsY = 650
local highestScore = 0

-- Level properties
local currentLevel = 1
local totalEnemiesPerLevel = 3

local levelConfigurations = {
    [1] = {
        enemySpeed = 50,
        enemies = {
            { type = "static", amount = 3 }
        }
    },
    [2] = {
        enemySpeed = 50,
        enemies = {
            { type = "static", amount = 2 },
            { type = "normal", amount = 1 }
        }
    },
    [3] = {
        enemySpeed = 50,
        enemies = {
            { type = "normal", amount = 2 },
            { type = "hunter", amount = 1 }
        }
    }
}

function sceneGame.Load()
    love.window.setMode(700, 700)

    -- Read the highest score from a file or set it to 0 if not available and convert it to a number
    highestScore = love.filesystem.read("highest_score.txt") or "0"
    highestScore = tonumber(highestScore)

    map.Load()

    bulletManager.ResetBullets()

    local heroX = 100
    local heroY = 100
    hero.Init(heroX, heroY)

    enemyManager.ResetEnemies()

    -- Get the configuration for the current level
    local levelConfig = levelConfigurations[currentLevel]
    local enemySpeed = levelConfig.enemySpeed
    local enemiesConfig = levelConfig.enemies

    -- Variable to track the number of generated enemies
    local generatedEnemies = 0
    -- Get the type of enemy and the amount
    for _, enemyConfig in ipairs(enemiesConfig) do
        local enemyType = enemyConfig.type
        local enemyAmount = enemyConfig.amount

        -- For each enemy generate a random position and angle
        for _ = 1, enemyAmount do
            while generatedEnemies < totalEnemiesPerLevel do
                local enemyXTile = love.math.random(4, 9)
                local enemyYTile = love.math.random(4, 9)
                local angles = { 0, math.pi * 3 / 2, math.pi / 2, math.pi }
                local enemyAngle = angles[love.math.random(#angles)]

                -- Check if enemy spawn on a forbidden position or on a another enemy
                if map.forbiddenPosition(enemyXTile, enemyYTile) == false and sceneGame.CheckCollisionWithOtherEnemies(enemyXTile, enemyYTile) == false then
                    local TILE_WIDTH, TILE_HEIGHT = map.GetTileSize()
                    local enemyX, enemyY = enemyXTile * TILE_WIDTH - (TILE_WIDTH / 2),
                        enemyYTile * TILE_HEIGHT - (TILE_HEIGHT / 2)

                    -- If position allowed then create enemy depending of his type
                    if enemyType == "normal" then
                        enemyManager.NewEnemy(enemyX, enemyY, enemyAngle, enemySpeed)
                    elseif enemyType == "static" then
                        enemyManager.NewEnemyStatic(enemyX, enemyY, enemyAngle, enemySpeed)
                    elseif enemyType == "hunter" then
                        enemyManager.NewEnemyHunter(enemyX, enemyY, enemyAngle, enemySpeed)
                    end
                    generatedEnemies = generatedEnemies + 1
                    break
                end
            end
        end
    end
end

-- Check if enemy spawn on enemy
function sceneGame.CheckCollisionWithOtherEnemies(xTile, yTile)
    local enemiesInfo = enemyManager.GetEnemiesInfo()
    local TILE_WIDTH, TILE_HEIGHT = map.GetTileSize()
    for _, enemyInfo in ipairs(enemiesInfo) do
        local enemyXTile = math.floor(enemyInfo.x / TILE_WIDTH) + 1
        local enemyYTile = math.floor(enemyInfo.y / TILE_HEIGHT) + 1
        if enemyXTile == xTile and enemyYTile == yTile then
            return true
        end
    end
    return false
end

-- Add points to score depending of the enemy points
function sceneGame.AddPoints(enemyPoints)
    points = points + enemyPoints
end

function sceneGame.Update(dt)
    hero.Update(dt)
    enemyManager.Update(dt, hero, bulletManager)
    bulletManager.Update(dt, hero, sceneGame)
    life.Update(dt)

    local nbrLifeHero = hero.GetNbrLife()
    local nbrEnemy = enemyManager.EnemiesAmount()

    -- If hero dead reset current level and points. Load the scene Game Over
    if nbrLifeHero == 0 then
        -- Update highest score if it's above the previous one
        local highestScore = love.filesystem.read("highest_score.txt") or "0"
        highestScore = tonumber(highestScore)
        if points > highestScore then
            hero.SaveHighestScore(points)
        end
        currentLevel = 1
        points = 0
        sceneManager.LoadScene("gameOver")
        -- If enemies' level dead move to level above or win
    elseif nbrEnemy == 0 then
        local highestScore = love.filesystem.read("highest_score.txt") or "0"
        highestScore = tonumber(highestScore)
        if points > highestScore then
            hero.SaveHighestScore(points)
        end
        -- Set game to 3 levels and move to level above
        if currentLevel < 3 then
            currentLevel = currentLevel + 1
            levelText = "Level " .. currentLevel
            sceneManager.LoadScene("game")
        else
            sceneManager.LoadScene("end")
        end
    end
end

function sceneGame.Draw()
    map.Draw()
    bulletManager.Draw()
    hero.Draw()
    enemyManager.Draw()

    local lifeX = 5
    local lifeY = 5
    life.Draw(lifeX, lifeY, hero)

    local levelText = "Level " .. currentLevel
    love.graphics.print(levelText, 600, 650)
    local pointsText = "Points: " .. points
    love.graphics.print(pointsText, pointsX, pointsY)
end

function sceneGame.Keypressed(key)

end

function sceneGame.Mousepressed(x, y, button)
    -- If the left mouse button is pressed, the hero shoots
    if button == 1 then
        hero.Shoot()
    end
end

return sceneGame

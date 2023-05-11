local hero = require("hero")
local enemyManager = require("enemyManager")
local bulletManager = require("bulletManager")
local life = require("life")
local sceneManager = require("sceneManager")
local map = require("map")
local sceneGame = {}

function sceneGame.Load()
    love.window.setMode(700, 700)

    map.Load()

    local heroX = 100
    local heroY = 100
    hero.Init(heroX, heroY)

    local numEnemies = 3
    local generatedEnemies = 0

    while generatedEnemies < numEnemies do
        local enemyXTile = love.math.random(4, 9)
        local enemyYTile = love.math.random(4, 9)
        local angles = { 0, math.pi * 3 / 2, math.pi / 2, math.pi }
        local enemyAngle = angles[love.math.random(#angles)]
        local enemySpeed = 50
        print("Tile", enemyXTile, enemyYTile)
        print(map.forbiddenPosition(enemyXTile, enemyYTile))
        if map.forbiddenPosition(enemyXTile, enemyYTile) == false then
            local TILE_WIDTH, TILE_HEIGHT = map.GetTileSize()
            local enemyX, enemyY = enemyXTile * TILE_WIDTH - (TILE_WIDTH / 2),
                enemyYTile * TILE_HEIGHT - (TILE_HEIGHT / 2)
            print("Pixel", enemyX, enemyY)
            enemyManager.NewEnemy(enemyX, enemyY, enemyAngle, enemySpeed)
            generatedEnemies = generatedEnemies + 1
        end
    end
end

function sceneGame.Update(dt)
    hero.Update(dt)
    enemyManager.Update(dt, hero, bulletManager)
    bulletManager.Update(dt, hero)
    life.Update(dt)

    local nbrLifeHero = hero.GetNbrLife()
    local nbrEnemy = enemyManager.EnemiesAmount()
    if nbrLifeHero == 0 then
        sceneManager.LoadScene("gameOver")
    elseif nbrEnemy == 0 then
        sceneManager.LoadScene("end")
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
end

function sceneGame.Keypressed(key)

end

function sceneGame.Mousepressed(x, y, button)
    if button == 1 then
        hero.Shoot()
    end
end

return sceneGame

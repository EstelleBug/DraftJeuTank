local hero = require("hero")
require("enemy")
local bulletManager = require("bulletManager")
local life = require("life")
local sceneManager = require("sceneManager")
local map = require("map")
local sceneGame = {}

local enemyX = 400
local enemyY = 200
local enemy = NewEnemy(enemyX, enemyY)

function sceneGame.Load()
    love.window.setMode(700, 700)

    map.Load()

    local heroX = 100
    local heroY = 100
    hero.Init(heroX, heroY)
end

function sceneGame.Update(dt)
    hero.Update(dt)
    enemy.Update(dt)
    bulletManager.Update(dt, hero, enemy)
    life.Update(dt)

    map.CheckCollisionObstacleWithHero(hero)
    map.CheckCollisionObstacleWithEnemy(enemy)

    local nbrLifeHero = life.GetNbrLifeHero()
    local nbrLifeEnemy = life.GetNbrLifeEnemy()
    if nbrLifeHero == 0 then
        sceneManager.LoadScene("gameOver")
    elseif nbrLifeEnemy == 0 then
        sceneManager.LoadScene("end")
    end
end

function sceneGame.Draw()
    map.Draw()
    bulletManager.Draw()
    hero.Draw()
    enemy.Draw()

    local lifeX = 5
    local lifeY = 5
    life.Draw(lifeX, lifeY)
end

function sceneGame.Keypressed(key)

end

function sceneGame.Mousepressed(x, y, button)
    if button == 1 then
        hero.Shoot()
    end
end

return sceneGame

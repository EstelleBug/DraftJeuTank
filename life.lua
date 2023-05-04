local life = {}

local nbrLifeHero = 5
local nbrLifeEnemy = 1
local timerLowLife = 0
local lifeImg = love.graphics.newImage("images/heartpixelart16x16.png")


function life.ShowLife(pX, pY)
    local x = pX
    local y = pY
    local lifeLargeur = lifeImg:getWidth()
    local lifeHauteur = lifeImg:getHeight()
    for n = 1, nbrLifeHero do
        love.graphics.draw(lifeImg, x, y)
        x = x + lifeLargeur + 2
    end
end

function life.Update(dt)
    timerLowLife = timerLowLife + dt * 2
    if timerLowLife > 2 then
        timerLowLife = 0
    end
end

function life.Draw(plX, plY)
    local x = plX
    local y = plY
    local bShow = true
    if nbrLifeHero == 1 then
        if math.floor(timerLowLife) == 0 then
            bShow = false
        end
    end
    if bShow then
        life.ShowLife(x, y)
    end
end

function life.HeroGotShot()
    nbrLifeHero = nbrLifeHero - 1
end

function life.EnemyGotShot()
    nbrLifeEnemy = nbrLifeEnemy - 1
    print("Enemy Dead")
end

function life.GetNbrLifeHero()
    return nbrLifeHero
end

function life.GetNbrLifeEnemy()
    return nbrLifeEnemy
end

return life

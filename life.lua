local life = {}

local timerLowLife = 0
local lifeImg = love.graphics.newImage("images/heartpixelart16x16.png")


function life.ShowLife(pX, pY, hero)
    local x = pX
    local y = pY
    local lifeLargeur = lifeImg:getWidth()
    local nbrLifeHero = hero.GetNbrLife()
    for n = 1, nbrLifeHero do
        love.graphics.draw(lifeImg, x, y)
        x = x + lifeLargeur + 2
    end
end

function life.Update(dt)
    timerLowLife = timerLowLife + dt * 3
    if timerLowLife > 2 then
        timerLowLife = 0
    end
end

function life.Draw(plX, plY, hero)
    local x = plX
    local y = plY
    local bShow = true
    local nbrLifeHero = hero.GetNbrLife()
    if nbrLifeHero == 1 then
        if math.floor(timerLowLife) == 0 then
            bShow = false
        end
    end
    if bShow then
        life.ShowLife(x, y, hero)
    end
end

--function life.HeroGotShot()
--nbrLifeHero = nbrLifeHero - 1
--end

--[[ function life.GetNbrLifeHero()
    return nbrLifeHero
end ]]
return life

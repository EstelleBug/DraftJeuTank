local life = {}

-- Life properties
local timerLowLife = 0
local lifeImg = love.graphics.newImage("images/heartpixelart16x16.png")

-- Function to display the hero's remaining life
function life.ShowLife(pX, pY, hero)
    local x = pX
    local y = pY
    local lifeLargeur = lifeImg:getWidth()
    local nbrLifeHero = hero.GetNbrLife()

    -- Draw the heart icon for each remaining life
    for n = 1, nbrLifeHero do
        love.graphics.draw(lifeImg, x, y)
        x = x + lifeLargeur + 2
    end
end

-- Function to update the life module
function life.Update(dt)
    timerLowLife = timerLowLife + dt * 3

    -- Reset the timer if it exceeds the threshold
    if timerLowLife > 2 then
        timerLowLife = 0
    end
end

-- Function to draw the life module
function life.Draw(plX, plY, hero)
    local x = plX
    local y = plY
    local bShow = true
    local nbrLifeHero = hero.GetNbrLife()

    -- Check if the hero has only one life and control the visibility based on timer
    if nbrLifeHero == 1 then
        if math.floor(timerLowLife) == 0 then
            bShow = false
        end
    end

    -- Show the remaining life if it should be visible
    if bShow then
        life.ShowLife(x, y, hero)
    end
end

return life

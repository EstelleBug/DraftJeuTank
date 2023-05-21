local sceneManager = require("sceneManager")
local hero = require("hero")
local sceneMenu = {}

local font = love.graphics.newFont(24)
local menuOptions = { "New Game", "Quit" }
local positionCursor = 1

function sceneMenu.Draw()
    love.graphics.setFont(font)
    love.graphics.print("Attack on Tank", 50, 50)

    -- Draw menuOptions
    for i, option in ipairs(menuOptions) do
        if i == positionCursor then
            -- Set the color in Yellow for the selected option
            love.graphics.setColor(255, 255, 0)
        else
            -- Set the color in White for others
            love.graphics.setColor(255, 255, 255)
        end
        love.graphics.print(option, 100, 100 + i * 50)
    end
    love.graphics.setColor(255, 255, 255)

    -- Draw highest score
    local highestScore = hero.GetHighestScore()
    local highestScoreX = 50
    local highestScoreY = 500
    love.graphics.print("Highest Score: " .. highestScore, highestScoreX, highestScoreY)
end

function sceneMenu.Keypressed(key)
    if key == "up" then
        -- Move cursor position up
        positionCursor = positionCursor - 1
        if positionCursor < 1 then
            positionCursor = #menuOptions
        end
    elseif key == "down" then
        -- Move cursor position down
        positionCursor = positionCursor + 1
        if positionCursor > #menuOptions then
            positionCursor = 1
        end
    elseif key == "return" then
        if positionCursor == 1 then
            sceneManager.LoadScene("game")
        elseif positionCursor == 2 then
            love.event.quit()
        end
    end
end

return sceneMenu

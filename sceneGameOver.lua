local sceneManager = require("sceneManager")
local sceneGameOver = {}

local font1 = love.graphics.newFont(36)
local font2 = love.graphics.newFont(24)
local textGameOver = "Game Over"

local gameOverOptions = { "Restart", "Quit" }
local positionCursor = 1

function sceneGameOver.Draw()
    love.graphics.setFont(font1)
    local textWidth = font1:getWidth(textGameOver)
    love.graphics.print(textGameOver, love.graphics.getWidth() / 2 - textWidth / 2,
        love.graphics.getHeight() / 2 - font1:getHeight() / 2)

    -- Draw gameOverOptions
    for i, option in ipairs(gameOverOptions) do
        love.graphics.setFont(font2)
        if i == positionCursor then
            -- Set the color in Yellow for the selected option
            love.graphics.setColor(255, 255, 0)
        else
            -- Set the color in White for others
            love.graphics.setColor(255, 255, 255)
        end
        love.graphics.print(option, 100, 400 + i * 50)
    end
    love.graphics.setFont(font2)
    love.graphics.setColor(255, 255, 255)
end

function sceneGameOver.Keypressed(key)
    if key == "up" then
        -- Move cursor position up
        positionCursor = positionCursor - 1
        if positionCursor < 1 then
            positionCursor = #gameOverOptions
        end
    elseif key == "down" then
        -- Move cursor position down
        positionCursor = positionCursor + 1
        if positionCursor > #gameOverOptions then
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

return sceneGameOver

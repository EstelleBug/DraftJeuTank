local sceneManager = require("sceneManager")
local sceneMenu = {}

local font = love.graphics.newFont(24)
local menuOptions = { "New Game", "Quit" }
local positionCursor = 1


function sceneMenu.Draw()
    love.graphics.setFont(font)
    love.graphics.print("Nom du jeu", 50, 50)

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

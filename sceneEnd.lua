local sceneManager = require("sceneManager")
-- Create an empty table to represent the scene
local sceneEnd = {}

-- Create a font object with a size of 36
local font = love.graphics.newFont(36)
-- Define the text to be displayed
local textEnd = "You win!"

-- Load the victory music
--local victoryMusic = love.audio.newSource("", "stream")

function sceneEnd.Draw()
    love.graphics.setFont(font)
    local textWidth = font:getWidth(textEnd)
    love.graphics.print(textEnd, love.graphics.getWidth() / 2 - textWidth / 2,
        love.graphics.getHeight() / 2 - font:getHeight() / 2)
end

-- Quit the game when a key is pressed
function sceneEnd.Keypressed(key)
    love.event.quit()
end

return sceneEnd

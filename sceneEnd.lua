local sceneManager = require("sceneManager")
local sceneEnd = {}

local font = love.graphics.newFont(36)
local textGameOver = "You win!"

-- charger l'image de fond et définir ses coordonnées
--local background = love.graphics.newImage("images/background.png")
--local bgX = 0
--local bgY = 0

-- charger la musique de victoire
--local victoryMusic = love.audio.newSource("", "stream")

function sceneEnd.Draw()
    --love.graphics.draw(background, bgX, bgY)

    love.graphics.setFont(font)
    local textWidth = font:getWidth(textGameOver)
    love.graphics.print(textGameOver, love.graphics.getWidth() / 2 - textWidth / 2,
        love.graphics.getHeight() / 2 - font:getHeight() / 2)
end

function sceneEnd.Keypressed(key)
    love.event.quit()
end

return sceneEnd

local sceneManager = require("sceneManager")

function love.load()
    sceneManager.RegisterScene("game", require("sceneGame"))
    sceneManager.RegisterScene("menu", require("sceneMenu"))
    sceneManager.RegisterScene("gameOver", require("sceneGameOver"))
    sceneManager.RegisterScene("end", require("sceneEnd"))


    sceneManager.LoadScene("menu")
end

function love.update(dt)
    sceneManager.UpdateCurrentScene(dt)
end

function love.draw()
    sceneManager.DrawCurrentScene()
end

function love.keypressed(key)
    sceneManager.Keypressed(key)
end

function love.mousepressed(x, y, button)
    sceneManager.Mousepressed(x, y, button)
end

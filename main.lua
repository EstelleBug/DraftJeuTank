local sceneManager = require("sceneManager")

function love.load()
    -- Register the scenes with the sceneManager
    sceneManager.RegisterScene("game", require("sceneGame"))
    sceneManager.RegisterScene("menu", require("sceneMenu"))
    sceneManager.RegisterScene("gameOver", require("sceneGameOver"))
    sceneManager.RegisterScene("end", require("sceneEnd"))

    -- Load the initial scene (menu)
    sceneManager.LoadScene("menu")
end

function love.update(dt)
    -- Update the current scene managed by sceneManager
    sceneManager.UpdateCurrentScene(dt)
end

function love.draw()
    -- Draw the current scene managed by sceneManager
    sceneManager.DrawCurrentScene()
end

function love.keypressed(key)
    -- Handle the key press event in the current scene
    sceneManager.Keypressed(key)
end

function love.mousepressed(x, y, button)
    -- Handle the mouse press event in the current scene
    sceneManager.Mousepressed(x, y, button)
end

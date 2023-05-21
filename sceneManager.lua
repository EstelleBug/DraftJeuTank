local sceneManager = {}

-- Table to store registered scenes
local scenes = {}
-- Variable to track the current active scene
local currentScene = nil

function sceneManager.RegisterScene(name, scene)
    -- Register a scene with a given name
    scenes[name] = scene
end

function sceneManager.LoadScene(name)
    if scenes[name] ~= nil then
        -- Check if the requested scene exists
        if currentScene ~= nil and currentScene.Exit ~= nil then
            currentScene.Exit() -- Call the Exit function of the previous scene
        end

        currentScene = scenes[name]
        if currentScene.Load ~= nil then
            currentScene.Load()
        end
    end
end

function sceneManager.UpdateCurrentScene(dt)
    if currentScene.Update ~= nil then
        currentScene.Update(dt)
    end
end

function sceneManager.DrawCurrentScene()
    if currentScene.Draw ~= nil then
        currentScene.Draw()
    end
end

function sceneManager.Keypressed(key)
    if currentScene.Keypressed ~= nil then
        currentScene.Keypressed(key)
    end
end

function sceneManager.Mousepressed(x, y, button)
    if currentScene.Mousepressed ~= nil then
        currentScene.Mousepressed(x, y, button)
    end
end

return sceneManager

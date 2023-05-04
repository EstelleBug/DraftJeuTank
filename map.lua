local map = {}

local MAP_WIDTH = 10
local MAP_HEIGHT = 10
local TILE_WIDTH = 70
local TILE_HEIGHT = 70


map.Map = {}
map.Map.Grid = {
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    { 1, 2, 2, 2, 2, 2, 2, 2, 2, 1 },
    { 1, 2, 2, 2, 2, 2, 2, 2, 2, 1 },
    { 1, 3, 2, 2, 2, 2, 2, 2, 2, 1 },
    { 1, 2, 2, 2, 3, 3, 2, 2, 2, 1 },
    { 1, 2, 2, 2, 2, 2, 2, 2, 2, 1 },
    { 1, 2, 2, 2, 2, 2, 2, 2, 2, 1 },
    { 1, 2, 2, 2, 2, 2, 2, 3, 2, 1 },
    { 1, 2, 2, 2, 2, 2, 2, 2, 2, 1 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
}

map.TileTextures = {}
map.TileTypes = {}
map.CollisionHero = false

--local hero = require "hero"

function map.Load()
    map.TileSheet = love.graphics.newImage("images/sheet_tanks.png")

    map.TileTextures[0] = nil
    map.TileTextures[1] = love.graphics.newImage("images/stone.png")
    map.TileTextures[2] = love.graphics.newImage("images/dirt.png")
    map.TileTextures[3] = love.graphics.newImage("images/dirtWithOil.png")

    map.TileTypes[0] = "nil"
    map.TileTypes[1] = "stone"
    map.TileTypes[2] = "dirt"
    map.TileTypes[3] = "obstacle"
end

function map.CheckCollisionObstacleWithHero(hero)
    local c, l
    local positionX, positionY = hero.GetPosition()
    local radius = hero.GetSize()

    for l = 1, MAP_HEIGHT do
        for c = 1, MAP_WIDTH do
            local id = map.Map.Grid[l][c]
            if id == 3 or id == 1 then
                local tileX, tileY = (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT
                if positionX + radius > tileX and positionX < tileX + TILE_WIDTH and positionY + radius > tileY and positionY < tileY + TILE_HEIGHT then
                    --return true
                    print("collision with Hero !")
                    --else
                    --return false
                    map.CollisionHero = true
                end
            end
        end
    end
end

function map.CheckCollisionObstacleWithEnemy(enemy)
    local c, l

    for l = 1, MAP_HEIGHT do
        for c = 1, MAP_WIDTH do
            local id = map.Map.Grid[l][c]
            if id == 3 or id == 1 then
                local tileX, tileY = (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT
                if enemy.x + enemy.radius > tileX and enemy.x < tileX + TILE_WIDTH and enemy.y + enemy.radius > tileY and enemy.y < tileY + TILE_HEIGHT then
                    print("collision with Enemy !")
                end
            end
        end
    end
end

function map.Draw()
    local c, l

    for l = 1, MAP_HEIGHT do
        for c = 1, MAP_WIDTH do
            local id = map.Map.Grid[l][c]
            local tex = map.TileTextures[id]
            if tex ~= nil then
                local tileX, tileY = (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT
                love.graphics.draw(tex, tileX, tileY)
            end
        end
    end

    local x = love.mouse.getX()
    local y = love.mouse.getY()
    local col = math.floor(x / TILE_WIDTH) + 1
    local lig = math.floor(y / TILE_HEIGHT) + 1
    if col > 0 and col <= MAP_WIDTH and lig > 0 and lig <= MAP_HEIGHT then
        local id = map.Map.Grid[lig][col]
        love.graphics.print("Type de tile:" .. tostring(map.TileTypes[id]) .. "(" .. tostring(id) .. ")", 1, 1)
    else
        love.graphics.print("Hors du tableau", 1, 1)
    end
end

return map

require "utils"

local map = {}

local MAP_WIDTH = 10
local MAP_HEIGHT = 10
local TILE_WIDTH = 70
local TILE_HEIGHT = 70


map.Map = {}
map.Map.Grid = {
    { 1, 1, 1, 1, 1, 1, 1, 1,
        1,
        1 },
    { 1, 2, 2, 2, 2, 2, 2, 2,
        2,
        1 },
    { 1, 2, 2, 2, love.math.random(2, 3), love.math.random(2, 3), 2, 2,
        2,
        1 },
    { 1, love.math.random(2, 3), 2, 2, 2, 2, 2, 2,
        2,
        1 },
    { 1, 2, 2, 2, love.math.random(2, 3), love.math.random(2, 3), 2, 2,
        2,
        1 },
    { 1, 2, 2, 2, 2, love.math.random(2, 3),
        love.math
            .random(2, 3), 2,
        2,
        1 },
    { 1, 2, love.math.random(2, 3), 2, 2, 2, 2, 2,
        2,
        1 },
    { 1, 2, 2, 2, 2, 2, 2,
        love.math
            .random(2, 3), 2,
        1 },
    { 1, 2, love.math.random(2, 3), 2, 2, 2, 2,
        love.math
            .random(2, 3), 2,
        1 },
    { 1, 1, 1, 1, 1, 1, 1, 1,
        1,
        1 },
}

map.TileTextures = {}
map.TileTypes = {}
map.CollisionHero = false

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

function map.GetTileSize()
    return TILE_WIDTH, TILE_HEIGHT
end

function map.forbiddenPosition(x, y)
    local enemyX = x
    local enemyY = y
    local id = map.Map.Grid[enemyY][enemyX]
    print(id)
    if id == 3 or id == 1 then
        return true
    end
    return false
end

function map.CheckCollisionObstacle(positionX, positionY, radius)
    local c, l

    for l = 1, MAP_HEIGHT do
        for c = 1, MAP_WIDTH do
            local id = map.Map.Grid[l][c]
            if id == 3 or id == 1 then
                local tileX, tileY = (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT
                map.tileCenterX = tileX + TILE_WIDTH / 2
                map.tileCenterY = tileY + TILE_HEIGHT / 2
                map.circleRadius = TILE_WIDTH / 2
                map.distance = math.dist(map.tileCenterX, map.tileCenterY, positionX, positionY)
                if map.distance < radius + map.circleRadius then
                    --print("collision with Tank !")
                    return true
                end
            end
        end
    end
    return false
end

function map.CheckCollisionObstacleWithBullet(positionX, positionY, radius, speedX, speedY)
    local c, l

    for l = 1, MAP_HEIGHT do
        for c = 1, MAP_WIDTH do
            local id = map.Map.Grid[l][c]
            if id == 3 then
                local tileX, tileY = (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT
                local tileCenterX = tileX + TILE_WIDTH / 2
                local tileCenterY = tileY + TILE_HEIGHT / 2
                local circleRadius = TILE_WIDTH / 2
                local distance = math.dist(tileCenterX, tileCenterY, positionX, positionY)
                if distance < radius + circleRadius then
                    local dx = tileCenterX - positionX
                    local dy = tileCenterY - positionY
                    local normalX = dx / distance
                    local normalY = dy / distance
                    local dot = speedX * normalX + speedY * normalY
                    map.bounceX = speedX - (2 * dot * normalX)
                    map.bounceY = speedY - (2 * dot * normalY)
                    --print("collision with bullet !")
                    return true
                end
            end
        end
    end
    return false
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

    for l = 1, MAP_HEIGHT do
        for c = 1, MAP_WIDTH do
            local id = map.Map.Grid[l][c]
            if id == 3 or id == 1 then
                local tileX, tileY = (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT
                map.tileCenterX = tileX + TILE_WIDTH / 2
                map.tileCenterY = tileY + TILE_HEIGHT / 2
                map.circleRadius = TILE_WIDTH / 2
                love.graphics.circle("line", map.tileCenterX, map.tileCenterY, map.circleRadius)
            end
        end
    end
end

return map

require "utils"

-- Initialize the map table
local map = {}

-- Define constants for map dimensions and tile sizes
local MAP_WIDTH = 10
local MAP_HEIGHT = 10
local TILE_WIDTH = 70
local TILE_HEIGHT = 70

-- Define the map structure
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

-- Define textures and types for tiles
map.TileTextures = {}
map.TileTypes = {}

-- Flag to track collision with the hero
map.CollisionHero = false

-- Load the map
function map.Load()
    -- Assign textures to tile IDs
    map.TileTextures[0] = nil
    map.TileTextures[1] = love.graphics.newImage("images/stone.png")
    map.TileTextures[2] = love.graphics.newImage("images/dirt.png")
    map.TileTextures[3] = love.graphics.newImage("images/dirtWithOil.png")

    -- Assign types to tile IDs
    map.TileTypes[0] = "nil"
    map.TileTypes[1] = "stone"
    map.TileTypes[2] = "dirt"
    map.TileTypes[3] = "obstacle"
end

function map.GetTileSize()
    return TILE_WIDTH, TILE_HEIGHT
end

-- Check if a position is forbidden
function map.forbiddenPosition(x, y)
    local enemyX = x
    local enemyY = y
    local id = map.Map.Grid[enemyY][enemyX]
    if id == 3 or id == 1 then
        return true
    end
    return false
end

-- Check collision with hero or enemies in the map
function map.CheckCollisionObstacle(positionX, positionY, radius)
    local c, l
    -- Iterate over each tile in the map grid
    for l = 1, MAP_HEIGHT do
        for c = 1, MAP_WIDTH do
            -- Get the ID of the current tile
            local id = map.Map.Grid[l][c]
            if id == 3 or id == 1 then
                local tileX, tileY = (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT
                map.tileCenterX = tileX + TILE_WIDTH / 2
                map.tileCenterY = tileY + TILE_HEIGHT / 2
                map.circleRadius = TILE_WIDTH / 2
                map.distance = math.dist(map.tileCenterX, map.tileCenterY, positionX, positionY)
                if map.distance < radius + map.circleRadius then
                    -- Collision with an obstacle or stone tile
                    return true
                end
            end
        end
    end
    return false
end

-- Check collision with bullets in the map
function map.GetObsacles()
    -- Create an empty table to store the obstacles
    local obstacles = {}

    -- Iterate over each tile in the map grid
    for l = 1, MAP_HEIGHT do
        for c = 1, MAP_WIDTH do
            -- Get the ID of the current tile
            local id = map.Map.Grid[l][c]
            -- Check if the tile is an obstacle (ID 3)
            if id == 3 then
                local circleRadius = TILE_WIDTH / 2
                local tileX, tileY = (c - 1) * TILE_WIDTH + TILE_WIDTH / 2, (l - 1) * TILE_HEIGHT + TILE_WIDTH / 2
                -- Create a new obstacle object
                local obstacle = {}
                obstacle.x = tileX
                obstacle.y = tileY
                obstacle.radius = circleRadius
                -- Insert the obstacle object (x,y,radius) into the table of obstacles
                table.insert(obstacles, obstacle)
            end
        end
    end
    return obstacles
end

function map.Draw()
    local c, l

    -- Draw the map tiles
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
end

return map

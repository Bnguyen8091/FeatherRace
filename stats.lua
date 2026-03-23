-- Handles bird stats and basic actions

local stats = {}

-- Bird object
local bird = {
    name = "Default",
    speed = 5,
    stamina = 5,
    happiness = 5
}

-- Initialize bird
function stats.createBird(name)
    bird.name = name or "Bird"
    bird.speed = 5
    bird.stamina = 5
    bird.happiness = 5
end

-- Display stats
function stats.showStats()
    print("\n--- Bird Stats ---")
    print("Name: " .. bird.name)
    print("Speed: " .. bird.speed)
    print("Stamina: " .. bird.stamina)
    print("Happiness: " .. bird.happiness)
    print("------------------\n")
end

-- Clamp helper
local function clamp(value)
    if value < 0 then return 0 end
    if value > 10 then return 10 end
    return value
end

-- Actions
function stats.feed()
    print("You feed your bird.")
    bird.stamina = clamp(bird.stamina + 2)
    bird.happiness = clamp(bird.happiness + 1)
end

function stats.train()
    print("You train your bird.")
    bird.speed = clamp(bird.speed + 1)
    bird.stamina = clamp(bird.stamina - 1)
    bird.happiness = clamp(bird.happiness - 1)
end

function stats.play()
    print("You play with your bird.")
    bird.happiness = clamp(bird.happiness + 2)
    bird.stamina = clamp(bird.stamina - 1)
end

return stats

local stats = {}

local bird = {
    name = "Default",
    speed = 6,
    stamina = 6,
    happiness = 5,
    swimming = 5,
    flying = 6,
    running = 4
}

local function clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

local function getMood()
    if bird.happiness <= 1 then
        return "Awful"
    elseif bird.happiness <= 3 then
        return "Bad"
    elseif bird.happiness <= 5 then
        return "Normal"
    elseif bird.happiness <= 7 then
        return "Good"
    else
        return "Great"
    end
end

function stats.createBird(name)
    bird.name = name or "Bird"
    bird.speed = 6
    bird.stamina = 6
    bird.happiness = 5
    bird.swimming = 5
    bird.flying = 6
    bird.running = 4
end

function stats.showStats()
    print("\n--- Bird Stats ---")
    print("Name: " .. bird.name)
    print("Speed: " .. bird.speed)
    print("Stamina: " .. bird.stamina)
    print("Mood: " .. getMood())
    print("Swimming: " .. bird.swimming)
    print("Flying: " .. bird.flying)
    print("Running: " .. bird.running)
    print("------------------\n")
end

function stats.isGameOver()
    if bird.stamina <= 0 then
        print("\n=== GAME OVER ===")
        print(bird.name .. " is too exhausted to continue.")
        return true
    end
    return false
end

function stats.feed()
    print("You feed your bird.")
    bird.stamina = clamp(bird.stamina + 2, 0, 10)
    bird.happiness = clamp(bird.happiness + 1, 0, 10)
end

function stats.train()
    print("You train your bird.")
    bird.speed = clamp(bird.speed + 1, 0, 10)
    bird.stamina = clamp(bird.stamina - 1, 0, 10)
    bird.happiness = clamp(bird.happiness - 1, 0, 10)
end

function stats.play()
    print("You play with your bird.")
    bird.happiness = clamp(bird.happiness + 2, 0, 10)
    bird.stamina = clamp(bird.stamina - 1, 0, 10)
end

function stats.rest()
    print("Your bird takes a rest.")
    bird.stamina = clamp(bird.stamina + 3, 0, 10)
end

function stats.getMoodRaceModifier()
    local mood = getMood()

    if mood == "Awful" then
        return -2
    elseif mood == "Bad" then
        return -1
    elseif mood == "Normal" then
        return 0
    elseif mood == "Good" then
        return 1
    else
        return 2
    end
end

function stats.getBird()
    return bird
end

return stats

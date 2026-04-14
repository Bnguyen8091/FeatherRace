local stats = {}

local bird = {
    name = "Default",
    speed = 6,
    stamina = 10,
    happiness = 5,
    swimming = 5,
    flying = 6,
    running = 4,
    money = 10000
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

local function makeBar(value, max)
    local filled = string.rep("#", value)
    local empty = string.rep("-", max - value)
    return "[" .. filled .. empty .. "]"
end

local function trainSkill(skillName, statKey, maxMessage)
    print("You train your bird in " .. skillName .. ".")

    if bird.stamina <= 0 then
        print("Your bird is too exhausted to train.")
        return
    elseif bird.happiness <= 0 then
        print("Your bird is too unhappy to train.")
        return
    elseif bird[statKey] >= 10 then
        print(maxMessage)
        return
    end

    bird[statKey] = clamp(bird[statKey] + 1, 0, 10)
    bird.stamina = clamp(bird.stamina - 1, 0, 10)
    bird.happiness = clamp(bird.happiness - 1, 0, 10)
end

function stats.createBird(name)
    bird.name = name or "Bird"
    bird.speed = math.random(4, 6)
    bird.stamina = 10
    bird.happiness = math.random(4, 6)
    bird.swimming = math.random(4, 6)
    bird.flying = math.random(4, 6)
    bird.running = math.random(4, 6)
end

function stats.showStats()
    print("\n================================")
    print("         BIRD STATUS")
    print("================================")
    print("Name:      " .. bird.name)
    print("Speed:     " .. bird.speed)
    print("Stamina:   " .. bird.stamina .. " " .. makeBar(bird.stamina, 10))
    print("Mood:      " .. getMood())
    print("Swimming:  " .. bird.swimming)
    print("Flying:    " .. bird.flying)
    print("Running:   " .. bird.running)
    print("Money:     " .. bird.money)
    print("================================\n")
end

function stats.isGameOver()
    if bird.stamina <= 0 then
        print("\n===== GAME OVER =====")
        print(bird.name .. " is too exhausted to continue.")
        return true
    end
    return false
end

function stats.feed()
    local recovery = math.random(1, 2)

    print("You feed your bird.")
    print("Stamina restored: +" .. recovery)

    bird.stamina = clamp(bird.stamina + recovery, 0, 10)
    bird.happiness = clamp(bird.happiness + 1, 0, 10)
end

function stats.trainSpeed()
    trainSkill("general speed", "speed", "Your bird has reached maximum speed.")
end

function stats.trainRunning()
    trainSkill("running", "running", "Your bird has reached maximum running ability.")
end

function stats.trainSwimming()
    trainSkill("swimming", "swimming", "Your bird has reached maximum swimming ability.")
end

function stats.trainFlying()
    trainSkill("flying", "flying", "Your bird has reached maximum flying ability.")
end

function stats.play()
    print("You play with your bird.")

    local mood = getMood()
    local bonus = 0

    if mood == "Awful" then
        bonus = -1
    elseif mood == "Bad" then
        bonus = 0
    elseif mood == "Normal" then
        bonus = 1
    elseif mood == "Good" then
        bonus = 2
    elseif mood == "Great" then
        bonus = 3
    end

    bird.happiness = clamp(bird.happiness + 2 + bonus, 0, 10)
    bird.stamina = clamp(bird.stamina - 1, 0, 10)
end

function stats.rest()
    local outcomes = {
        { name = "Sleep Deprived", recovery = 5 },
        { name = "Rested", recovery = 7 },
        { name = "Well Rested", recovery = 10 }
    }

    local result = outcomes[math.random(#outcomes)]

    print("Your bird takes a rest.")
    print("Rest quality: " .. result.name)
    print("Stamina restored: +" .. result.recovery)

    bird.stamina = clamp(bird.stamina + result.recovery, 0, 10)
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

function stats.getMoney()
    return bird.money
end

function stats.addMoney(amount)
    bird.money = bird.money + amount
end

function stats.spendMoney(amount)
    if bird.money >= amount then
        bird.money = bird.money - amount
        return true
    end
    return false
end

function stats.setBird(data)
    for k, v in pairs(data) do
        bird[k] = v
    end
end

return stats
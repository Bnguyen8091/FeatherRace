local stats = {}

local bird = {
    name = "Default",
    speed = 6,
    stamina = 10,
    happiness = 5,
    swimming = 5,
    flying = 6,
    running = 4,
    money = 10000 --Default money for testing
}

-- clamp helper
local function clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

-- mood system
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

-- stamina bar
local function makeBar(value, max)
    local filled = string.rep("#", value)
    local empty = string.rep("-", max - value)
    return "[" .. filled .. empty .. "]"
end

-- initialize bird
function stats.createBird(name)
    bird.name = name or "Bird"
    bird.speed = math.random(4, 6)
    bird.stamina = 10
    bird.happiness = math.random(4, 6)
    bird.swimming = math.random(4, 6)
    bird.flying = math.random(4, 6)
    bird.running = math.random(4, 6)
end

-- HUD display
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
    print("Money:   " .. bird.money)
    print("================================\n")
end

-- game over condition
function stats.isGameOver()
    if bird.stamina <= 0 then
        print("\n===== GAME OVER =====")
        print(bird.name .. " is too exhausted to continue.")
        return true
    end
    return false
end

-- feed action
function stats.feed()
    local recovery = math.random(1, 2)

    print("You feed your bird.")
    print("Stamina restored: +" .. recovery)

    bird.stamina = clamp(bird.stamina + recovery, 0, 10)
    bird.happiness = clamp(bird.happiness + 1, 0, 10)
end

-- train action
function stats.train()
    print("You train your bird.")

    if bird.stamina <= 0 then
        print("Your bird is too exhausted to train.")
        return
    elseif bird.happiness <= 0 then
        print("Your bird is too unhappy to train.")
        return
    elseif bird.speed >= 10 then
        print("Your bird has reached maximum speed.")
        return
    end
    bird.speed = clamp(bird.speed + 1, 0, 10)
    bird.stamina = clamp(bird.stamina - 1, 0, 10)
    bird.happiness = clamp(bird.happiness - 1, 0, 10)
end

function stats.trainSwimming()
    print("You train your bird.")
    if bird.stamina <= 0 then
        print("Your bird is too exhausted to train.")
        return
    elseif bird.happiness <= 0 then
        print("Your bird is too unhappy to train.")
        return
    elseif bird.swimming >= 10 then
        print("Your bird has reached maximum swimming ability.")
        return
    end
    bird.swimming = clamp(bird.swimming + 1, 0, 10)
    bird.stamina = clamp(bird.stamina - 1, 0, 10)
    bird.happiness = clamp(bird.happiness - 1, 0, 10)
end

function stats.trainFlying()
    print("You train your bird.")
    if bird.stamina <= 0 then
        print("Your bird is too exhausted to train.")
        return
    elseif bird.happiness <= 0 then
        print("Your bird is too unhappy to train.")
        return
    elseif bird.flying >= 10 then
        print("Your bird has reached maximum flying ability.")
        return
    end
    bird.flying = clamp(bird.flying + 1, 0, 10)
    bird.stamina = clamp(bird.stamina - 1, 0, 10)
    bird.happiness = clamp(bird.happiness - 1, 0, 10)
end

function stats.trainRunning()
    print("You train your bird.")
    if bird.stamina <= 0 then
        print("Your bird is too exhausted to train.")
        return
    elseif bird.happiness <= 0 then
        print("Your bird is too unhappy to train.")
        return
    elseif bird.running >= 10 then
        print("Your bird has reached maximum running ability.")
        return
    end
    bird.running = clamp(bird.running + 1, 0, 10)
    bird.stamina = clamp(bird.stamina - 1, 0, 10)
    bird.happiness = clamp(bird.happiness - 1, 0, 10)
end
-- play action
function stats.play()
    print("You play with your bird.")

    local bonus = 0
    local mood = getMood()

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

-- rest action
function stats.rest()
    local outcomes = {
        {name = "Sleep Deprived", recovery = 5},
        {name = "Rested", recovery = 7},
        {name = "Well Rested", recovery = 10}
    }

    local result = outcomes[math.random(#outcomes)]

    print("Your bird takes a rest.")
    print("Rest quality: " .. result.name)
    print("Stamina restored: +" .. result.recovery)

    bird.stamina = clamp(bird.stamina + result.recovery, 0, 10)
end

-- mood modifier for races
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

-- Money functions

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
    else
        return false
    end
end

return stats
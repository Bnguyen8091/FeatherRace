local race = {
    name = "",
    distance = 0,
    running = 0,
    swimming = 0,
    flying = 0,
    stage = 1,
    daysLeft = 15,
    totalStages = 3,
    difficultyMultiplier = 1.0
}

local allRaceNames = {
    running = {
        "Crimson Canyon",
        "Dust Sprint Valley",
        "Ironstride Plains",
        "Golden Track Run",
        "Blazing Horizon",
        "Sunfire Sprint",
        "Thunder Trail"
    },
    swimming = {
        "Emerald Rapids",
        "Moonlit Current",
        "Tidal Rush",
        "Azure Depths",
        "Coral Surge",
        "Whirlpool Dash",
        "Bluewater Burst"
    },
    flying = {
        "Stormbreak Pass",
        "Skyfall Ascent",
        "Thunder Hollow",
        "Windscar Peak",
        "Cloudpiercer Run",
        "Gale Force Heights",
        "Skyfire Glide"
    }
}

local availableRaceNames = {
    running = {},
    swimming = {},
    flying = {}
}

local raceDayOptions = {
    15,
    10,
    5
}

local function resetRaceNames()
    availableRaceNames.running = {}
    availableRaceNames.swimming = {}
    availableRaceNames.flying = {}

    for _, name in ipairs(allRaceNames.running) do
        table.insert(availableRaceNames.running, name)
    end

    for _, name in ipairs(allRaceNames.swimming) do
        table.insert(availableRaceNames.swimming, name)
    end

    for _, name in ipairs(allRaceNames.flying) do
        table.insert(availableRaceNames.flying, name)
    end
end

local function getStageName()
    if race.stage == 1 then
        return "Race 1"
    elseif race.stage == 2 then
        return "Race 2"
    else
        return "Final Race"
    end
end

local function getDominantTheme()
    if race.running >= race.swimming and race.running >= race.flying then
        return "running"
    elseif race.swimming >= race.running and race.swimming >= race.flying then
        return "swimming"
    else
        return "flying"
    end
end

local function getUniqueRaceName()
    local theme = getDominantTheme()
    local pool = availableRaceNames[theme]

    if #pool == 0 then
        for _, fallbackTheme in ipairs({ "running", "swimming", "flying" }) do
            if #availableRaceNames[fallbackTheme] > 0 then
                pool = availableRaceNames[fallbackTheme]
                break
            end
        end
    end

    if not pool or #pool == 0 then
        return "Champion's Trial"
    end

    local index = math.random(1, #pool)
    local chosenName = pool[index]
    table.remove(pool, index)

    return chosenName
end

function race.createRace()
    local part1
    local part2
    local part3

    if race.stage == 1 then
        part1 = math.random(3, 5)
        part2 = math.random(3, 5)
        part3 = math.random(3, 5)
        race.distance = math.random(80, 110)
        race.difficultyMultiplier = 0.50
    elseif race.stage == 2 then
        part1 = math.random(2, 6)
        part2 = math.random(2, 6)
        part3 = math.random(2, 6)
        race.distance = math.random(110, 150)
        race.difficultyMultiplier = 0.72
    else
        part1 = math.random(1, 8)
        part2 = math.random(1, 8)
        part3 = math.random(1, 8)
        race.distance = math.random(150, 200)
        race.difficultyMultiplier = 0.90
    end

    local total = part1 + part2 + part3

    race.running = (part1 / total) * 100
    race.swimming = (part2 / total) * 100
    race.flying = (part3 / total) * 100

    race.name = getUniqueRaceName()
end

function race.startRaceCycle()
    race.stage = 1
    race.daysLeft = raceDayOptions[race.stage]
    resetRaceNames()
    race.createRace()

    print("\n================================")
    print("       TRAINING BEGINS")
    print("================================")
    print(getStageName() .. " begins in " .. race.daysLeft .. " days.")
    print("Train wisely before race day!")
    print("================================\n")
end

function race.showRace()
    print("\n================================")
    print("      " .. getStageName() .. ": " .. race.name)
    print("================================")
    print("Distance: " .. race.distance .. "m")
    print("Running: " .. string.format("%.2f", race.running) .. "%")
    print("Swimming: " .. string.format("%.2f", race.swimming) .. "%")
    print("Flying: " .. string.format("%.2f", race.flying) .. "%")
    print("Theme: " .. getDominantTheme())
    print("Days Until Race: " .. race.daysLeft)
    print("================================\n")
end

function race.showRaceStatus()
    if race.stage <= race.totalStages then
        print("Current Stage: " .. getStageName())
        print("Days Remaining: " .. race.daysLeft)
    end
end

function race.advanceDay()
    if race.stage > race.totalStages then
        return false
    end

    race.daysLeft = race.daysLeft - 1

    if race.daysLeft > 0 then
        print("A day passes... " .. race.daysLeft .. " day(s) left until " .. getStageName() .. ".")
        return false
    else
        print("\n================================")
        print("         RACE DAY!")
        print("================================")
        print(getStageName() .. " is here!")
        print("================================\n")
        return true
    end
end

function race.racing(bird)
    local shop = require("shop")

    local swimBoost = shop.has("flippers") and 1.25 or 1
    local flyBoost = shop.has("jetpack") and 1.25 or 1
    local runBoost = shop.has("shoes") and 1.25 or 1

    local boostedSwimming = bird.swimming * swimBoost
    local boostedFlying = bird.flying * flyBoost
    local boostedRunning = bird.running * runBoost

    print("\nActive Boosters:")

    local hasAny = false

    if shop.has("flippers") then
        print("- Flippers (Swim x1.25)")
        hasAny = true
    end

    if shop.has("jetpack") then
        print("- Jetpack (Fly x1.25)")
        hasAny = true
    end

    if shop.has("shoes") then
        print("- Running Shoes (Run x1.25)")
        hasAny = true
    end

    if not hasAny then
        print("None")
    end

    local runPower = math.random(2, 8) + (boostedRunning * 1.6)
    local swimPower = math.random(2, 8) + (boostedSwimming * 1.6)
    local flyPower = math.random(2, 8) + (boostedFlying * 1.6)

    local modifier = 0
    if bird.happiness > 7 then
        modifier = 3
    elseif bird.happiness < 3 then
        modifier = -3
    end

    local staminaMult = 1.0
    if bird.stamina < 3 then
        staminaMult = 0.5
    elseif bird.stamina < 5 then
        staminaMult = 0.75
    elseif bird.stamina > 8 then
        staminaMult = 1.15
    end

    bird.stamina = math.max(0, bird.stamina - 4)

    runPower = (runPower + modifier) * staminaMult
    swimPower = (swimPower + modifier) * staminaMult
    flyPower = (flyPower + modifier) * staminaMult

    if shop.has("flippers") then shop.consume("flippers") end
    if shop.has("jetpack") then shop.consume("jetpack") end
    if shop.has("shoes") then shop.consume("shoes") end

    local totalScore =
        (runPower * (race.running / 100)) +
        (swimPower * (race.swimming / 100)) +
        (flyPower * (race.flying / 100))

    local distancePerformance = race.distance * (totalScore / 40) * (1 + bird.speed * 0.02)
    local requiredDistance = race.distance * race.difficultyMultiplier

    print("\n" .. bird.name .. " performed at level: " .. string.format("%.2f", totalScore))
    print("Track Distance: " .. race.distance .. "m")
    print("Distance Needed To Win: " .. string.format("%.2f", requiredDistance) .. "m")
    print("Units covered: " .. string.format("%.2f", distancePerformance) .. "m")

    if distancePerformance >= requiredDistance then
        print("\n*** 1ST PLACE! ***")
        print("CONGRATULATIONS! " .. bird.name .. " won " .. getStageName() .. "!")
        return true
    else
        print("\n...LAST PLACE...")
        print("OH NO! " .. bird.name .. " lost " .. getStageName() .. ".")
        return false
    end
end

function race.runRaceDay(bird)
    local wonRace = race.racing(bird)

    if bird.stamina <= 0 then
        print("\n===== GAME OVER =====")
        print(bird.name .. " is too exhausted after the race.")
        return true
    end

    if not wonRace then
        print("\n===== GAME OVER =====")
        print(bird.name .. "'s racing journey ends here.")
        print("Better luck next time!")
        return true
    end

    local stats = require("stats")
    local reward = 0

    if race.stage == 1 then
        reward = 50
    elseif race.stage == 2 then
        reward = 100
    else
        reward = 200
    end

    stats.addMoney(reward)
    print("You earned " .. reward .. " coins!")

    if race.stage == race.totalStages then
        print("\n================================")
        print("        CHAMPION ENDING")
        print("================================")
        print(bird.name .. " finished in 1ST PLACE in the Final Race!")
        print("Your bird is the FeatherRace Champion!")
        print("Thanks for playing FeatherRace!")
        print("================================\n")
        return true
    end

    race.stage = race.stage + 1
    race.daysLeft = raceDayOptions[race.stage]
    race.createRace()

    print("\n================================")
    print("      NEXT TRAINING PERIOD")
    print("================================")
    print(getStageName() .. " begins in " .. race.daysLeft .. " days.")
    print("A new race has been prepared.")
    print("================================\n")

    race.showRace()
    return false
end

function race.getRaceData()
    return {
        name = race.name,
        distance = race.distance,
        running = race.running,
        swimming = race.swimming,
        flying = race.flying,
        stage = race.stage,
        daysLeft = race.daysLeft,
        totalStages = race.totalStages,
        difficultyMultiplier = race.difficultyMultiplier,
        availableRaceNames = availableRaceNames
    }
end

function race.setRaceData(data)
    race.name = data.name
    race.distance = data.distance
    race.running = data.running
    race.swimming = data.swimming
    race.flying = data.flying
    race.stage = data.stage
    race.daysLeft = data.daysLeft
    race.totalStages = data.totalStages
    race.difficultyMultiplier = data.difficultyMultiplier

    if data.availableRaceNames then
        availableRaceNames = data.availableRaceNames
    else
        resetRaceNames()
    end
end

return race
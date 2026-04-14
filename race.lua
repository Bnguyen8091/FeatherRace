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

local raceNames = {
    "Feather Dash",
    "Wing",
    "Beak Sprint",
    "Tailwind",
    "Sky Glide",
    "Wainng Race",
    "Feather Frenzy",
    "Beak Battle",
    "Wing War",
    "Tailwind Tussle",
    "Feather Flurry",
    "Beak Blitz",
    "Wing Whirl",
    "Tailwind Tornado",
    "Feather Fury",
    "Beak Barrage",
    "Wing Whip",
    "Tailwind Tempest",
    "Feather Flash",
    "Beak Burst",
    "Wing Whiz",
    "Tailwind Thunder",
    "Feather Flare",
}

local raceDayOptions = {
    15,
    10,
    5
}

local function getStageName()
    if race.stage == 1 then
        return "Race 1"
    elseif race.stage == 2 then
        return "Race 2"
    else
        return "Final Race"
    end
end

function race.createRace()
    local part1
    local part2
    local part3

    -- gradually harder races
    if race.stage == 1 then
        part1 = math.random(3, 5)
        part2 = math.random(3, 5)
        part3 = math.random(3, 5)
        race.distance = math.random(80, 110)
        race.difficultyMultiplier = 0.70
    elseif race.stage == 2 then
        part1 = math.random(2, 6)
        part2 = math.random(2, 6)
        part3 = math.random(2, 6)
        race.distance = math.random(110, 150)
        race.difficultyMultiplier = 0.95
    else
        part1 = math.random(1, 8)
        part2 = math.random(1, 8)
        part3 = math.random(1, 8)
        race.distance = math.random(150, 200)
        race.difficultyMultiplier = 1.10
    end

    local total = part1 + part2 + part3

    race.running = (part1 / total) * 100
    race.swimming = (part2 / total) * 100
    race.flying = (part3 / total) * 100

    race.name = raceNames[math.random(1, #raceNames)]
    
end

function race.startRaceCycle()
    race.stage = 1
    race.daysLeft = raceDayOptions[race.stage]
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
    local runPower = (math.random(1, 10) + (bird.running * 3))
    local swimPower = (math.random(1, 10) + (bird.swimming * 3))
    local flyPower = (math.random(1, 10) + (bird.flying * 3))

    local modifier = 0
    if bird.happiness > 7 then
        modifier = 10
    elseif bird.happiness < 3 then
        modifier = -10
    end

    local staminaMult = 1.0
    if bird.stamina < 3 then
        staminaMult = 0.5
    elseif bird.stamina < 5 then
        staminaMult = 0.75
    elseif bird.stamina > 8 then
        staminaMult = 1.25
    end

    bird.stamina = math.max(0, bird.stamina - 5)

    runPower = (runPower + modifier) * staminaMult
    swimPower = (swimPower + modifier) * staminaMult
    flyPower = (flyPower + modifier) * staminaMult

    local totalScore = (runPower * (race.running / 100)) +
                       (swimPower * (race.swimming / 100)) +
                       (flyPower * (race.flying / 100))

    local distancePerformance = race.distance * (totalScore / 50) * (1 + (bird.speed) * 0.05)
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
        difficultyMultiplier = race.difficultyMultiplier
    }
end

-- You also need a setter to restore the data when loading
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
end

return race
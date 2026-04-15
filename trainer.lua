local trainer = {}

local function clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

local function getMoodModifier(happiness)
    if happiness > 7 then
        return 10
    elseif happiness < 3 then
        return -10
    else
        return 0
    end
end

local function getStaminaMultiplier(stamina)
    if stamina < 3 then
        return 0.5
    elseif stamina < 5 then
        return 0.75
    elseif stamina > 8 then
        return 1.25
    else
        return 1.0
    end
end

local function getDominantTheme(raceData)
    if raceData.running >= raceData.swimming and raceData.running >= raceData.flying then
        return "running"
    elseif raceData.swimming >= raceData.running and raceData.swimming >= raceData.flying then
        return "swimming"
    else
        return "flying"
    end
end

local function getAdviceText(chance, bird, raceData)
    local theme = getDominantTheme(raceData)

    if chance >= 85 then
        return "This duck looks race-ready. I'd be shocked if it doesn't place well."
    elseif chance >= 70 then
        return "Strong build. Keep that stamina up and you've got a real shot."
    elseif chance >= 55 then
        return "This one could win, but it'll depend on preparation and a bit of luck."
    elseif chance >= 40 then
        return "I'm not fully convinced yet. You should train for this track before race day."
    else
        if theme == "running" then
            return "Bad outlook. This track favors running, and your duck isn't ready for it."
        elseif theme == "swimming" then
            return "Bad outlook. This track favors swimming, and your duck needs more work there."
        else
            return "Bad outlook. This track favors flying, and your duck looks underprepared."
        end
    end
end

function trainer.rateDuck(bird, raceData)
    local moodModifier = getMoodModifier(bird.happiness)
    local staminaMultiplier = getStaminaMultiplier(bird.stamina)

    -- expected average race power instead of random rolls
    local avgRunPower = (5.5 + (bird.running * 3) + moodModifier) * staminaMultiplier
    local avgSwimPower = (5.5 + (bird.swimming * 3) + moodModifier) * staminaMultiplier
    local avgFlyPower = (5.5 + (bird.flying * 3) + moodModifier) * staminaMultiplier

    local weightedScore =
        (avgRunPower * (raceData.running / 100)) +
        (avgSwimPower * (raceData.swimming / 100)) +
        (avgFlyPower * (raceData.flying / 100))

    local projectedDistance =
        raceData.distance * (weightedScore / 50) * (1 + (bird.speed * 0.05))

    local requiredDistance = raceData.distance * raceData.difficultyMultiplier
    local ratio = projectedDistance / requiredDistance

    -- convert projected performance ratio into a readable win chance
    local chance = math.floor(clamp(((ratio - 0.70) / 0.60) * 100, 5, 95))

    print("\n================================")
    print("     VETERAN TRAINER REPORT")
    print("================================")
    print("Duck: " .. bird.name)
    print("Upcoming Race: " .. raceData.name)
    print("Estimated Win Chance: " .. chance .. "%")
    print("--------------------------------")
    print(getAdviceText(chance, bird, raceData))
    print("================================\n")
end

return trainer
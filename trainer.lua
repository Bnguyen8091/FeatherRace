local trainer = {}

local function clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

local function getMoodModifier(happiness)
    if happiness > 7 then
        return 3
    elseif happiness < 3 then
        return -3
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
        return 1.15
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
    local shop = require("shop")

    local swimBoost = shop.has("flippers") and 1.25 or 1
    local flyBoost = shop.has("jetpack") and 1.25 or 1
    local runBoost = shop.has("shoes") and 1.25 or 1

    local boostedSwimming = bird.swimming * swimBoost
    local boostedFlying = bird.flying * flyBoost
    local boostedRunning = bird.running * runBoost

    local moodModifier = getMoodModifier(bird.happiness)
    local staminaMultiplier = getStaminaMultiplier(bird.stamina)

    local avgRunPower = (5 + (boostedRunning * 1.6) + moodModifier) * staminaMultiplier
    local avgSwimPower = (5 + (boostedSwimming * 1.6) + moodModifier) * staminaMultiplier
    local avgFlyPower = (5 + (boostedFlying * 1.6) + moodModifier) * staminaMultiplier

    local weightedScore =
        (avgRunPower * (raceData.running / 100)) +
        (avgSwimPower * (raceData.swimming / 100)) +
        (avgFlyPower * (raceData.flying / 100))

    local projectedDistance =
        raceData.distance * (weightedScore / 40) * (1 + (bird.speed * 0.02))

    local requiredDistance = raceData.distance * raceData.difficultyMultiplier
    local ratio = projectedDistance / requiredDistance

    local chance = math.floor(clamp(((ratio - 0.80) / 0.45) * 100, 5, 95))

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
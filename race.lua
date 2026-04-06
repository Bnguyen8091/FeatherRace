

local race = {
    name = "",
    distance = 0,
    running = 0,
    swimming = 0,
    flying = 0,

}

raceNames = {
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
    "Feather Flurry"
}

function race.createRace()
    math.randomseed(os.time())
    part1 = math.random(1,10)
    part2 = math.random(1,10)
    part3 = math.random(1,10)

    race.running = (part1 / (part1 + part2 + part3)) * 100
    race.swimming = (part2 / (part1 + part2 + part3)) * 100
    race.flying = (part3 / (part1 + part2 + part3)) * 100

    race.distance = math.random(100, 200)
    race.name = raceNames[math.random(1, #raceNames)]

end

function race.showRace()
    print("\n================================")
    print("         " .. race.name)
    print("================================")  
    print("Distance: " .. race.distance .. "m")
    print("Running: " .. string.format("%.2f", race.running) .. "%")
    print("Swimming: " .. string.format("%.2f", race.swimming) .. "%")
    print("Flying: " .. string.format("%.2f", race.flying) .. "%")
    print("================================\n")
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

    local distancePerformance =  race.distance * (totalScore / 50) * (1 + (bird.speed) * 0.05)

    print("\n" .. bird.name .. " performed at level: " .. string.format("%.2f", totalScore))
    print("Distance Goal: " .. race.distance .. "m")
    print("Units covered: " .. string.format("%.2f", distancePerformance) .. "m")

    if distancePerformance >= race.distance then
        print("CONGRATULATIONS! " .. bird.name .. " crossed the finish line!")
    else
        print("OH NO! " .. bird.name .. " collapsed before the end of the track.")
    end

    return totalScore
end 

return race
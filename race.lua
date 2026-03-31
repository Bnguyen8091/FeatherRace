

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



return race
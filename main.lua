local tools = require("stats")
local track = require("race")
local shop = require("shop")

function main()
    math.randomseed(os.time())
    local running = true

    io.write("Enter your bird's name: ")
    local name = io.read()

    tools.createBird(name)

    track.startRaceCycle()
    track.showRace()
    tools.showStats()

    local function showCommands() -- reusable command interface
        print("\nCommands: feed, train, Run, Swim, Fly, play, rest, stats, shop, quit")
    end

    showCommands()

    while running do
        io.write("> ")
        local input = io.read()

        input = input:match("^%s*(.-)%s*$")

        if input == "quit" then
            print("Exiting...")
            running = false

        elseif input == "stats" then
            tools.showStats()
            track.showRaceStatus()

        elseif input == "feed" then
            tools.feed()
            if tools.isGameOver() then
                running = false
            else
                local raceReady = track.advanceDay()
                tools.showStats()
                track.showRaceStatus()

                if raceReady then
                    local finished = track.runRaceDay(tools.getBird())
                    tools.showStats()

                    if finished then
                        running = false
                    end
                end
            end

        elseif input == "train" then
            tools.train()
            if tools.isGameOver() then
                running = false
            else
                local raceReady = track.advanceDay()
                tools.showStats()
                track.showRaceStatus()

                if raceReady then
                    local finished = track.runRaceDay(tools.getBird())
                    tools.showStats()

                    if finished then
                        running = false
                    end
                end
            end
        elseif input == "Run" then
            tools.trainRunning()
            if tools.isGameOver() then
                running = false
            else
                local raceReady = track.advanceDay()
                tools.showStats()
                track.showRaceStatus()

                if raceReady then
                    local finished = track.runRaceDay(tools.getBird())
                    tools.showStats()

                    if finished then
                        running = false
                    end
                end
            end
        elseif input == "Swim" then
            tools.trainSwimming()
            if tools.isGameOver() then
                running = false
            else
                local raceReady = track.advanceDay()
                tools.showStats()
                track.showRaceStatus()

                if raceReady then
                    local finished = track.runRaceDay(tools.getBird())
                    tools.showStats()

                    if finished then
                        running = false
                    end
                end
            end
        elseif input == "Fly" then
            tools.trainFlying()
            if tools.isGameOver() then
                running = false
            else
                local raceReady = track.advanceDay()
                tools.showStats()
                track.showRaceStatus()

                if raceReady then
                    local finished = track.runRaceDay(tools.getBird())
                    tools.showStats()

                    if finished then
                        running = false
                    end
                end
            end
        elseif input == "play" then
            tools.play()
            if tools.isGameOver() then
                running = false
            else
                local raceReady = track.advanceDay()
                tools.showStats()
                track.showRaceStatus()

                if raceReady then
                    local finished = track.runRaceDay(tools.getBird())
                    tools.showStats()

                    if finished then
                        running = false
                    end
                end
            end

        elseif input == "rest" then
            tools.rest()
            local raceReady = track.advanceDay()
            tools.showStats()
            track.showRaceStatus()

            if raceReady then
                local finished = track.runRaceDay(tools.getBird())
                tools.showStats()

                if finished then
                    running = false
                end
            end
        elseif input == "shop" then --shop
            shop.openShop()
            showCommands()
        else
            print("Unknown command.")
        end
    end
end

main()
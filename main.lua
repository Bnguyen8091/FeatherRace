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
        print("\nCommands: feed, train, play, rest, stats, shop, help, quit")
    end

    showCommands()

    local function advanceTime() -- advances towards the next race after certain commands
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
    end

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
            advanceTime()

        elseif input == "train" then
            local acted = false -- Track if the player actually spent a turn

            while(not acted) do
                print("Train which skill?\n0: back\n1: speed\n2: running\n3: swimming\n4: flying \n (Each training session costs 1 stamina and reduces happiness by 1) \n (Max skill is 10 per each category)")
                io.write("> ")
                local skillInput = io.read()

                

                if skillInput == "1" then
                    tools.trainSpeed()
                    acted = true
                elseif skillInput == "2" then
                    tools.trainRunning()
                    acted = true
                elseif skillInput == "3" then
                    tools.trainSwimming()
                    acted = true
                elseif skillInput == "4" then
                    tools.trainFlying()
                    acted = true
                elseif skillInput == "0" then
                    print("Returning to main menu.")
                    break
                else
                    print("Invalid skill choice.")
                end
            end

            -- Only advance the game if the player actually trained
            if acted then 
                advanceTime()
            end
        elseif input == "play" then
            tools.play()
            advanceTime()

        elseif input == "rest" then
            tools.rest()
            advanceTime()

        elseif input == "shop" then --shop
            shop.openShop()
            showCommands()

        elseif input == "help" then
            showCommands()

        else
            print("Unknown command.")
            showCommands()
        end
    end
end

main()
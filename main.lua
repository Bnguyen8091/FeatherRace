local tools = require("stats")
local track = require("race")
local shop = require("shop")
local json = require("json")

local function saveGame()
    local success, Save = pcall(function()
        return {
            bird = tools.getBird(),
            race = track.getRaceData(),
            purchases = shop.getPurchases()
        }
    end)

    if not success then
        print("Failed to gather save data: " .. tostring(Save))
        return
    end

    local saveData = json.encode(Save, { indent = true })
    local file, err = io.open("savegame.json", "w")
    
    if file then
        file:write(saveData)
        file:close()
        print("Game saved successfully.")
    else
        -- This helps you debug if it's a permission issue or a missing folder
        print("Error saving game: " .. tostring(err))
    end
end

local function loadGame()
    local file, err = io.open("savegame.json", "r")
    if not file then
        print("No save file found or unable to read: " .. tostring(err))
        return nil
    end

    local contents = file:read("*a")
    file:close()

    -- Using pcall here is safer if the JSON is malformed
    local status, Save = pcall(json.decode, contents)
    
    if status and Save then
        -- Ensure data exists before applying it
        if Save.bird then tools.setBird(Save.bird) end
        if Save.race then track.setRaceData(Save.race) end
        if Save.purchases then shop.setPurchases(Save.purchases) end
        
        print("Game loaded successfully.")
        return true
    else
        print("Error decoding save data: " .. (Save or "Unknown error"))
        return false
    end
end

function main()
    math.randomseed(os.time())
    local running = true


    local game = loadGame() -- Attempt to load a saved game on startup

    if game then
        print("Loaded saved game.")

    else
        print("No saved game found. Starting a new game.")
        io.write("Enter your bird's name: ")
        local name = io.read()


        tools.createBird(name)
        track.startRaceCycle()
    end

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
            saveGame()
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

            print("Train which skill?\n0: cancel\n1: speed\n2: running\n3: swimming\n4: flying \n (Each training session costs 1 stamina and reduces happiness by 1) \n (Max skill is 10 per each category)")
            io.write("> ")
            local skillInput = io.read()

            local acted = false -- Track if the player actually spent a turn

            if skillInput == "1" then
                tools.train()
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
            else
                print("Invalid skill choice.")
            end

            -- Only advance the game if the player actually trained
            if acted then 
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
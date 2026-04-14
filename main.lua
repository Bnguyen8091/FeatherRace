local tools = require("stats")
local track = require("race")
local shop = require("shop")
local json = require("json")

local function saveGame()
    local success, saveDataTable = pcall(function()
        return {
            bird = tools.getBird(),
            race = track.getRaceData(),
            purchases = shop.getPurchases()
        }
    end)

    if not success then
        print("Failed to gather save data: " .. tostring(saveDataTable))
        return
    end

    local saveData = json.encode(saveDataTable)
    local file, err = io.open("savegame.json", "w")

    if file then
        file:write(saveData)
        file:close()
        print("Game saved successfully.")
    else
        print("Error saving game: " .. tostring(err))
    end
end

local function loadGame()
    local file, err = io.open("savegame.json", "r")
    if not file then
        print("No save file found or unable to read: " .. tostring(err))
        return false
    end

    local contents = file:read("*a")
    file:close()

    local success, saveData = pcall(json.decode, contents)

    if success and saveData then
        if saveData.bird then tools.setBird(saveData.bird) end
        if saveData.race then track.setRaceData(saveData.race) end
        if saveData.purchases then shop.setPurchases(saveData.purchases) end

        print("Game loaded successfully.")
        return true
    else
        print("Error decoding save data: " .. tostring(saveData))
        return false
    end
end

local function showCommands()
    print("\nCommands: feed, train, play, rest, stats, shop, help, quit")
end

function main()
    math.randomseed(os.time())
    local running = true

    local gameLoaded = loadGame()

    if gameLoaded then
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
    showCommands()

    local function advanceTime()
        if tools.isGameOver() then
            running = false
            return
        end

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
            advanceTime()

        elseif input == "train" then
            local acted = false

            while true do
                print("Train which skill?")
                print("0: back")
                print("1: speed")
                print("2: running")
                print("3: swimming")
                print("4: flying")
                print("(Each training session costs 1 stamina and reduces happiness by 1)")
                print("(Max skill is 10 per category)")
                io.write("> ")

                local skillInput = io.read()

                if skillInput == "1" then
                    tools.trainSpeed()
                    acted = true
                    break
                elseif skillInput == "2" then
                    tools.trainRunning()
                    acted = true
                    break
                elseif skillInput == "3" then
                    tools.trainSwimming()
                    acted = true
                    break
                elseif skillInput == "4" then
                    tools.trainFlying()
                    acted = true
                    break
                elseif skillInput == "0" then
                    print("Returning to main menu.")
                    break
                else
                    print("Invalid skill choice.")
                end
            end

            if acted then
                advanceTime()
            end

        elseif input == "play" then
            tools.play()
            advanceTime()

        elseif input == "rest" then
            tools.rest()
            advanceTime()

        elseif input == "shop" then
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
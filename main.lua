local tools = require("stats")
local track = require("race")
local shop = require("shop")
local json = require("json")
local trainer = require("trainer")

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

    local saveData = json.encode(Save)
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
        return nil
    end

    local contents = file:read("*a")
    file:close()

    local status, Save = pcall(json.decode, contents)
    
    if status and Save then
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

    local game = loadGame()

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

    local function showCommands()
        print("\nCommands: feed, train, play, rest, stats, shop, rate, help, quit")
    end

    showCommands()

    local function advanceTime()
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

            while not acted do
                print("Train which skill?")
                print("0: back")
                print("1: speed")
                print("2: running")
                print("3: swimming")
                print("4: flying")
                print("(Each training session costs 1 stamina and reduces happiness by 1)")
                print("(Max skill is 10 per each category)")
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

        elseif input == "rate" then
            trainer.rateDuck(tools.getBird(), track.getRaceData())

        elseif input == "help" then
            showCommands()

        else
            print("Unknown command.")
            showCommands()
        end
    end
end

main()
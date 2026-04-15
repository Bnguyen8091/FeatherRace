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
        return false
    end

    local saveData = json.encode(Save)
    local file, err = io.open("savegame.json", "w")

    if file then
        file:write(saveData)
        file:close()
        print("Game saved successfully.")
        return true
    else
        print("Error saving game: " .. tostring(err))
        return false
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
        print("Error decoding save data: " .. tostring(Save))
        return false
    end
end

local function deleteSaveFile()
    local success, err = os.remove("savegame.json")

    if success then
        print("Save file deleted.")
    else
        print("No save file to delete, or unable to delete it.")
        if err then
            print("Details: " .. tostring(err))
        end
    end
end

local function waitForContinue(message)
    print("")
    print(message or "Press Enter to continue...")
    io.read()
end

local function showFullHelp()
    print("\n================================")
    print("         COMMAND MENU")
    print("================================")
    print(" feed   - restore a little stamina")
    print(" train  - improve a chosen skill")
    print(" play   - increase happiness")
    print(" rest   - recover stamina")
    print(" stats  - view duck stats")
    print(" shop   - open the shop")
    print(" rate   - ask trainer for win odds")
    print(" help   - show this menu")
    print(" quit   - exit the game")
    print("================================")
end

local function showCompactCommands()
    print("\n================================")
    print("          COMMAND HUD")
    print("================================")
    print(" feed   train   play   rest")
    print(" stats  shop    rate")
    print(" help   quit")
    print("================================")
end

local function startNewGame()
    print("Starting a new game.")
    io.write("Enter your bird's name: ")
    local name = io.read()
    tools.createBird(name)
    track.startRaceCycle()

    waitForContinue("Press Enter to view the upcoming race...")
    track.showRace()

    waitForContinue("Press Enter to view your duck's current stats...")
    tools.showStats()

    waitForContinue("Press Enter to view the command menu...")
    showFullHelp()

    waitForContinue("Press Enter to start playing...")
end

local function showLoadedGameIntro()
    waitForContinue("Press Enter to view the upcoming race...")
    track.showRace()

    waitForContinue("Press Enter to view your duck's current stats...")
    tools.showStats()

    waitForContinue("Press Enter to continue your adventure...")
end

function main()
    math.randomseed(os.time())
    local running = true

    local file = io.open("savegame.json", "r")

    if file then
        file:close()

        local choosing = true
        while choosing do
            print("\n================================")
            print("         FEATHERRACE")
            print("================================")
            print("1: Continue saved game")
            print("2: Start new game")
            print("3: Delete saved game")
            print("================================")
            io.write("> ")

            local choice = io.read()

            if choice == "1" then
                local game = loadGame()
                if game then
                    print("Loaded saved game.")
                    showLoadedGameIntro()
                    choosing = false
                else
                    print("Could not load save.")
                    startNewGame()
                    choosing = false
                end

            elseif choice == "2" then
                startNewGame()
                choosing = false

            elseif choice == "3" then
                deleteSaveFile()

            else
                print("Invalid choice.")
            end
        end
    else
        print("No saved game found.")
        startNewGame()
    end

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

    local function handleQuit()
        while true do
            print("\nSave before quitting? (y/n/c)")
            print("y = save and quit")
            print("n = quit without saving")
            print("c = cancel")
            io.write("> ")

            local choice = io.read()
            choice = choice:lower()

            if choice == "y" then
                saveGame()
                print("Saving and exiting...")
                running = false
                break

            elseif choice == "n" then
                print("Exiting without saving...")
                running = false
                break

            elseif choice == "c" then
                print("Returning to game.")
                break

            else
                print("Invalid choice. Please enter y, n, or c.")
            end
        end
    end

    while running do
        showCompactCommands()
        io.write("> ")
        local input = io.read()

        input = input:match("^%s*(.-)%s*$")

        if input == "quit" then
            handleQuit()

        elseif input == "stats" then
            tools.showStats()
            track.showRaceStatus()

        elseif input == "feed" then
            tools.feed()
            advanceTime()

        elseif input == "train" then
            local acted = false

            while not acted do
                print("\n================================")
                print("         TRAINING MENU")
                print("================================")
                print("0: back")
                print("1: speed")
                print("2: running")
                print("3: swimming")
                print("4: flying")
                print("--------------------------------")
                print("Each session costs 1 stamina")
                print("and reduces happiness by 1")
                print("Max skill per category: 10")
                print("================================")
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

        elseif input == "rate" then
            trainer.rateDuck(tools.getBird(), track.getRaceData())

        elseif input == "help" then
            showFullHelp()

        else
            print("Unknown command.")
        end
    end
end

main()
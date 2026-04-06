local tools = require("stats")
local track = require("race")

function main()
    math.randomseed(os.time())
    local running = true

    io.write("Enter your bird's name: ")
    local name = io.read()

    tools.createBird(name)
    
    track.createRace()
    track.showRace()

    print("\nCommands: feed, train, play, rest, stats, quit")
    tools.showStats()

    while running do
        io.write("> ")
        local input = io.read()

        input = input:match("^%s*(.-)%s*$")

        if input == "quit" then
            print("Exiting...")
            running = false

        elseif input == "stats" then
            tools.showStats()

        elseif input == "feed" then
            tools.feed()
            if tools.isGameOver() then
                running = false
            else
                tools.showStats()
            end

        elseif input == "train" then
            tools.train()
            if tools.isGameOver() then
                running = false
            else
                tools.showStats()
            end

        elseif input == "play" then
            tools.play()
            if tools.isGameOver() then
                running = false
            else
                tools.showStats()
            end

        elseif input == "rest" then
            tools.rest()
            tools.showStats()

        elseif input == "race" then
            track.racing(tools.getBird())
            tools.showStats()

        else
            print("Unknown command.")
        end
    end
end

main()
local tools = require("stats")


function main()
    local running = true

    -- create bird
    io.write("Enter your bird's name: ")
    local name = io.read()
    tools.createBird(name)

    print("\nCommands: stats, feed, train, play, quit\n")

    while running do
        io.write("> ")
        local input = io.read()

        if input == "quit" then
            print("Exiting...")
            running = false

        elseif input == "stats" then
            tools.showStats()

        elseif input == "feed" then
            tools.feed()

        elseif input == "train" then
            tools.train()

        elseif input == "play" then
            tools.play()

        else
            print("Unknown command.")
        end
    end  
end

main()

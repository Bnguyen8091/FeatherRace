local tools = require("stats")

function main()
    local running = true

    io.write("Enter your bird's name: ")
    local name = io.read()
    tools.createBird(name)

    print("\nCommands: stats, feed, train, play, rest, quit\n")

    while running do
        io.write("> ")
        local input = io.read()

        -- trim spaces
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
            end

        elseif input == "train" then
            tools.train()
            if tools.isGameOver() then
                running = false
            end

        elseif input == "play" then
            tools.play()
            if tools.isGameOver() then
                running = false
            end

        elseif input == "rest" then
            tools.rest()
            if tools.isGameOver() then
                running = false
            end

        else
            print("Unknown command.")
        end
    end
end

main()

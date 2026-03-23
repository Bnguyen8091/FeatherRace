
-- run lua main.lua to start the program

local tools = require("stats")

function main()
    local running = true

    io.write("type 'quit' to exit at any time: ")

    while running do

        
        
        local input = io.read()
        
        if input == "quit" then
            print("Exiting...")
            running = false
        
        end
    end  
end

main()
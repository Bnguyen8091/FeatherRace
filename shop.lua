local shop = {}
local stats = require("stats")

-- track purchased items
local purchases = {
    flippers = false,
    jetpack = false,
    shoes = false,

    pool = false,
    fan = false,
    treadmill = false,
    playroom = false,
    bed = false
}




-- helper to format item display
local function itemText(id, name, price, bought)
    if bought then
        return id .. ". [SOLD OUT]: " .. name
    else
        return id .. ". " .. price .. ": " .. name
    end
end


--helper for consumables
function shop.has(key)
    return purchases[key] == true
end

function shop.consume(key)
    purchases[key] = false
end

function shop.openShop()
    local inShop = true

    while inShop do
        print("\n================================")
        print("            SHOP")
        print("================================")
        print("Current Money: " .. stats.getMoney())

        print("\nBoosters (goes away after one race):")
        print(itemText(1, "Flippers - Improves swimming by 1.5x", 100, purchases.flippers))
        print(itemText(2, "Jetpack - Improves flying by 1.5x", 100, purchases.jetpack))
        print(itemText(3, "Running Shoes - Improves running by 1.5x", 100, purchases.shoes))
        print(itemText(4, "Energy Drink - Full stamina restore", 100, purchases.energy))
        print(itemText(5, "Treats - Full happiness restore", 100, purchases.treats))

        print("\nPermanent Training upgrades:")
        print(itemText(6, "Swimming Pool - Swim training x1.1", 200, purchases.pool))
        print(itemText(7, "Giant Fan - Fly training x1.1", 200, purchases.fan))
        print(itemText(8, "Treadmill - Run training x1.1", 200, purchases.treadmill))
        print(itemText(9, "Playroom - Play effectiveness x1.1", 200, purchases.playroom))
        print(itemText(10, "Better Bed - Rest effectiveness +1", 200, purchases.bed))

        print("================================")
        print("Type item number to buy or 'leave'")

        io.write("> ")
        local input = io.read()

        if input == "leave" then
            inShop = false

        else
            local choice = tonumber(input)

            if not choice then
                print("Invalid input.")
            else
                shop.handlePurchase(choice)
            end
        end
    end
end

function shop.handlePurchase(choice)
    local function buy(key, price)
        if purchases[key] then
            print("Already purchased.")
            return
        end

        if stats.spendMoney(price) then
            purchases[key] = true
            print("Purchase successful!")
        else
            print("Not enough money.")
        end
    end

    --boosters
    if choice == 1 then buy("flippers", 100)
    elseif choice == 2 then buy("jetpack", 100)
    elseif choice == 3 then buy("shoes", 100)
    
    --
    elseif choice == 4 then
    if stats.getBird().stamina >= 10 then
        print("Stamina already full.")
        return
    end
    if stats.spendMoney(100) then
        stats.getBird().stamina = 10
        print("Energy fully restored!")
    end

    elseif choice == 5 then
    if stats.getBird().happiness >= 10 then
        print("Happiness already full.")
        return
    end
    if stats.spendMoney(100) then
        stats.getBird().happiness = 10
        print("Happiness fully restored!")
    end

    elseif choice == 6 then buy("pool", 200)
    elseif choice == 7 then buy("fan", 200)
    elseif choice == 8 then buy("treadmill", 200)
    elseif choice == 9 then buy("playroom", 200)
    elseif choice == 10 then buy("bed", 200)

    else
        print("Invalid item.")
    end
end

-- expose purchase data (for later use)
function shop.getPurchases()
    return purchases
end

-- Add this to shop.lua so the loadGame function can push data back in
function shop.setPurchases(data)
    for k, v in pairs(data) do
        purchases[k] = v
    end
end

return shop
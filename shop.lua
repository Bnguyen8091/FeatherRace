local shop = {}
local stats = require("stats")

local BOOSTER_PRICE = 25
local RESTORE_PRICE = 20
local UPGRADE_PRICE = 50

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

local function itemText(id, name, price, bought)
    if bought then
        return id .. ". [SOLD OUT]: " .. name
    else
        return id .. ". " .. price .. " coins: " .. name
    end
end

local function consumableText(id, name, price)
    return id .. ". " .. price .. " coins: " .. name
end

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
        print("Current Coins: " .. stats.getMoney())

        print("\nBoosters (goes away after one race):")
        print(itemText(1, "Flippers - Improves swimming by 1.5x", BOOSTER_PRICE, purchases.flippers))
        print(itemText(2, "Jetpack - Improves flying by 1.5x", BOOSTER_PRICE, purchases.jetpack))
        print(itemText(3, "Running Shoes - Improves running by 1.5x", BOOSTER_PRICE, purchases.shoes))
        print(consumableText(4, "Energy Drink - Full stamina restore", RESTORE_PRICE))
        print(consumableText(5, "Treats - Full happiness restore", RESTORE_PRICE))

        print("\nPermanent Training upgrades:")
        print(itemText(6, "Swimming Pool - Swim training x1.1", UPGRADE_PRICE, purchases.pool))
        print(itemText(7, "Giant Fan - Fly training x1.1", UPGRADE_PRICE, purchases.fan))
        print(itemText(8, "Treadmill - Run training x1.1", UPGRADE_PRICE, purchases.treadmill))
        print(itemText(9, "Playroom - Play effectiveness x1.1", UPGRADE_PRICE, purchases.playroom))
        print(itemText(10, "Better Bed - Rest effectiveness +1", UPGRADE_PRICE, purchases.bed))

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

    if choice == 1 then
        buy("flippers", BOOSTER_PRICE)

    elseif choice == 2 then
        buy("jetpack", BOOSTER_PRICE)

    elseif choice == 3 then
        buy("shoes", BOOSTER_PRICE)

    elseif choice == 4 then
        local bird = stats.getBird()
        if bird.stamina >= 10 then
            print("Stamina already full.")
            return
        end

        if stats.spendMoney(RESTORE_PRICE) then
            bird.stamina = 10
            print("Energy fully restored!")
        else
            print("Not enough money.")
        end

    elseif choice == 5 then
        local bird = stats.getBird()
        if bird.happiness >= 10 then
            print("Happiness already full.")
            return
        end

        if stats.spendMoney(RESTORE_PRICE) then
            bird.happiness = 10
            print("Happiness fully restored!")
        else
            print("Not enough money.")
        end

    elseif choice == 6 then
        buy("pool", UPGRADE_PRICE)

    elseif choice == 7 then
        buy("fan", UPGRADE_PRICE)

    elseif choice == 8 then
        buy("treadmill", UPGRADE_PRICE)

    elseif choice == 9 then
        buy("playroom", UPGRADE_PRICE)

    elseif choice == 10 then
        buy("bed", UPGRADE_PRICE)

    else
        print("Invalid item.")
    end
end

function shop.getPurchases()
    return purchases
end

function shop.setPurchases(data)
    for k, v in pairs(data) do
        purchases[k] = v
    end
end

return shop
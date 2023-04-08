--[[
    plethoraInventoryManager aka PIM
    by toastonryeYT on Youtube

    Learning excersize, made with Plethora and CC:Tweaked Computercraft mods
    In Minecraft 1.12.2, Enigmatica 2: Expert - Extended modpack
--]]

-- =====================================================================================================
-- ====== THIS SHOULD BE THE ONLY PLACE USERS OF THIS SCRIPT NEED TO MAKE CHANGES ======================
-- =====================================================================================================

--DUMP_INVENTORY_NAME = "engineersdecor:te_labeled_crate" -- set this to the name of your inventory of choice
DUMP_INVENTORY_NAME = "ironchest:iron_chest"

-- ====== END ==========================================================================================

local lib = require("libPIM")
local manip -- the manipulator from plethora
local dumpInventory -- holds the side of the configured DUMP_INVENTORY_NAME, i.e. "TOP"
local codeBackpack

local function generateCode() -- used to verify player truly wants to dump all and backpack removed
    codeBackpack = math.random(100,999)
    return codeBackpack
end

local function inventoryDump(s)
    if s == "all" then
        manip.tell("Dumping inventory \"all\"")

        local playerInv = manip.getInventory()
        local list = playerInv.list()
        for slot, item in pairs(list) do
            print(slot, item.name)
            playerInv.pushItems(dumpInventory, slot)
        end

        local playerEquip = manip.getEquipment()
        local list = playerEquip.list()
        for slot, item in pairs(list) do
            print(slot, item.name)
            playerEquip.pushItems(dumpInventory, slot)
        end

        --[[local playerEnder = manip.getEnder()
        local list = playerEnder.list()
        for slot, item in pairs(list) do
            print(slot, item.name)
            playerEnder.pushItems(dumpInventory, slot)
        end--]]

        local playerBaubles = manip.getBaubles()
        local list = playerBaubles.list()
        for slot, item in pairs(list) do
            print(slot, item.name)
            playerBaubles.pushItems(dumpInventory, slot)
        end
    end
    if s == "2rows" then
        manip.tell("Dumping inventory 2 top rows")

        local playerInv = manip.getInventory()
        local list = playerInv.list()
        for i=10, 27, 1 do
            print(i, list.name)
            playerInv.pushItems(dumpInventory, i)
        end
    end
end

local function initPeripherals()
    local myPeripherals = {}

    -- populates table myPeripherals{} of what is currently seen by the computer. A manipulator with no modules is not detected..?
    shell.run("clear")
    print("Initializing list of connected peripherals!")
    for k, side in pairs(peripheral.getNames()) do
        myPeripherals[k] = {side = side, type = peripheral.getType(side)}
    end
    lib.printPeripherals(myPeripherals)
    for k, v in pairs(myPeripherals) do
        -- configure plethora manipulator. NOTE: manipulator seems to only be detected if a sensor module is installed..?
        if v.type == "manipulator" then
            manip = peripheral.find("manipulator") -- strange bug where manipulator isn't always found at position "TOP"
        end

        -- configure general inventories
        if v.type == DUMP_INVENTORY_NAME then
            --dumpInventory = peripheral.find(DUMP_INVENTORY_NAME)
            dumpInventory = v.side -- try setting crate to the location text, i.e. "TOP"
        end
    end
end

local function peripheralAdd()
    while true do
        local pAdd = {os.pullEvent("peripheral")}
        -- code below only runs if the "filtered" event above fires
        print("Peripheral was added.")
        initPeripherals()
    end
end

local function peripheralRemove()
    while true do
        local pRemove = {os.pullEvent("peripheral_detach")}
        -- code below only runs if the "filtered" event above fires
        print("Peripheral was removed.")
        initPeripherals()
    end
end

local function chatListener()
    local codeFlag = false
    local dumpARGS
    while true do
        local _, player, msg, uuid = os.pullEvent("chat_message")
        -- code below only runs if the "filtered" event above fires
        if manip then
            if not manip.hasModule("plethora:chat") then -- this check doesn't seem to be necessary. event chat_message only exists if module is installed..?
                print("plethora:chat module not installed! It seems like you are trying to use it.")
            end
            if player == "toastonrye" and msg == "dump all" then
                manip.tell("Is your backpack removed? Enter code to verify: " .. generateCode())
                codeFlag = true
                dumpARGS = "all"
            elseif player == "toastonrye" and msg == tostring(codeBackpack) and codeFlag and dumpARGS == "all" then
                manip.tell("Correct code entered!")
                inventoryDump("all")
                codeFlag = false
                codeBackpack = nil
            elseif player == "toastonrye" and msg ~= tostring(codeBackpack) and codeFlag then
                if msg == "cancel" then
                    manip.tell("Cancelled: dump all")
                    codeFlag = false
                    codeBackpack = nil
                else
                    manip.tell("Invalid code entered. Try again! Or type cancel.")
                end
            end

            if player == "toastonrye" and msg == "dump 2" then
                manip.tell("Is your backpack removed? Enter code to verify: " .. generateCode())
                codeFlag = true
                dumpARGS = "2rows"
            elseif player == "toastonrye" and msg == tostring(codeBackpack) and codeFlag and dumpARGS == "2rows" then
                manip.tell("Correct code entered!")
                inventoryDump("2rows")
                codeFlag = false
                codeBackpack = nil
            elseif player == "toastonrye" and msg ~= tostring(codeBackpack) and codeFlag then
                if msg == "cancel" then
                    manip.tell("Cancelled: dump 2")
                    codeFlag = false
                    codeBackpack = nil
                else
                    manip.tell("Invalid code entered. Try again! Or type cancel.")
                end
            end

        else
            print("The manipulator was not detected?")
            print(manip)
        end
    end
end

local function plethoraInventoryManager()
    initPeripherals() -- runs once, when script starts
    while true do
        sleep(2)
    end
end

-- parallel is a simple way to run several functions at once. See https://tweaked.cc/module/parallel.html
parallel.waitForAll(plethoraInventoryManager, peripheralAdd, peripheralRemove, chatListener)
--[[
    parallel is interesting, how it yields...
    sleep() yields to the other functions
    os.pullEvent yields to other functions, code below only runs if the event is detected
]]

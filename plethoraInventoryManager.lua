--[[
    plethoraInventoryManager aka PIM
    by toastonryeYT on Youtube

    Learning excersize, made with Plethora and CC:Tweaked Computercraft mods
    In Minecraft 1.12.2, Enigmatica 2: Expert - Extended modpack
--]]

local lib = require("libPIM")
local myPeripherals = {}
local manip, chatModule
local rtInterface, crate
local codeBackpack
local codeFlag = false

local function generateCode() -- used to verify player truly wants to dump all and backpack removed
    codeBackpack = math.random(100,999)
    return codeBackpack
end

local function inventoryDump(s)
    manip.tell("Inventory Dump function not fully implemented yet!")
    if s == "test" then
        --lib.printBasic(manip.getID())
        --print(manip.getID())
        for k, v in pairs(manip.getInventory()) do
            manip.tell(k, v)
        end
    end
end

local function initPeripherals()
    myPeripherals = {}

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
        else
            manip = nil
        end

        -- configure general inventories
        if v.type == "engineersdecor:te_labeled_crate" then
            crate = peripheral.find("engineersdecor:te_labeled_crate")
        else
            crate = nil
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
    while true do
        local _, player, msg, uuid = os.pullEvent("chat_message")
        -- code below only runs if the "filtered" event above fires
        if manip then
            if not manip.hasModule("plethora:chat") then -- this check doesn't seem to be necessary. event chat_message only exists if module is installed..?
                print("plethora:chat module not installed! It seems like you are trying to use it.")
            end
            if player == "toastonrye" and msg == "dump all" then
                manip.tell("Is your backpack removed? Enter code to verify: " .. generateCode())
                print("set code true")
                codeFlag = true
            elseif player == "toastonrye" and msg == tostring(codeBackpack) and codeFlag then
                manip.tell("Correct code entered! Dumping inventory...")
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
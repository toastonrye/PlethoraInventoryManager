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
    manip.tell("inventoryDump function not implemented yet")
end

local function initPeripherals()
    myPeripherals = {}

    -- populates table myPeripherals{} of what is currently seen by the computer
    shell.run("clear")
    print("Initializing list of connected peripherals!")
    for k, side in pairs(peripheral.getNames()) do
        myPeripherals[k] = {side = side, type = peripheral.getType(side)}
    end
    lib.printPeripherals(myPeripherals)

    -- assign peripherals to variables if they are detected
    for k, v in pairs(myPeripherals) do
        -- configure plethora manipulator. NOTE: manipulator seems to only be detected if a sensor module is installed..?
        if v.type == "manipulator" then
            manip = peripheral.find("manipulator")
        else
            manip = nil
        end

        -- configure general inventories
        if v.type == "randomthings:playerinterface" then
            rtInterface = peripheral.find("randomthings:playerinterface")
        else
            rtInterface = nil
        end
        if v.type == "randomthings:playerinterface" then
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
            --lib.printBasic(manip.listModules())
            --[[if manip.hasModule("plethora:chat") then -- this check doesn't seem to be necessary. event chat_message only exists if module is installed..?
                manip.tell("Repeating: " .. msg)
            end--]]
            if player == "toastonrye" and msg == "dump all" then
                manip.tell("Is your backpack removed? Enter code to verify: " .. generateCode())
                print("set code true")
                codeFlag = true
            --elseif player == "toastonrye" and msg ~= "dump all" and codeFlag then
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
        end
    end
end

local function plethoraInventoryManager()
    initPeripherals() -- runs once, when script starts
    while true do
        sleep(3)
    end
end

-- parallel is a simple way to run several functions at once. See https://tweaked.cc/module/parallel.html
parallel.waitForAll(plethoraInventoryManager, peripheralAdd, peripheralRemove, chatListener)
--[[
    parallel is interesting, how it yields...
    sleep() yields to the other functions
    os.pullEvent yields to other functions, code below only runs if the event is detected
]]
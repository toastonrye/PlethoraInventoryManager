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
        -- configure plethora manipulator
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
        print("run add")
        initPeripherals()
    end
end

local function peripheralRemove()
    while true do
        local pRemove = {os.pullEvent("peripheral_detach")}
        -- code below only runs if the "filtered" event above fires
        print("run remove")
        initPeripherals()
    end
end

local function chatListener()
    while true do
        local _, player, msg, uuid = os.pullEvent("chat_message")
        if manip then
            --lib.printBasic(manip.listModules())
            if manip.hasModule("plethora:chat") then
                manip.say("Repeating: " .. msg)
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
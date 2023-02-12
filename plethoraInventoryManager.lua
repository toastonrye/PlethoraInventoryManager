--[[
    plethoraInventoryManager aka PIM
    by toastonryeYT on Youtube

    Learning excersize, made with Plethora and CC:Tweaked Computercraft mods
    In Minecraft 1.12.2, Enigmatica 2: Expert - Extended modpack
--]]

local lib = require("libPIM")
local myPeripherals = {}
local manip, chatModule

local function initPeripherals()
    myPeripherals = {}

    -- populates table myPeripherals{} of what is currently seen by the computer
    print("Initializing list of connected peripherals!")
    for k, side in pairs(peripheral.getNames()) do
        myPeripherals[k] = {side = side, type = peripheral.getType(side)}
    end
    lib.printPeripherals(myPeripherals)

    -- assign peripherals to variables if they are detected
    for k, v in pairs(myPeripherals) do
        if v.type == "manipulator" then
            manip = peripheral.find("manipulator")
        else
            manip = nil
        end
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
        local pAdd = {os.pullEvent("peripheral")} -- pAdd not used, this event just runs the rest of the code below...?
        initPeripherals()
    end
end

local function peripheralRemove()
    while true do
        local pRemove = {os.pullEvent("peripheral_detach")}
        initPeripherals()
    end
end

local function plethoraInventoryManager()
    initPeripherals() -- this should run once and only once!? Yes...
    while true do
        sleep(2)
        --[[if manip then
            lib.printBasic(manip.listModules())
        else
            print("manip not found")
        end--]]
    end
end

--[[
SIDE_PLAYERINTERFACE = "back"
SIDE_INVENTORY = "right"



print(crate.getNames)
crate.pullItems("back", 1)--]]

--[[for k,v in pairs(peripheral.getNames()) do
    print(k,v)
end--]]

parallel.waitForAll(plethoraInventoryManager, peripheralAdd, peripheralRemove)
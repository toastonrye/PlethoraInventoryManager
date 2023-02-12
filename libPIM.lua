-- libPIM.lua
-- made when learning cc:tweaked in 1.12.2 E2:E - Extended

local function printBasic(p)
    for k, v in pairs(p) do
        print(k,v)
    end
end

local function printPeripherals(p)
    for k, v in pairs(p) do
        print(k, v.side, v.type)
    end
end

return {printBasic = printBasic, printPeripherals = printPeripherals}

manip = peripheral.find("manipulator")
baub = manip.getBaubles()
item = baub.list()
for k, v in pairs(item) do
    --print(k,v)
    for k2, v2 in pairs(v) do
        print(k2, v2)
    end
end


--[[
local intro = peripheral.wrap("left")
local inv = intro.getInventory()
local item = inv.list()
for k, v in pairs(item) do
    print(k, v.name)
end
--]]
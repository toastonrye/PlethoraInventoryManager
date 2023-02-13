--manip = peripheral.find("manipulator")
--for k, v in pairs(manip) do
--    print(k, v)
--end

local intro = peripheral.wrap("left")
local inv = intro.getInventory()
local item = inv.list()
for k, v in pairs(item) do
    print(k, v.name)
end
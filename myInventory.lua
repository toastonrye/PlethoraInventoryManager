local introspection = peripheral.find("manipulator")
if not introspection then error("introspection module not detected") end

local myHealth

--[[
local myInv = introspection.getInventory()
local item = myInv.getDocs()
print(item)
for k, v in pairs(myInv) do
    print(k,v)
end
--]]

local function health()
    while true do
        local sen = introspection.getMetaByName("toastonrye")
        
        myHealth = sen.health/sen.maxHealth

        if not sen then
            myHealth = "too far"
        end
        sleep(1)
    end
end

local function chat()
    while true do
        introspection.tell(tostring(myHealth))
        sleep(1)
    end
end



parallel.waitForAll(health, chat)
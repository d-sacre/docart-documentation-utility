local dateString = os.date("%Y-%m-%d")
local timeString = os.date("%I:%M:%S %p")
local preString = "Hello World, the date is "
local ostring = preString .. dateString .. ", the time is " .. timeString .. "."

print(ostring)
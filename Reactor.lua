local component = require("component")
local event = require("event")
local fs = require("filesystem")
local keyboard = require("keyboard")
local shell = require("shell")
local term = require("term")
local text = require("text")
local unicode = require("unicode")
local sides = require("sides")
local colors=require("colors")

local gpu=component.gpu
local br = component.br_reactor
local rs = component.redstone

local rods = br.getNumberOfControlRods()
local energy = 0
local runmode = true
local setrod = 0
local energyrod = 0
----

function getKey()
	return (select(4, event.pull("key_down")))
end

local function KeyPress(opt)
	if opt == keyboard.keys.q then
    runmode = false
  end
end

local function printXY(row, col,  ...)
term.setCursor(col, row)
print((...))
end

----


while runmode do 
term.clear()
setrod = 0
energy = br.getEnergyStored() / 100000
printXY(1, 1, "Reactor State")
printXY(2, 1, "Reactor Charge Level          %")
printXY(3, 1, "Control Rod Level             %")
printXY(4, 1, "Fuel Level                    mB")
printXY(5, 1, "Waste Level                   mB")
printXY(6, 1, "Fuel Cap                      mB")

printXY(8, 1, "Energy Output                 RF")

printXY(10, 1, "Coolant Type")
printXY(11, 1, "Coolant Level                 mB")
printXY(12, 1, "Coolant Level Max             mB")


if ((br.getActive()) == true) then
printXY(1, 25, "Online")
energyrod = math.abs (math.ceil (energy * rods))
while (setrod < (rods - 1)) do
  if (energyrod - (100 * (setrod + 1)) > 99) then
    br.setControlRodLevel(setrod,100)
  elseif (energyrod - ((100 * (setrod)) + 100) > 1) then
    br.setControlRodLevel(setrod,(energyrod - ((100 * (setrod)+100))))
  else
    br.setControlRodLevel(setrod,0)
  end
  setrod = (setrod + 1) 
end
else
printXY(1, 25, "Offline")

end

printXY(2, 25, math.floor (energy))
printXY(3, 25, math.floor ((energyrod / rods)))
printXY(4, 25, math.floor (br.getFuelAmount()))
printXY(5, 25, math.floor (br.getWasteAmount()))
printXY(6, 25, math.floor (br.getFuelAmountMax()))

printXY(8, 25, math.floor (br.getEnergyProducedLastTick()))

printXY(10, 25,(br.getCoolantType()))
printXY(11, 25, math.floor (br.getCoolantAmount()))
printXY(12, 25, math.floor (br.getCoolantAmountMax()))

if ((br.getEnergyStored() / 100000) > 95) then
	br.setActive(false)
printXY(1, 25, "Online")
elseif ((br.getEnergyStored() / 100000) < 10) then
	br.setActive(true)
printXY(1, 25, "Offline")

end



  local event, address, arg1, arg2, arg3 = event.pull(1)
  if type(address) == "string" and component.isPrimary(address) then
    if event == "key_down" then
      KeyPress(arg2)
    end
  end

end

term.clear()
term.setCursorBlink(false)
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
energyrod = math.abs (math.ceil (energy * rods))
	printXY(1, 1, energy)
	printXY(2, 1, energyrod)

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

  local event, address, arg1, arg2, arg3 = event.pull(1)
  if type(address) == "string" and component.isPrimary(address) then
    if event == "key_down" then
      KeyPress(arg2)
    end
  end

end

term.clear()
term.setCursorBlink(false)
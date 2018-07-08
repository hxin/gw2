-----------------------
function p (string)
         print(string)
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
---------

-----------------------
function isEmpty(s)
  return s == nil or s == ''
end
---------

-----------------------
function sleep(s)
  local ntime = os.clock() + s
  repeat until os.clock() > ntime
end

-----------------------
function dumpTable(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dumpTable(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
---------

-----------------------
function toHex (number_string)
         return string.format('%X', number_string)
end
---------

-----------------------
function toNumber (hex_string)
         return tonumber(hex_string,16)
end
---------

-----------------------
function addHex (hex1_string, hex2_string)
         local sumNumber = toNumber(hex1_string) + toNumber(hex2_string)
         return toHex(sumNumber)
end
---------

-----------------------
function moveMe (x,y,z)
         if not isEmpty(x) and not isEmpty(y) and not isEmpty(z) then
           local x_record = addressList.getMemoryRecordByDescription('X')
           local y_record = addressList.getMemoryRecordByDescription('Y')
           local z_record = addressList.getMemoryRecordByDescription('Z')
           x_record.value = x
           y_record.value = y
           z_record.value = z
         end
end
---------

function getCordFromXAddess (address_X)
         local cord = {}
         cord['x'] = readFloat(address_X)
         cord['y'] = readFloat(addHex(address_X,toHex(4)))
         cord['z'] = readFloat(addHex(address_X,toHex(8)))
         return cord
end


-----------------------
function moveMeByDesAddress (address_X)
         local cord = getCordFromXAddess (address_X)
         moveMe(cord['x'], cord['y'], cord['z'])
end
---------

function getMyCord ()
         local cord = {}
         cord['x'] = addressList.getMemoryRecordByDescription('X').value
         cord['y'] = addressList.getMemoryRecordByDescription('Y').value
         cord['z'] = addressList.getMemoryRecordByDescription('Z').value
         return cord
end


function getEnvList ()
         local size = readInteger('arr_size')
         local envListAddress = toHex(getAddress('arr'))
         local envList = {}

         for i=0,size,1 do
             envList[i]=toHex(readInteger(addHex(envListAddress,toHex(4*i))))
         end
         return envList
end

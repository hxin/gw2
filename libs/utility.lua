addressList = getAddressList()


-----------------------
function p (string)
         print(string)
end

function pd(table)
         p(dumpTable(table))
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function split(str,sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   str:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function addToSet(set, key)
    set[key] = true
end

function removeFromSet(set, key)
    set[key] = nil
end

function setContains(set, key)
    return set[key] ~= nil
end


function isEmpty(s)
  return s == nil or s == ''
end

function sleep(s)
  local ntime = os.clock() + s
  repeat until os.clock() > ntime
end

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


function toHex (number_string)
         return string.format('%X', number_string)
end


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








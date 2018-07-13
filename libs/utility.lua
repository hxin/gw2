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

function tablelength(T)
         local count = 0
         for _ in pairs(T) do count = count + 1 end
         return count
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

         for i=1,size,1 do
             envList[i]=toHex(readInteger(addHex(envListAddress,toHex(4*i))))
         end
         return envList
end

function getEnvList ()
         local size = readInteger('arr_size')
         local envListAddress = toHex(getAddress('arr'))
         local envList = {}

         for i=1,size,1 do
             local add = toHex(readInteger(addHex(envListAddress,toHex(4*i))))
              if isResourceNode(add) then
                   envList[i]=toHex(readInteger(addHex(envListAddress,toHex(4*i))))
              end
         end
         return envList
end

function isResourceNode(add)
         local keys ={}
         keys[IDENTIFIER['mine']]=true
         keys[IDENTIFIER['tree']]=true
         --keys[IDENTIFIER['herb']]=true
         check1=toHex(readInteger(addHex(add,'A0')))
         return readFloat(add) == 1 and readFloat(addHex(add,'28'))==1 and readInteger(addHex(add,'AC'))==1 and keys[check1]
end

function readINI( fileName )
         local LIP = require 'libs.LIP';
         return LIP.load(fileName);
end

function saveINI( fileName, data )
         local LIP = require 'libs.LIP';
         LIP.save( fileName , data);
end

function readMapID()
         return readINI('locations/maps.ini')['mapid']
end

function readMapCords(map_name)
         return readINI('locations/'..map_name..'.ini')
end

function saveResNodeCord( map_id )
         if map_id == nil then map_id=currentResNodeFileID end

         local tb_map_id = readMapID()
         local fileName = 'locations/'..tb_map_id[map_id]..'.ini'


         local resources = getEnvList()
         local tb_new = {}
		 for i,add in pairs(resources) do
			local xyz = getCordFromXAddess( addHex(add,'30') )
			local rtype = 'unknown'
			for k,v in pairs(IDENTIFIER) do
				if v == toHex(readInteger(addHex(add,'A0'))) then
				   rtype = k
				   break
				end
			end
			local index = rtype..','..round(xyz['x'],1)..','..round(xyz['y'],1)..','..round(xyz['z'],1)
			tb_new[index]={t=rtype,x=xyz['x'],y=xyz['y'],z=xyz['z'],map=map_id}
         end


         local tb = readINI(fileName)
		 local keys = {}
		 for k,v in pairs(tb) do
             addToSet(keys,k)
		 end
         local counter = tablelength(tb)

         for k,v in pairs(tb_new) do
				if not setContains(keys,k) then
                   v['pos'] = v['t']..tostring(counter + 1)
                   counter = counter + 1
				   tb[k] = v
				   addToSet(keys,k)
				end
         end

        saveINI(fileName,tb)
end

function explore()
  if (exploreTimer==nil) then --first time init
    exploreTimer=createTimer(nil,false)

    timer_setInterval(exploreTimer,100) --set value every 100 milliseconds
    timer_onTimer(exploreTimer, CEButtonUpdateListViewClick)
	timer_setEnabled(exploreTimer, true)
  else
	timer_setEnabled(exploreTimer, false) --stop the freezer
	exploreTimer.destroy()
    exploreTimer = nil
  end
end

--not working atm
function autoMove_start ( map_id )
		if (autoMoveTimer==nil) then --first time init
			 if map_id == nil then map_id=currentResNodeFileID end
			 local tb_map_id = readMapID()
			 local fileName = 'locations/'..tb_map_id[map_id]..'.ini'
			 local tb = readINI(fileName)

			 --sort table
			 function getKeysSortedByValue(tbl, sortFunction)
					  local keys = {}
					  for key in pairs(tbl) do
						 table.insert(keys, key)
					  end

					  table.sort(keys, function(a, b) return sortFunction(tbl[a]['t'], tbl[b]['t']) end)
					  return keys
			 end

			 local sortedKeys = getKeysSortedByValue(tb, function(a, b) return a < b end)

			 --add list view items for each cord
			 for _, i in ipairs(sortedKeys) do
				 local cords=tb[i]
				 moveMe(cords['x'],cords['y'],cords['z'])
			 end


			 local movingCounter=1
			 function _move ()
					if movingCounter == tablelength(sortedKeys) then movingCounter=1 end
					local cords=tb[sortedKeys[movingCounter]]
					moveMe(cords['x'],cords['y'],cords['z'])
			 end


			autoMoveTimer=createTimer(nil,false)

			timer_setInterval(autoMoveTimer,1000) --set value every 100 milliseconds
			timer_onTimer(autoMoveTimer, _move)
			timer_setEnabled(autoMoveTimer, true)
	  else
			timer_setEnabled(autoMoveTimer, false) --stop the freezer
			autoMoveTimer.destroy()
	  end
end



function clickToMoveByMapCords()

			local map_id=currentResNodeFileID
			local tb_map_id = readMapID()

			local fileName = 'locations/'..tb_map_id[map_id]..'.ini'
			local tb = readINI(fileName)

			 --sort table
			 function getKeysSortedByValue(tbl, sortFunction)
					  local keys = {}
					  for key in pairs(tbl) do
						 table.insert(keys, key)
					  end

					  table.sort(keys, function(a, b) return sortFunction(tbl[a]['pos'], tbl[b]['pos']) end)
					  return keys
			 end

			local sortedKeys = getKeysSortedByValue(tb, function(a, b) return a < b end)

			if movingCounter == tablelength(sortedKeys) then movingCounter=1 end
			local cords=tb[sortedKeys[movingCounter]]

			moveMe(cords['x'],cords['y'],cords['z'])
            movingCounter = movingCounter + 1
end




-------------------------------
-------------------------------
-----------trainer-------------
-------------------------------
-------------------------------

AboutText=[[GW2 hack]]

form_show(UDF1)
--[[getAutoAttachList().add("doukutsu.exe")]]--


function BtAboutClick(sender)
  showMessage(AboutText)
end

function CBSpeedChange(sender)
         local CheatEntry=addressList.getMemoryRecordByDescription('speed')
         if(checkbox_getState(UDF1.CBSpeed) == 1) then
           CheatEntry.Active=true
         else
           CheatEntry.Active=false
         end
end

function CBFindItemChange(sender)
         local CheatEntry=addressList.getMemoryRecordByDescription('findItemAndSaveToMemArray')
         if(checkbox_getState(UDF1.CBFindItem) == 1) then
           CheatEntry.Active=true
         else
           CheatEntry.Active=false
         end
end

function CEButtonReadCurrentCordClick(sender)
         local myCord = getMyCord()
         setProperty(UDF1.CEEditX,"Text", myCord['x'])
         setProperty(UDF1.CEEditY,"Text", myCord['y'])
         setProperty(UDF1.CEEditZ,"Text", myCord['z'])
end

function CEButtonCEButtonWriteCordClick(sender)
         local toX = getProperty(UDF1.CEEditX,"Text")
         local toY = getProperty(UDF1.CEEditY,"Text")
         local toZ = getProperty(UDF1.CEEditZ,"Text")
         moveMe(toX, toY, toZ)
end


function CEButtonUpdateListViewClick(sender)
         local lv = UDF1.CEListViewItems
         --setProperty(lv, 'ViewStyle', 'vsReport') --non lua exported property but you can access it with this
         --setProperty(lv, 'RowSelect', 'True')
         --setProperty(lv, 'ReadOnly', 'True')
         listview_clear(lv)

         local items = lv.items
         items.clear()
         local envList = getEnvList()
         for i,envAddress in pairs(envList) do

           local item = items:add()
           item.Caption = i
           local row_subitems=listitem_getSubItems(item) --returns a Strings object
           strings_add(row_subitems, envAddress) --addressHex

           local xyz= getCordFromXAddess( addHex(envAddress,'30') )
             --strings_add(row_subitems, table.concat({round(xyz['x'],2),round(xyz['y'],2),round(xyz['z'],2)},", ")) --xyz
           strings_add(row_subitems, table.concat({round(xyz['x'],2),round(xyz['y'],2),round(xyz['z'],2),
           toHex(readInteger(addHex(envAddress,'A0'))),toHex(readInteger(addHex(envAddress,'A8'))),toHex(readInteger(addHex(envAddress,'AC')))},", ")) --xyz
         end

         saveResNodeCord (currentResNodeFileID)
 --[[listitems_getItem(lvitems, x) to get the specific listitem object
 listitem_delete(item) to remove it from the list.]]--
end



function CEListViewItemsClick(sender)
         local lv = UDF1.CEListViewItems
         local itemSelected = lv.getItemIndex()
 p(itemSelected)
         local item = lv.Items[itemSelected]

         --p(item.Caption)
         --p(item.SubItems[0])
         --p(item.SubItems[1])
         moveMeByDesAddress( addHex(item.SubItems[0],'30'))
end



function CEButtonReadFileListClick(sender)
         local lv = UDF1.CEListViewMapName

         local items = lv.items
         items.clear()

         local map_id = readMapID()

         for i,mapName in pairs(map_id) do
           local item = items:add()
           item.Caption = mapName
           local row_subitems=listitem_getSubItems(item) --returns a Strings object
           strings_add(row_subitems, i) --addressHex
         end
end

function CEListViewMapNameClick(sender)
         local lv = UDF1.CEListViewMapName
	     local itemSelected = lv.getItemIndex()
	     local item = lv.Items[itemSelected]

	     --load map cords from ini
	     local map_name = item.Caption
	     local mapCords = readMapCords(map_name)

         lv = UDF1.CEListViewMapCords
         local items = lv.items
         items.clear()

         --sort table
         function getKeysSortedByValue(tbl, sortFunction)
                  local keys = {}
		          for key in pairs(tbl) do
		          	 table.insert(keys, key)
		          end

				  table.sort(keys, function(a, b) return sortFunction(tbl[a]['pos'], tbl[b]['pos']) end)
                  return keys
         end
         local sortedKeys = getKeysSortedByValue(mapCords, function(a, b) return a < b end)

         --add list view items for each cord
         for _, i in ipairs(sortedKeys) do
             local item = items:add()
             item.Caption = i
             local v=mapCords[i]
             local row_subitems=listitem_getSubItems(item) --returns a Strings object
             strings_add(row_subitems, table.concat({v['map'],v['pos'],round(v['x'],2),round(v['y'],2),round(v['z'],2)},", ")) --addressHex
         end
end



function CEListViewMapCordsClick(sender)
         local lv = UDF1.CEListViewMapCords
	     local itemSelected = lv.getItemIndex()
	     local item = lv.Items[itemSelected]

         local cord_name = item.Caption
         local meta = split(item.SubItems[0],',')
         local map_id = meta[1]



         local mapCords = readMapCords(readMapID()[tonumber(map_id)])
         moveMe(mapCords[cord_name]['x'],mapCords[cord_name]['y'],mapCords[cord_name]['z'])
end


function CECheckboxAutoUpdateChange(sender)
         explore()
end

function CECheckboxAutoMoveChange(sender)
        if (autoMoveTimer==nil) then --first time init
          autoMoveTimer=createTimer(nil,false)

          timer_setInterval(autoMoveTimer,1000) --set value every 100 milliseconds
          timer_onTimer(autoMoveTimer, clickToMoveByMapCords)
	      timer_setEnabled(autoMoveTimer, true)
        else
	      timer_setEnabled(autoMoveTimer, false) --stop the freezer
	      autoMoveTimer.destroy()
          autoMoveTimer = nil
        end
end
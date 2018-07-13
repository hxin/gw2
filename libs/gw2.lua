form_show(GW2)

function updatePlayStat()
         GW2.CELabel_cord.Caption = Player().getCord().toString()
         GW2.CELabel_speed.Caption = Player().getSpeed()
         GW2.CELabel_map_id.Caption = Map().getCurrentMapID()
         
end

function updateListViewNodesFromMap()
           local lv = GW2.CEListView_nodes
           listview_clear(lv)

           local items = lv.items
           items.clear()
           
           local nodes = Map().getCurrentMapNodes()
          
           for i,node in pairs(nodes) do

           local item = items:add()
           item.Caption = i
           local row_subitems=listitem_getSubItems(item) --returns a Strings object
           strings_add(row_subitems, node.toString()) --addressHex      
         end
end



----------------------

function CEToggleBox_activateChange(sender)
         if (PlayerStatUpdateTimer==nil) then --first time init
          PlayerStatUpdateTimer=createTimer(nil,false)

          timer_setInterval(PlayerStatUpdateTimer,300) --set value every 100 milliseconds
          timer_onTimer(PlayerStatUpdateTimer, updatePlayStat)
	      timer_setEnabled(PlayerStatUpdateTimer, true)
        else
	      timer_setEnabled(PlayerStatUpdateTimer, false) --stop the freezer
	      PlayerStatUpdateTimer.destroy()
          PlayerStatUpdateTimer = nil
        end
end


function CEButton_listCurrentMapNodesClick(sender)
      updateListViewNodesFromMap()
end



function CEListView_nodesClick(sender)
         local lv = GW2.CEListView_nodes
         local itemSelected = lv.getItemIndex()
         local item = lv.Items[itemSelected]
         local node = Map().getCurrentMapNodes()[item.Caption]
         Player().move(node.getX(), node.getY(), node.getZ())
         --p(item.Caption)
         --p(item.SubItems[0])
         --p(item.SubItems[1])
end
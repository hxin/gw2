form_show(GW2)

visited={}

function findBaseAdd()
    if (playerBaseAddTimer == nil) then --first time init
        playerBaseAddTimer = createTimer(nil, false)

        timer_setInterval(playerBaseAddTimer, 1000) --set value every 100 milliseconds
        playerBaseAddTimer.OnTimer = function()
          
          local flag = readInteger("[Gw2.exe+019D2A60]+34")
          if(flag ~= nil) then 
            --speed
            unregisterSymbol('playerBase')
            registerSymbol('playerBase', toHex(getAddress("[Gw2.exe+019D2A60]+34")) )
            --mapid
            unregisterSymbol('mapIDBase')
            registerSymbol('mapIDBase', toHex(getAddress("[Gw2.exe+000A7E20]+40")))
            
          end
        end
        timer_setEnabled(playerBaseAddTimer, true)
        
        addressList.getMemoryRecordByDescription('speed').Active=true
        addressList.getMemoryRecordByDescription('speed').value=25
    else
        timer_setEnabled(playerBaseAddTimer, false) --stop the freezer
        playerBaseAddTimer.destroy()
        playerBaseAddTimer = nil
    end    
    --pd(toHex(getAddress('playerBase')))
end



function updatePlayStat()
    
   if addressList.getMemoryRecordByDescription('X').value ~= '??' then
      GW2.CELabel_cord.Caption = Player().getCord().toString()
      GW2.CELabel_speed.Caption = Player().getSpeed()
      GW2.CELabel_grv.Caption = Player().getGrv()
      GW2.CELabel_map_id.Caption = Map().getCurrentMapID()
      if addressList.getMemoryRecordByDescription('findResourceNode').Active == true then
        addNodesToMapFile()
      end
    end
  end

function updateListViewNodesFromMap(resource)
  
    GW2.CECheckbox_detectNearResNode.Checked = true
  
    local lv = GW2.CEListView_nodes
    listview_clear(lv)

    local items = lv.items
    items.clear()

    local nodes = Map().getCurrentMapNodes(resource)

    keys = utilityTable().sortedKeys(nodes)
    for _, k in ipairs(keys) do
        n = nodes[k]
        local item = items:add()
        item.Caption = k
        local row_subitems = listitem_getSubItems(item) --returns a Strings object
        strings_add(row_subitems, n.toString()) --addressHex
    end
end

function addNodesToMapFile()
    local nodes = Map().getCurrentMapNodes(true)
    local newNodes = NodeManager().getNodesFromResourceNodeArray()
    Map().saveResNodesToMapFile(utilityTable().merge(nodes, newNodes))
end

function moveToNextNode()
    if nodeCounter == nil then nodeCounter = 1 end
    local nodes = Map().getCurrentMapNodes()
    local nodesvalues = utilityTable().values(nodes)
    local nodekeys = utilityTable().sortedKeys(nodes)

    GW2.CELabel_currentNodeInfo.Caption = nodekeys[nodeCounter]
    GW2.CELabel_node_counter.Caption = nodeCounter

    Player().moveToNode(nodes[nodekeys[nodeCounter]])
    
    nodeCounter = nodeCounter + 1
    if nodeCounter > utilityTable().length(nodekeys) then nodeCounter = 1 end
end


function moveToPreviousNode()
    if nodeCounter == nil then nodeCounter = 1 end
    local nodes = Map().getCurrentMapNodes()
    local nodesvalues = utilityTable().values(nodes)
    local nodekeys = utilityTable().sortedKeys(nodes)


    GW2.CELabel_currentNodeInfo.Caption = nodekeys[nodeCounter]
    GW2.CELabel_node_counter.Caption = nodeCounter

    Player().moveToNode(nodes[nodekeys[nodeCounter]])

    nodeCounter = nodeCounter - 1

    if nodeCounter < 1 then nodeCounter = utilityTable().length(nodekeys) end
end

function moveToNextResNode()
       if moveToNextNearNode(true) == nil then
           if resNodeCounter == nil then resNodeCounter = 1 end
    
           local nodes = Map().getCurrentMapNodes(true)
           local nodesvalues = utilityTable().values(nodes)
           local nodekeys = utilityTable().sortedKeys(nodes)
           if resNodeCounter > utilityTable().length(nodekeys) then resNodeCounter = 1 end
           Player().moveToNode(nodes[nodekeys[resNodeCounter]])
           GW2.CELabel_currentNodeInfo.Caption = nodekeys[resNodeCounter]
           GW2.CELabel_node_counter.Caption = resNodeCounter
           resNodeCounter = resNodeCounter + 1
           
       end
       
    --end
end


function moveToPreviousResNode()
    if resNodeCounter == nil then resNodeCounter = 1 end
    local nodes = Map().getCurrentMapNodes(true)
    local nodesvalues = utilityTable().values(nodes)
    local nodekeys = utilityTable().sortedKeys(nodes)


    GW2.CELabel_currentNodeInfo.Caption = nodekeys[resNodeCounter]
    GW2.CELabel_node_counter.Caption = resNodeCounter

    Player().moveToNode(nodes[nodekeys[resNodeCounter]])

    nodeCounter = nodeCounter - 1

    if resNodeCounter < 1 then resNodeCounter = utilityTable().length(nodekeys) end
end

function moveToNextNearNode(resource)
    if nearNodeCounter == nil then nearNodeCounter = 1 end
    
--    local nodes = NodeManager().getNodesFromResourceNodeArray()
--    if utilityTable().length(nodes) ~= 0 then
--       Player().moveToNode(nodes[utilityTable().keys(nodes)[1]])
--       toggleFindNodes()
--    else
       local nearNodes
       if resource then 
          nearNodes = NodeManager().getNodesFromResourceNodeArray()
       else
          nearNodes = NodeManager().getNodesFromAllNodeArray()
       end
       
       
       local nodes = {}
       for k,v in pairs(nearNodes) do
           if utilityTable().indexof(visited,k) == nil then
             nodes[k]=v
            end
       end
       
       local nodesvalues = utilityTable().values(nodes)
       local nodekeys = utilityTable().sortedKeys(nodes)
       

       if nearNodeCounter >= utilityTable().length(nodekeys) then nearNodeCounter = 1 end
       if utilityTable().length(nodekeys) > 0 then
           Player().moveToNode(nodes[nodekeys[nearNodeCounter]])
           table.insert(visited,nodekeys[nearNodeCounter])
  
           GW2.CELabel_currentNodeInfo.Caption = nodekeys[nearNodeCounter]
           GW2.CELabel_node_counter.Caption = nearNodeCounter
           nearNodeCounter = nearNodeCounter + 1
           return true
       else
          return nil
       end
       
      
    --end
end




  function updateNearNodesView(resource_only)
      if resource_only == nil then resource_only = false end
        
      local lv = GW2.CEListView_allNodes
      listview_clear(lv)

      local items = lv.items
      items.clear()
      
      local nodes
      if(resource_only) then
        nodes = NodeManager().getNodesFromResourceNodeArray()
      else
        nodes = NodeManager().getNodesFromAllNodeArray()
      end
      
     
      --Map().saveAllNodesToMapFile(nodes)
      
      --local keys = utilityTable().sortedKeysByValueTableIndex(nodes,'meta')
      local keys = utilityTable().sortedKeysByValueTableIndex(nodes,'identifier')
      for _, k in ipairs(keys) do
          n = nodes[k]
          local item = items:add()
          item.Caption = k
          local row_subitems = listitem_getSubItems(item) --returns a Strings object
          strings_add(row_subitems, n.toString())
          strings_add(row_subitems, n.getIdentifier())
          strings_add(row_subitems, n.getMeta())
      end
     
  end


function updateAnyMapNodesList(map_name)
    local lv = GW2.CEListView_anymap_nodes
    listview_clear(lv)

    local items = lv.items
    items.clear()

    local nodes = Map().getMapNodesByMapName(map_name)
    
    local keys = utilityTable().sortedKeys(nodes)

    for _, k in ipairs(keys) do
        n = nodes[k]
        local item = items:add()
        item.Caption = k
        local row_subitems = listitem_getSubItems(item) --returns a Strings object
        strings_add(row_subitems, n.toString())
    end
end


----------------------


function CECheckbox_syncChange(sender)
   
   --addressList.getMemoryRecordByDescription('findResourceNode').Active = true
   if GW2.CECheckbox_sync.Checked then
      if (PlayerStatUpdateTimer == nil) then --first time init
          PlayerStatUpdateTimer = createTimer(nil, false)

          timer_setInterval(PlayerStatUpdateTimer, 300) --set value every 100 milliseconds
          timer_onTimer(PlayerStatUpdateTimer, updatePlayStat)
          timer_setEnabled(PlayerStatUpdateTimer, true)
      else
          timer_setEnabled(PlayerStatUpdateTimer, false) --stop the freezer
          PlayerStatUpdateTimer.destroy()
          PlayerStatUpdateTimer = nil
      end
      
      if (nodesUpdateTimer == nil) then --first time init
          nodesUpdateTimer = createTimer(nil, false)

          timer_setInterval(nodesUpdateTimer, 10000) --set value every 100 milliseconds
          timer_onTimer(nodesUpdateTimer, toggleFindNodes)
          timer_setEnabled(nodesUpdateTimer, true)
      else
          timer_setEnabled(nodesUpdateTimer, false) --stop the freezer
          nodesUpdateTimer.destroy()
          nodesUpdateTimer = nil
      end
      
    else
          timer_setEnabled(PlayerStatUpdateTimer, false) --stop the freezer
          PlayerStatUpdateTimer.destroy()
          PlayerStatUpdateTimer = nil
          
          timer_setEnabled(nodesUpdateTimer, false) --stop the freezer
          nodesUpdateTimer.destroy()
          nodesUpdateTimer = nil
    end
    

end

function toggleFindNodes()
      if addressList.getMemoryRecordByDescription('findResourceNode').Active == true then
        addressList.getMemoryRecordByDescription('findResourceNode').Active = false
        addressList.getMemoryRecordByDescription('findResourceNode').Active = true
      end
end


function CEButton_listCurrentMapNodesClick(sender)
    updateListViewNodesFromMap()
end

function CEButton_listCurrentMapResNodesClick(sender)
    addressList.getMemoryRecordByDescription('findResourceNode').Active = true
    updateListViewNodesFromMap(true)
end

function CEListView_allNodesClick(sender)
    local lv = GW2.CEListView_allNodes
    local itemSelected = lv.getItemIndex()
    local item = lv.Items[itemSelected]
    local node = NodeManager().getNodesFromAllNodeArray()[item.Caption]
    if not isEmpty(node) then Player().move(node.getX(), node.getY(), node.getZ()) end
    
end


function CEListView_nodesClick(sender)
    local lv = GW2.CEListView_nodes
    local itemSelected = lv.getItemIndex()
    local item = lv.Items[itemSelected]
    local node = Map().getCurrentMapNodes()[item.Caption]
    if node == nil then node = Map().getCurrentMapNodes(true)[item.Caption] end
    Player().move(node.getX(), node.getY(), node.getZ())
    
    resNodeCounter = itemSelected+1
    nodeCounter = itemSelected + 1
    GW2.CELabel_currentNodeInfo.Caption = item.Caption
    GW2.CELabel_node_counter.Caption = resNodeCounter
    

    --p(item.Caption)
    --p(item.SubItems[0])
    --p(item.SubItems[1])
end

--function CEToggleBox_activate2Click(sender)
--    if (NearNodesUpdateTimer == nil) then --first time init
--        NearNodesUpdateTimer = createTimer(nil, false)

--        timer_setInterval(NearNodesUpdateTimer, 300) --set value every 100 milliseconds
--        timer_onTimer(NearNodesUpdateTimer, updateNearNodesView)
--        timer_setEnabled(NearNodesUpdateTimer, true)
--    else
--        timer_setEnabled(NearNodesUpdateTimer, false) --stop the freezer
--        NearNodesUpdateTimer.destroy()
--        NearNodesUpdateTimer = nil
--    end
--end


function CEComboBox_map_selectionChange(sender)
    local cb = GW2.CEComboBox_map_selection
    local selected = cb.getItemIndex() + 1
    local map_id2name = Map().readMapID2Name()
    local keys = utilityTable().keys(map_id2name)
    updateAnyMapNodesList(map_id2name[keys[selected]])
end

function initComboBox_map_selection()
    local cb = GW2.CEComboBox_map_selection
    local map_id2name = Map().readMapID2Name()
    cb.clear()
    for k, v in pairs(map_id2name) do
        cb.items.add(v)
    end
end


function CEListView_anymap_nodesClick(sender)
    local lv = GW2.CEListView_anymap_nodes
    local itemSelected = lv.getItemIndex()
    local item = lv.Items[itemSelected]


    local cb = GW2.CEComboBox_map_selection
    local selected = cb.getItemIndex() + 1
    local map_id2name = Map().readMapID2Name()
    local keys = utilityTable().keys(map_id2name)
    local map_name = map_id2name[keys[selected]]
    local nodes = Map().getMapNodesByMapName(map_name)

    local node = nodes[item.Caption]
    if not isEmpty(node) then Player().move(node.getX(), node.getY(), node.getZ()) end
end

function CECheckbox_detectNearNodeChange(sender)
      if GW2.CECheckbox_detectNearNode.Checked then  
         addressList.getMemoryRecordByDescription('findResourceNode').Active = true
      else
         addressList.getMemoryRecordByDescription('findResourceNode').Active = false
         GW2.CECheckbox_detectNearResNode.Checked = false
      end
end

function CEButton_listNearNodesClick(sender)
  GW2.CECheckbox_detectNearNode.Checked = true
  sleep(0.2)
  updateNearNodesView()
end

function CEButton_NearResNodeClick(sender)
    GW2.CECheckbox_detectNearNode.Checked = true
    sleep(0.1)
    updateNearResNodesView()
end


function CECheckbox_detectNearResNodeChange(sender)
      if GW2.CECheckbox_detectNearResNode.Checked then  
          GW2.CECheckbox_detectNearNode.Checked = true
          if (NearNodesUpdateTimer == nil) then --first time init
              NearNodesUpdateTimer = createTimer(nil, false)

              timer_setInterval(NearNodesUpdateTimer, 500) --set value every 100 milliseconds
              timer_onTimer(NearNodesUpdateTimer, updateNearResNodesView)
              timer_setEnabled(NearNodesUpdateTimer, true)
          else
              timer_setEnabled(NearNodesUpdateTimer, false) --stop the freezer
              NearNodesUpdateTimer.destroy()
              NearNodesUpdateTimer = nil
          end
      else
              timer_setEnabled(NearNodesUpdateTimer, false) --stop the freezer
              NearNodesUpdateTimer.destroy()
              NearNodesUpdateTimer = nil
      end
end

function updateNearResNodesView()
    updateNearNodesView(true)
end
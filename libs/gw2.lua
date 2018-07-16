form_show(GW2)


function updatePlayStat()
    GW2.CELabel_cord.Caption = Player().getCord().toString()
    GW2.CELabel_speed.Caption = Player().getSpeed()
    GW2.CELabel_map_id.Caption = Map().getCurrentMapID()
    addNodesToMapFile()
end

function updateListViewNodesFromMap(resource)
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
    if resNodeCounter == nil then resNodeCounter = 1 end
    local nodes = Map().getCurrentMapNodes(true)
    local nodesvalues = utilityTable().values(nodes)
    local nodekeys = utilityTable().sortedKeys(nodes)

    GW2.CELabel_currentNodeInfo.Caption = nodekeys[resNodeCounter]
    GW2.CELabel_node_counter.Caption = resNodeCounter

    Player().moveToNode(nodes[nodekeys[resNodeCounter]])

    resNodeCounter = resNodeCounter + 1
    if resNodeCounter > utilityTable().length(nodekeys) then resNodeCounter = 1 end
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


function updateNearNodesView()
    local lv = GW2.CEListView_allNodes
    listview_clear(lv)

    local items = lv.items
    items.clear()

    local nodes = NodeManager().getNodesFromAllNodeArray()
    
    Map().saveAllNodesToMapFile(nodes)
    
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
function CEToggleBox_activateChange(sender)
    addressList.getMemoryRecordByDescription('findResourceNode').Active = true
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
    --p(item.Caption)
    --p(item.SubItems[0])
    --p(item.SubItems[1])
end

function CEToggleBox_activate2Click(sender)
    if (NearNodesUpdateTimer == nil) then --first time init
        NearNodesUpdateTimer = createTimer(nil, false)

        timer_setInterval(NearNodesUpdateTimer, 300) --set value every 100 milliseconds
        timer_onTimer(NearNodesUpdateTimer, updateNearNodesView)
        timer_setEnabled(NearNodesUpdateTimer, true)
    else
        timer_setEnabled(NearNodesUpdateTimer, false) --stop the freezer
        NearNodesUpdateTimer.destroy()
        NearNodesUpdateTimer = nil
    end
end


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


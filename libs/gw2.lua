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
    local newNodes_simply = {}
    for k, v in pairs(newNodes) do
        newNodes_simply[k] = Node().toNodeForSaving(v)
    end
    Map().saveResNodesToMapFile(utilityTable().merge(nodes, newNodes_simply))
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

    keys = utilityTable().sortedKeys(nodes)
    for _, k in ipairs(keys) do
        n = nodes[k]
        local item = items:add()
        item.Caption = k
        local row_subitems = listitem_getSubItems(item) --returns a Strings object
        strings_add(row_subitems, n.toString())
        strings_add(row_subitems, n.getMeta())
    end
end


----------------------
function CEToggleBox_activateChange(sender)
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

local function myObject()
    local self = {}


    -- return the instance
    return self
end


function Map()
    local self = myObject {}

    self.current_map_id = nil
    self.map_id2name = nil
    self.name = nil
    self.nodes = {}

    local map_meta_file = 'locations/maps.ini'

    function self.readMapID2Name()
        return utilityFile().readINI(map_meta_file)['mapid']
    end

    function self.readMapCordsByMapName(map_name, resource)
        if resource then map_name = map_name .. '_resource' end
        return utilityFile().readINI('locations/' .. map_name .. '.ini')
    end

    function self.readMapCordsByMapID(id, resource)
        return self.readMapCordsByMapName(self.readMapID2Name()[id], resource)
    end

    function self.readCurrentMapCords()
        return self.readMapCordsByMapID(self.getCurrentMapID())
    end

    function self.getCurrentMapID()
        self.current_map_id = readInteger('mapIDBase')
        return self.current_map_id
    end

    function self.getMapNodesByMapID(id, resource)
        local map_name = self.readMapID2Name()[id]
        return self.getMapNodesByMapName(map_name, resource)
    end

    function self.getMapNodesByMapName(map_name, resource)
        --load Cords for the map
        for k, v in pairs(self.readMapCordsByMapName(map_name, resource)) do
            if v['nodetype'] == nil then
                self.nodes[k] = Node(v['x'], v['y'], v['z'], k, v['map'], '', ' ')
            else
                self.nodes[k] = Node(v['x'], v['y'], v['z'], v['nodetype'], v['map'], v['meta'], v['identifier'])
            end
        end
        return self.nodes
    end

    function self.getCurrentMapNodes(resource)
        --load Cords for the map
        return self.getMapNodesByMapID(self.current_map_id, resource)
    end
    
    function self.saveNodesToMapFile(nodes,filename)
        local newNodes_simple = {}
        for k, v in pairs(nodes) do
            newNodes_simple[k] = Node().toNodeForSaving(v)
        end
        utilityFile().saveINI(filename, newNodes_simple)
    end
    

    function self.saveResNodesToMapFile(nodes)
        local map_name = self.readMapID2Name()[self.getCurrentMapID()]
        local resnodes = {}
        for k, v in pairs(nodes) do
            if v.getNodeType() ~= 'unknown' then
                resnodes[k] = v
            end
        end
        local filename = 'locations/' .. map_name .. '_resource.ini'
        self.saveNodesToMapFile(resnodes,filename)
    end
    
    function self.saveAllNodesToMapFile(nodes)
        local map_name = self.readMapID2Name()[self.getCurrentMapID()]
        local filename = 'locations/' .. map_name .. '_all.ini'
        self.saveNodesToMapFile(nodes,filename)
    end
    
--    function self.addNodeToMap(node, resource)
--        local old_nodes = self.getCurrentMapNodes(resource)
--        table.insert(old_nodes, Node().toNodeForSaving(node))
--    end



    self.map_id2name = self.readMapID2Name()
    self.current_map_id = self.getCurrentMapID()
    self.name = self.map_id2name[self.current_map_id]



    return self
end


function Node(x, y, z, nodetype, map, meta, identifier,pos)
    if isEmpty(identifier) then identifier = '' end
    if isEmpty(pos) then pos = 0 end
      
    local self = myObject {}

    self.x = x
    self.y = y
    self.z = z    
    self.nodetype = nodetype
    self.map = map
    self.meta = meta
    self.identifier = identifier
    self.pos = pos
    
    function self.getX()
        return self.x
    end

    function self.getY()
        return self.y
    end

    function self.getZ()
        return self.z
    end

    function self.getMap()
        return self.map
    end

    function self.getMeta()
        return self.meta
    end
    
    function self.getIdentifier()
        return self.identifier
    end
    
    function self.getMetaAsTable()
        return split(self.getMeta(),' ')
    end

    function self.getNodeType()
        return self.nodetype
    end


    function self.toString()
        return table.concat({ round(self.x, 1), round(self.y, 1), round(self.z, 1) }, ' , ')
    end

    function self.generateIDString()
        return table.concat({ self.nodetype, round(self.x, 1), round(self.y, 1), round(self.z, 1) }, ',')
    end

    function self.toNodeForSaving(node)
        --return { x = node.getX(), y = node.getY(), z = node.getZ(), nodetype = node.getNodeType(), map = node.getMap(), meta = node.getMeta(), identifier = node.getIdentifier()}
        return { x = node.getX(), y = node.getY(), z = node.getZ(), nodetype = node.getNodeType(), map = node.getMap(), meta = '', identifier = node.getIdentifier()}
    end

    local TYPES = {
        resource = 1,
        viewpoint = 2,
        waypoint = 3,
        npc = 4
    }

    local SUBTYPES = {
        tree = 1,
        mine = 2,
        grass = 3
    }

    return self
end



-------------
-- @param String hex
-- @return Address object
-- @usage Address('A0')
function Address(hex)

    local self = myObject {}

    self.hex = hex
    self.number = tonumber(hex, 16)
    self.value = nil
    self.value_type = { 'Float', 'Interger' }

    function self.getValueFloat()
        return readFloat(self.hex)
    end

    function self.getValueInteger()
        return readInteger(self.hex)
    end

    function self.getValueHex()
        return toHex(readInteger(self.hex))
    end

    function self.setValueFloat(float)
        writeFloat(self.hex, float)
        self.update()
        return self
    end

    function self.setValueInteger(int)
        writeInteger(self.hex, int)
        self.update()
        return self
    end

    function self.update()
        self.value = self.getValueHex()
    end

    function self.addOffset(offsetHex)
        return addHex(self.hex, offsetHex)
    end
    
    function self.recordValueToOffset(offsetHex)
        local offsetNumber = toNumber(offsetHex)
        local hex_signature = ''
        for i=0,offsetNumber,4 do
          local hex = Address(self.addOffset(toHex(i))).getValueHex()
          hex_signature = hex_signature ..toHex(i)..' '..hex..' '
        end
        return hex_signature
    end


    self.update()

    return self
end



function Cord(AddressX, Addressy, AddressZ)
    local self = myObject {}

    local xAddress = AddressX
    local yAddress = Addressy
    local zAddress = AddressZ

    function self.getXAddress()
        return xAddress
    end

    function self.getYAddress()
        return yAddress
    end

    function self.getZAddress()
        return zAddress
    end


    function self.setXAddress(Address)
        xAddress = Address
        return self
    end

    function self.setYAddress(Address)
        yAddress = Address
        return self
    end

    function self.setYAddress(Address)
        zAddress = Address
        return self
    end

    function self.changeX(float)
        xAddress.setValueFloat(float)
        return self
    end

    function self.changeY(float)
        yAddress.setValueFloat(float)
        return self
    end

    function self.changeZ(float)
        zAddress.setValueFloat(float)
        return self
    end

    function self.changeCord(floatX, floatY, floatZ)
        self.changeX(floatX)
        self.changeY(floatY)
        self.changeZ(floatZ)
        return self
    end

    function self.toString()
        return table.concat({ round(xAddress.getValueFloat(), 1), round(yAddress.getValueFloat(), 1), round(zAddress.getValueFloat(), 1) }, ' , ')
    end

    return self
end




function Player()

    local self = myObject {}

    local baseAddressHex = toHex(readInteger('playerBase'))
    local baseAddress = Address(baseAddressHex)

    local speed = nil
    local speedAddress = Address(baseAddress.addOffset('1E4'))
    
    local grv = nil
    local grvAddress = Address(baseAddress.addOffset('1C4'))

    local xAddress = Address(toHex(getAddress("[" .. baseAddressHex .. " + 98] + D0")))
    local yAddress = Address(xAddress.addOffset('4'))
    local zAddress = Address(xAddress.addOffset('8'))
    local playerCord = Cord(xAddress, yAddress, zAddress)


    function self.getSpeed()
        speed = speedAddress.getValueFloat()
        return speed
    end
    

    function self.setSpeed(float)
        speedAddress.setValueFloat(float)
        speed = self.getSpeed()
        return self
    end
    
    
    function self.getGrv()
        grv = grvAddress.getValueFloat()
        return grv
    end
    

    function self.setGrv(float)
        grvAddress.setValueFloat(float)
        grv = self.getGrv()
        return self
    end

    function self.getCord()
        return playerCord
    end

    --    function self.setCord(Cord)
    --        playerCord = Cord
    --        return self
    --    end

    function self.move(floatX, floatY, floatZ)
        playerCord.changeCord(floatX, floatY, floatZ)
        return self
    end

    function self.moveToNode(node)
        if not isEmpty(node.getX()) then self.move(node.getX(), node.getY(), node.getZ()) end
        return self
    end

    function self.moveX(float)
        local newValue = playerCord.getXAddress().getValueFloat() + float
        playerCord.changeX(newValue)
        return self
    end

    function self.moveY(float)
        local newValue = playerCord.getYAddress().getValueFloat() + float
        playerCord.changeY(float)
        return self
    end

    function self.moveZ(float)
        local newValue = playerCord.getZAddress().getValueFloat() + float
        playerCord.changeZ(float)
        return self
    end


    return self
end



function NodeManager()
    local self = myObject {}
    self.map_id = Map().getCurrentMapID()
    self.nodes = {}

    function self.getNodesFromResourceNodeArray()
        return self.getNodesFromNodeArray(self.getResourceNodeArray())
    end

    function self.getNodesFromAllNodeArray()
        return self.getNodesFromNodeArray(self.getNodeArray())
    end

    function self.getNodesFromNodeArray(nodeAddressArray)
        if (utilityTable().length(nodeAddressArray) == 0) then return {} end

        local nodes = {}
        for i, nodeBaseAddressHex in pairs(nodeAddressArray) do
            local nodeBaseAddress = Address(nodeBaseAddressHex)
            local x = Address(nodeBaseAddress.addOffset('130')).getValueFloat()
            local y = Address(nodeBaseAddress.addOffset('134')).getValueFloat()
            local z = Address(nodeBaseAddress.addOffset('138')).getValueFloat()
            local nodeidentifier = Address(nodeBaseAddress.addOffset('190')).getValueHex()

            local nodetype = utilityTable().keyof(self.getResIdentifier(), nodeidentifier)

            if nodetype == nil then nodetype = 'unknown' end
            
            local myid = Address(nodeBaseAddress.addOffset('0')).getValueHex()..';'..Address(nodeBaseAddress.addOffset('10')).getValueHex()..';'..Address(nodeBaseAddress.addOffset('D8')).getValueHex()..';'..Address(nodeBaseAddress.addOffset('12B')).getValueHex()..';'..Address(nodeBaseAddress.addOffset('15C')).getValueHex()..';'..Address(nodeBaseAddress.addOffset('16C')).getValueHex()..';'..Address(nodeBaseAddress.addOffset('190')).getValueHex()..'!!'

            local meta_string = nodeBaseAddress.recordValueToOffset('320')

            local node = Node(x, y, z, nodetype, self.map_id, myid..nodeBaseAddressHex..' '..meta_string, nodeidentifier)
            nodes[node.generateIDString()] = node
        end
        return nodes
    end
    
--    function self.getNodesFromNodeArray(nodeAddressArray)
--        if (utilityTable().length(nodeAddressArray) == 0) then return {} end

--        local nodes = {}
--        for i, nodeBaseAddressHex in pairs(nodeAddressArray) do
--            local nodeBaseAddress = Address(nodeBaseAddressHex)
--            local x = Address(nodeBaseAddress.addOffset('30')).getValueFloat()
--            local y = Address(nodeBaseAddress.addOffset('34')).getValueFloat()
--            local z = Address(nodeBaseAddress.addOffset('38')).getValueFloat()
--            local nodeidentifier = Address(nodeBaseAddress.addOffset('A0')).getValueHex()

--            local nodetype = utilityTable().keyof(self.getResIdentifier(), nodeidentifier)

--            if nodetype == nil then nodetype = 'unknown' end
            
            
            
--            local meta_string = nodeBaseAddress.recordValueToOffset('230')

--            local node = Node(x, y, z, nodetype, self.map_id, nodeBaseAddressHex..' '..meta_string, nodeidentifier)
--            nodes[node.generateIDString()] = node
--        end
--        return nodes
--    end
    
    function self.getResourceNodeArray()
        local size = readInteger('nbarr_size')
        local envListAddress = toHex(getAddress('nbarr'))
        local envList = {}
        
        if size<1 then
          return {}
        end
        
        for i = 1, size, 1 do
            local add = toHex(readInteger(addHex(envListAddress, toHex(4 * i))))
            if self.isResourceNode(add) then
                envList[i] = toHex(readInteger(addHex(envListAddress, toHex(4 * i))))
            end
        end
        return envList
    end

--    function self.getResourceNodeArray()
--        local size = readInteger('arr_size')
--        local envListAddress = toHex(getAddress('arr'))
--        local envList = {}

--        for i = 1, size, 1 do
--            local add = toHex(readInteger(addHex(envListAddress, toHex(4 * i))))
--            if self.isResourceNode(add) then
--                envList[i] = toHex(readInteger(addHex(envListAddress, toHex(4 * i))))
--            end
--        end
--        return envList
--    end

    function self.getNodeArray()
        local size = readInteger('nbarr_size')
        local envListAddress = toHex(getAddress('nbarr'))
        local envList = {}

        if size<1 then
          return {}
        end

        for i = 1, size, 1 do
            local add = toHex(readInteger(addHex(envListAddress, toHex(4 * i))))
            if self.isResourceNode2(add) then
              envList[i] = toHex(readInteger(addHex(envListAddress, toHex(4 * i))))
            end
        end
        return envList
    end
    
--    function self.getNodeArray()
--        local size = readInteger('arr_size')
--        local envListAddress = toHex(getAddress('arr'))
--        local envList = {}

--        for i = 1, size, 1 do
--            local add = toHex(readInteger(addHex(envListAddress, toHex(4 * i))))
--            envList[i] = toHex(readInteger(addHex(envListAddress, toHex(4 * i))))
--        end
--        return envList
--    end


--    function self.isResourceNode(add)
--        local keys = {}
--        local check = utilityTable().hasValue(self.getResIdentifier(), toHex(readInteger(addHex(add, 'A0'))))
--        --return readFloat(add) == 1 and readFloat(addHex(add, '28')) == 1 and readInteger(addHex(add, 'AC')) == 1 and check
--        return check
--    end
    
    function self.isResourceNode(add)
        local keys = {}
        local check = utilityTable().hasValue(self.getResIdentifier(), toHex(readInteger(addHex(add, '190'))))
        --check=true
        return readFloat(addHex(add, '15C')) == 1 and readFloat(addHex(add, '16C')) == 1 and check
        --return check
    end
    
    function self.isResourceNode2(add)
        local keys = {}
        local check = utilityTable().hasValue(self.getResIdentifier(), toHex(readInteger(addHex(add, '190'))))
        check=true
        return readFloat(addHex(add, '15C')) == 1 and readFloat(addHex(add, '16C')) == 1 and check
        --return check
    end

    function self.getResIdentifier()
        local id = utilityFile().readINI('data/Node.ini')['id']
        local id_hex = {}
        for k, v in pairs(id) do
            id_hex[k] = toHex(v)
        end
        return id_hex
    end


    return self
end


function utilityTable()
    local self = myObject {}

    function self.indexof(t, value)
        for i = 1, #t do
            if t[i] == value then return i end
        end
        return nil
    end

    function self.keyof(t, value)
        for k, v in pairs(t) do
            if v == value then return k end
        end
        return nil
    end

    function self.hasValue(t, value)
        local flag = self.keyof(t, value)
        if flag == nil then return false end
        return true
    end

    function self.keys(t)
        local keys = {}
        for k, v in pairs(t) do table.insert(keys, k) end
        return keys
    end

    function self.values(t)
        local values = {}
        for k, v in pairs(t) do table.insert(values, v) end
        return values
    end

    function self.merge(t1, t2)
        for k, v in pairs(t2) do
            t1[k] = v
        end
        return t1
    end

    function self.length(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end

    function self.sortedKeys(t)
        local keys = self.keys(t)
        table.sort(keys)
        return keys
    end
    
     function self.sortedKeysByValueTableIndex(t,index)
        --local values = self.values(t)

        local valueToBeSort = {}

        for k,v in pairs(t) do
           valueToBeSort[k] =v[index]
        end

        local sortedkeys = self.sortedKeyByValue(valueToBeSort)

        return sortedkeys
    end


    function self.sortedKeyByValue(t)
        local valueToBeSort={}

        for k,v in pairs(t) do
           if valueToBeSort[v]==nil then valueToBeSort[v]={} end
           table.insert(valueToBeSort[v],k)
        end

        local values = self.keys(valueToBeSort)
        table.sort(values)
        
        local sortedkeys = {}

        for k,v in pairs(values) do
            for k1,v1 in pairs(valueToBeSort[v]) do
              table.insert(sortedkeys,v1)
            end
        end

        return sortedkeys
    end
    
    function self.concat(t,spe1,spe2)
       local tstring =''
       for k,v in pairs(t) do
          tstring = k..spe1..value..spe2
       end
       return tstring
    end


    return self
end


function utilityFile()
    local self = myObject {}

    function self.readINI(fileName)
        local LIP = require 'libs.LIP';
        if not self.file_exists(fileName) then self.saveINI(fileName, {}) end
        return LIP.load(fileName);
    end

    function self.saveINI(fileName, data)
        local LIP = require 'libs.LIP';
        LIP.save(fileName, data);
    end

    function self.file_exists(name)
        local f = io.open(name, "r")
        if f ~= nil then io.close(f) return true else return false end
    end


    return self
end

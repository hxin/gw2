local function myObject()
    local self = {}


    -- return the instance
    return self
end


function Map()
    local self = myObject{}
    
    self.current_map_id = nil
    self.map_id2name=nil
    self.name = nil
    self.nodes={}

    local map_meta_file = 'locations/maps.ini'

    function self.readMapID2Name()
        return utilityFile().readINI(map_meta_file)['mapid']
    end

    function self.readMapCordsByMapName(map_name,resource)
        if resource then map_name = map_name..'_resource' end
        return utilityFile().readINI('locations/' .. map_name .. '.ini')
    end

    function self.readMapCordsByMapID(id,resource)
        return self.readMapCordsByMapName( self.map_id2name[id],resource)
    end
    
    function self.readCurrentMapCords()
        return self.readMapCordsByMapID(self.getCurrentMapID())
    end
    
    function self.getCurrentMapID()
        self.current_map_id = readInteger('[mapIDBase] + 24')
        return self.current_map_id
    end
    
    function self.getMapNodesByMapID(id,resource)
      --load Cords for the map
      for k,v in pairs(self.readMapCordsByMapID(id,resource)) do
          if v['pos'] then 
            self.nodes[k] = Node(v['x'],v['y'],v['z'],k,v['map'],'')
          else
            self.nodes[k] = Node(v['x'],v['y'],v['z'],v['type'],v['map'],v['meta'])
          end
      end
      return self.nodes
    end
    
    function self.getCurrentMapNodes(resource)
      --load Cords for the map
      return self.getMapNodesByMapID(self.current_map_id,resource)
    end
    
    function self.saveResNodesToMapFile(nodes) 
      local map_name = self.readMapID2Name()[self.getCurrentMapID()]
      utilityFile().saveINI('locations/' .. map_name .. '_resource.ini',nodes)
    end

    self.map_id2name = self.readMapID2Name()
    self.current_map_id = self.getCurrentMapID()
    self.name = self.map_id2name[self.current_map_id]
    
    

    return self
end


function Node(x,y,z,nodetype,map,meta)
    local self = myObject{}

    self.x=x
    self.y=y
    self.z=z
    self.nodetype = nodetype
    self.map = map
    self.meta = meta
    
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
    
    function self.getNodeType()
      return self.nodetype
    end
    
    
    function self.toString()
        return table.concat({ round(self.x,1), round(self.y,1), round(self.z,1) }, ' , ')
    end
    
    function self.generateIDString()
        return table.concat({ self.nodetype, round(self.x,1), round(self.y,1), round(self.z,1) }, ',')
    end
  
    function self.toNodeForSaving (node)
      return {x=node.getX(),y=node.getY(),z=node.getZ(),nodetype=node.getNodeType(),map=node.getMap(),meta=node.getMeta()}
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
  
    local self = myObject{}

    self.hex = hex
    self.number = tonumber(hex, 16)
    self.value = nil
    self.value_type = {'Float','Interger' }

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
        writeFloat(self.hex,float)
        self.update()
        return self
    end

    function self.setValueInteger(int)
        writeInteger(self.hex,int)
        self.update()
        return self
    end

    function self.update()
        self.value = self.getValueHex()
    end

    function self.addOffset(offsetHex)
        return addHex(self.hex,offsetHex)
    end


    self.update()

    return self
end



function Cord(AddressX,Addressy,AddressZ)
    local self = myObject{}

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
        xAddress=Address
        return self
    end

    function self.setYAddress(Address)
        yAddress=Address
        return self
    end

    function self.setYAddress(Address)
        zAddress=Address
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

    function self.changeCord(floatX,floatY,floatZ)
        self.changeX(floatX)
        self.changeY(floatY)
        self.changeZ(floatZ)
        return self
    end
    
    function self.toString()
        return table.concat({ round(xAddress.getValueFloat(),1), round(yAddress.getValueFloat(),1), round(zAddress.getValueFloat(),1) }, ' , ')
    end

    return self
end




function Player()
  
    local self = myObject{}

    local baseAddressHex = toHex(readInteger('playerBase'))
    local baseAddress = Address(baseAddressHex)

    local speed = nil
    local speedAddress = Address( baseAddress.addOffset('1E4') )

    local xAddress = Address( toHex(getAddress("["..baseAddressHex .. " + 98] + D0")) )
    local yAddress = Address( xAddress.addOffset('4') )
    local zAddress = Address( xAddress.addOffset('8') )
    local playerCord = Cord(xAddress,yAddress,zAddress)


    function self.getSpeed()
        speed = speedAddress.getValueFloat()
        return speed
    end

    function self.setSpeed(float)
        speedAddress.setValueFloat(float)
        speed = self.getSpeed()
        return self
    end

    function self.getCord()
        return playerCord
    end

--    function self.setCord(Cord)
--        playerCord = Cord
--        return self
--    end

    function self.move(floatX,floatY,floatZ)
        playerCord.changeCord(floatX,floatY,floatZ)
        return self
    end
    
    function self.moveToNode(node)
        self.move(node.getX(),node.getY(),node.getZ())
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
    local self = myObject{}
    self.map_id = Map().getCurrentMapID()
    self.nodes = {}
    self.IDENTIFIER = {mine_copper='3FE04BBF',tree='408ED607',mine_iron='401AE1BA',tree_ms='402527E3',mine_silver='3FA08378',mine_rich_iron_vein='3FB3623E'}
    
    function self.getNodesFromResourceNodeArray()
         return self.getNodesFromNodeArray(self.getResourceNodeArray ())
    end
    
    function self.getNodesFromAllNodeArray()
        return self.getNodesFromNodeArray(self.getNodeArray ())
    end
    
    function self.getNodesFromNodeArray(nodeAddressArray)
        if(utilityTable().length(nodeAddressArray)==0) then return {} end
        
        local nodes = {}
        for i,nodeBaseAddressHex in pairs(nodeAddressArray) do
            local nodeBaseAddress = Address(nodeBaseAddressHex)
            local x = Address( nodeBaseAddress.addOffset('30') ).getValueFloat()
            local y = Address( nodeBaseAddress.addOffset('34') ).getValueFloat()
            local z = Address( nodeBaseAddress.addOffset('38') ).getValueFloat()
            local nodeidentifier = Address( nodeBaseAddress.addOffset('A0') ).getValueHex() 

            local nodetype=utilityTable().keyof(self.IDENTIFIER,nodeidentifier)
            
            if nodetype == nil then nodetype = 'unknown' end
            
            local node = Node(x,y,z,nodetype,map,nodeidentifier) 
            nodes[node.generateIDString()] = node
         end
        return nodes
    end
    
    
    function self.getResourceNodeArray ()
         local size = readInteger('arr_size')
         local envListAddress = toHex(getAddress('arr'))
         local envList = {}

         for i=1,size,1 do
             local add = toHex(readInteger(addHex(envListAddress,toHex(4*i))))
              if self.isResourceNode(add) then
                   envList[i]=toHex(readInteger(addHex(envListAddress,toHex(4*i))))
              end
         end
         return envList
    end
    
    function self.getNodeArray ()
         local size = readInteger('arr_size')
         local envListAddress = toHex(getAddress('arr'))
         local envList = {}

         for i=1,size,1 do
             local add = toHex(readInteger(addHex(envListAddress,toHex(4*i))))
             envList[i]=toHex(readInteger(addHex(envListAddress,toHex(4*i))))
         end
         return envList
    end
    
    
    function self.isResourceNode(add)
         local keys ={}
         keys[self.IDENTIFIER['mine_copper']]=true
         keys[self.IDENTIFIER['mine_iron']]=true
         keys[self.IDENTIFIER['tree']]=true
         --keys[IDENTIFIER['herb']]=true
         local check=utilityTable().hasValue(self.IDENTIFIER, toHex(readInteger(addHex(add,'A0'))) )
         return readFloat(add) == 1 and readFloat(addHex(add,'28'))==1 and readInteger(addHex(add,'AC'))==1 and check
    end
    
    return self
    
end


function utilityTable()
    local self = myObject{}
    
    function self.indexof(t,value)
        for i = 1,#t do
            if t[i] == value then return i end
        end
        return nil
    end
    
    function self.keyof(t,value)
        for k,v in pairs(t) do
            if v == value then return k end
        end
        return nil
    end
    
    function self.hasValue(t,value)
        local flag = self.keyof(t,value)
        if flag==nil then return false end
        return true
    end
    
    function self.keys(t)
       local keys={}
       for k,v in pairs(t) do table.insert(keys,k) end
       return keys
    end
    
    function self.values(t)
       local values={}
       for k,v in pairs(t) do table.insert(values,v) end
       return values
    end
    
    function self.merge(t1,t2)
        for k,v in pairs(t2) do
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

  
    return self
end


function utilityFile()
    local self = myObject{}
    
    function self.readINI( fileName )
         local LIP = require 'libs.LIP';
         if not self.file_exists(fileName) then self.saveINI( fileName,{} ) end
         return LIP.load(fileName);
    end

    function self.saveINI( fileName, data )
             local LIP = require 'libs.LIP';
             LIP.save( fileName , data);
    end
    
    function self.file_exists(name)
       local f=io.open(name,"r")
       if f~=nil then io.close(f) return true else return false end
    end
    
    
    return self
    
    
end

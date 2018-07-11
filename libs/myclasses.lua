local function myObject()
    local self = {}


    -- return the instance
    return self
end

function Map(map_id)
    local self = myObject{}

    self.map_id2name=nil
    self.name = nil
    self.POIS={}

    local map_meta_file = 'locations/maps.ini'
    local id = id
    local name


    function self.readMapID()
        return readINI(map_meta_file)['mapid']
    end

    function self.readMapCordsByMapName(map_name)
        return readINI('locations/' .. map_name .. '.ini')
    end

    function self.readMapCordsByMapID(id)
        return self.readMapCordsByMapName( self.map_id2name[id] )
    end

    self.map_id2name = self.readMapID()
    self.name = self.map_id2name[map_id]

    --load Cords for the map
    for k,v in pairs(self.readMapCordsByMapID(id)) do
        self.POIS[k] = POI(v['x'],v['y'],v['z'],v['pos'],v['map'])
    end

    return self
end

function POI(x,y,z,type,subtype)
    local self = myObject{}

    self.x=x
    self.y=y
    self.z=z
    self.type = type
    self.subtype = subtype



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
        self.value = toHex(self.getValueInteger(self.hex))
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




local function myObject()
    local self = {}


    -- return the instance
    return self
end

function Map(id)
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
    self.name = self.map_id2name[id]

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
        writeFloat(float)
        self.update()
        return self
    end

    function self.setValueInteger(int)
        writeInteger(int)
        self.update()
        return c
    end

    function self.update()
        self.value = toHex(self.getValueInteger(self.hex))
    end

    function self.addOffset(offsetHex)
        return addHex(self.value,offsetHex)
    end


    self.update()

    return self
end

function Cord(xAddress,yAddress,zAddress)
    local self = myObject{}

    local xAddress = xAddress
    local yAddress = yAddress
    local zAddress = zAddress

    function getX()
        return xAddress
    end
    function getY()
        return yAddress
    end
    function getY()
        return zAddress
    end


    function setX(Address)
        xAddress=Address
        return self
    end
    function setY(Address)
        yAddress=Address
        return self
    end
    function setY(Address)
        zAddress=Address
        return self
    end

    function ChangeX(float)
        xAddress.setValueInter(float)
        return self
    end
    function ChangeY(float)
        yAddress.setValueInter(float)
        return self
    end
    function ChangeY(float)
        zAddress.setValueInter(float)
        return self
    end

    function changeCord(floatX,floatY,floatZ)
        ChangeX(floatX)
        ChangeY(floatY)
        ChangeZ(floatZ)
        return self
    end

    return self
end




function Player(baseAddressHex)
    local self = myObject{}

    local speed = nil
    local baseAddress = Address(baseAddressHex)
    local speedAddress = Address( baseAddress.addOffset('1E4') )


    local xAddress = Address( readInteger("["..baseAddress .. " + 98] + D0"))
    local yAddress = Address( xAddress.addOffset('4') )
    local zAddress = Address( xAddress.addOffset('8') )
    local playCord = Cord(xAddress,yAddress,zAddress)


    function self.getSpeed()
        return speed
    end

    function self.setSpeed(float)
        writeFloat(float)
        speed = self.getSpeed()
        return self
    end

    function self.getCord()
        return playCord
    end

    function self.setCord(Cord)
        playCord = Cord
        return self
    end

    function self.move(floatX,floatY,floatZ)
        playCord.changeCord(floatX,floatY,floatZ)
        return self
    end




    return self
end




function readInteger()
    return tonumber('160',10)
end

function readFloat()
    return tonumber('160',10)
end




require 'libs.ml'.import()
require "libs.logging"
require "libs.utility"

pd(Map(15).POIS)
--local x=Address('A0')
--p(x.getValueFloat())
--
--
--pd(Map(15).)



--print(tstring(split "a very short sentence"))
--tostring('aaa')
--require 'libs.ml'.import()
--tostring = tstring
--= tstring({10,20,name='joe'})
--print(split "a very short sentence")
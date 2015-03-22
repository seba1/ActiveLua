os.execute("cls")
package.path = ';.\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.luac'
package.cpath = ';.\\?.dll;.\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\?.dll;C:\\Program Files (x86)\\Lua\\5.1\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\?.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\loadall.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\loadall.dll;C:\\Program Files (x86)\\Lua\\5.1\\lib\\?.dll'

local oo = require "loop.simple"
local lanes = require "lanes".configure()
local linda = lanes.linda()
require "ActiveLua"
local lockf = lanes.genlock(linda,"M",1)

------------------------------------------------------------------------------------
------------------------------- CREATE OBJECTS -------------------------------------
------------------------------------------------------------------------------------
---------------------------------- OBJ_A -------------------------------------------
local OBJ_A = oo.class {
	x=1,
	objIDList={}
}

function OBJ_A:newObj(x)
	print ('x: '..x)
	if x~=1 then
		local i=0
		x=x-1
		for i=1, 2 do
			local obj = copy(OBJ_A)
			lockf(1)
				local objID = OBJ_A:createNewId()
			lockf(-1)
			--addNewObject
			insertNewObj(obj, objID, linda)
			--send new msg
			sendMsg(self, objID, "newObj", {x}, linda)
		end
	end
end

function OBJ_A:createNewId()
	local objID=''
	local valid=true
	while valid do
		valid = false
		objID = OBJ_A:randomString(10)
		for k,ob in pairs(self.objIDList) do
			if ob == objID then
				valid=true
			end
		end
	end
	table.insert(self.objIDList, objID)	
	return objID
end

function OBJ_A:beginSending()
	sendMsg(self, "OBJ_A", "newObj", {10}, linda)
end

function OBJ_A:randomString(len)
	local i,str = 0,""
	for i=1, len do
		str=str..string.char(math.random(65, 90)) -- Get random char using ascii
	end
	return str
end
------------------------------------------------------------------------------------
------------------------------------- THE MAIN -------------------------------------
------------------------------------------------------------------------------------
-- Put all objects into list
local objList={	OBJ_A, "OBJ_A"}

-- Run some object functions that will initialize messages
OBJ_A:beginSending()

-- send list of objects and start sending and executing messages
start(objList, lanes, linda)

------------------------------------- END ----------------------------------------

























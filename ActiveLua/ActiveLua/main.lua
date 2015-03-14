os.execute("cls")
package.path = ';.\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.luac'
package.cpath = ';.\\?.dll;.\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\?.dll;C:\\Program Files (x86)\\Lua\\5.1\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\?.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\loadall.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\loadall.dll;C:\\Program Files (x86)\\Lua\\5.1\\lib\\?.dll'
local oo = require "loop.simple"
local lanes = require "lanes".configure()
local linda = lanes.linda()
require "ActiveLua"

------------------------------------------------------------------------------------
------------------------------- CREATE OBJECTS -------------------------------------
------------------------------------------------------------------------------------

OBJ_A = oo.class {
	obj_A_value = 4,
}
----------------------- OBJ_A Functions -----------------------
function OBJ_A:printMe(v,d,t)
	self.obj_A_value = v+self.obj_A_value
	print ("Obj_A_value: ".. self.obj_A_value)
	local useTheseArgs={2,7}
	sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda)
end

function OBJ_A:updateFromA()
	local x=8
	local y=14
	useTheseArgs={x,y}
	sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda) -- this will only work if linda is passed..	
end

OBJ_B = oo.class {
	obj_B_value = 4000000,
}
----------------------- OBJ_B Functions -----------------------
function OBJ_B:printMe(q,a)
	self.obj_B_value= self.obj_B_value+q+a
	print ("Obj_B_value: "..self.obj_B_value.."\n")
	local useTheseArgs={1,3,5}
	sendMsg(self, "OBJ_C", "printMe", useTheseArgs, linda)
	--os.execute("ping 1.1.1.1 -n 1 -w 1000 > nul") -- create delay
end

function OBJ_B:updateFromB()
	local x=3
	local y=6
	local z=22
	local useTheseArgs={x,y,z}
	sendMsg(self, "OBJ_A", "printMe", useTheseArgs, linda) -- this will only work if linda is passed..	
end

OBJ_C = oo.class {
	obj_C_value = -8999999999,
}
----------------------- OBJ_C Functions -----------------------
function OBJ_C:printMe(v,d,t)
	self.obj_C_value = v+self.obj_C_value
	print ("Obj_C_value: ".. self.obj_C_value)
	local useTheseArgs={2,7}
	local useTheseArgsFA={62,78, 1}
	sendMsg(self, "OBJ_A", "printMe", useTheseArgsFA, linda)
	sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda)
	sendMsg(self, "OBJ_C", "printMe", useTheseArgs, linda)
end

function OBJ_C:updateFromC()
	local x=8
	local y=14
	useTheseArgs={x,y}
	sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda) -- this will only work if linda is passed..	
end

------------------------------------------------------------------------------------
-------------------------------------- LANE ---------------------------------------
------------------------------------------------------------------------------------

function activeLane(OBJ, objID, numOfloops)
	local oo = require "loop.simple"
	require "ActiveLua"
	----------------------- Main -----------------------
	createID(OBJ,objID) --must be donel.
	runMain(objID, numOfloops, linda)
end

------------------------------------------------------------------------------------
------------------------------------- THE MAIN -------------------------------------
------------------------------------------------------------------------------------

-- Run some object functions that will initialize messages
OBJ_A:updateFromA()
OBJ_B:updateFromB()
OBJ_C:updateFromC()
-- put all objects into list
local objList={OBJ_A, OBJ_B, OBJ_C}

local numOfloops=2
-- send list of objects
start(objList, numOfloops, lanes)

print '\n\nEnd Reached.'
------------------------------------- END ----------------------------------------

























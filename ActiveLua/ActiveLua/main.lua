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

local OBJ_A = oo.class {
	obj_A_value = 10,
}
------------------------------ OBJ_A Functions -------------------------------------
function OBJ_A:myvalues()
	print('MY A VALUES ARE::::\t'..self.obj_A_value)
end
function OBJ_A:printMe(v,d,t)
	if self.obj_A_value <= 13 then
		self.obj_A_value = v+self.obj_A_value
		print (":::_A_value: ".. self.obj_A_value)
		local useTheseArgs={1,7}
		sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda)
	else
		print 'X_A_X'
	end
end
function OBJ_A:updateFromA()
	local x=1
	local y=14
	useTheseArgs={x,y}
	sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda) -- this will only work if linda is passed..	
end
local OBJ_B = oo.class {
	obj_B_value = 4000000,
}
------------------------------ OBJ_B Functions -------------------------------------
function OBJ_B:myvalues()
	print('MY B VALUES ARE::::\t'..self.obj_B_value)
end
function OBJ_B:printMe(q,a)
	--os.execute("ping 1.1.1.1 -n 1 -w 500 > nul") -- create delay
	if self.obj_B_value <= 4000004 then
		self.obj_B_value= self.obj_B_value+q
		print ("###_B_value: "..self.obj_B_value.."\n")
		local useTheseArgs={1,3,5}
		sendMsg(self, "OBJ_C", "printMe", useTheseArgs, linda)
	else
		print 'D_B_D'
	end
end
function OBJ_B:updateFromB()
	local x=1
	local y=6
	local z=22
	local useTheseArgs={x,y,z}
	sendMsg(self, "OBJ_A", "printMe", useTheseArgs, linda) -- this will only work if linda is passed..	
end

local OBJ_C = oo.class {
	obj_C_value = 80000000,
}
------------------------------ OBJ_C Functions -------------------------------------
function OBJ_C:myvalues()
	print('MY C VALUES ARE::::\t'..self.obj_C_value)
end
function OBJ_C:printMe(v,d,t)
	self.obj_C_value = v+self.obj_C_value
	print ("Obj_C_value: ".. self.obj_C_value)
	local useTheseArgs={1,7}
	local useTheseArgsFA={1,78, 145}
	sendMsg(self, "OBJ_A", "printMe", useTheseArgsFA, linda)
	sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda)
	--sendMsg(self, "OBJ_C", "printMe", useTheseArgs, linda)
end
function OBJ_C:updateFromC()
	local x=1
	local y=14
	useTheseArgs={x,y}
	sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda) -- this will only work if linda is passed..	
end

------------------------------------------------------------------------------------
------------------------------------- THE MAIN -------------------------------------
------------------------------------------------------------------------------------

-- Run some object functions that will initialize messages
OBJ_A:updateFromA()
OBJ_B:updateFromB()
OBJ_C:updateFromC()

-- Put all objects into list
local objList={	OBJ_A, "OBJ_A",
				OBJ_B, "OBJ_B", 
				OBJ_C, "OBJ_C"}

-- send list of objects and start sending and executing messages
start(objList, lanes, linda)


print '\n\nEnd Reached Never.'
------------------------------------- END ----------------------------------------

























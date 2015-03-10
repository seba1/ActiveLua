os.execute("cls")
package.path = ';.\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.luac'
package.cpath = ';.\\?.dll;.\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\?.dll;C:\\Program Files (x86)\\Lua\\5.1\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\?.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\loadall.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\loadall.dll;C:\\Program Files (x86)\\Lua\\5.1\\lib\\?.dll'
oo = require "loop.simple"
local lanes = require "lanes".configure()
local linda = lanes.linda()
require "ActiveLua"

----------------------Functions----------------------

------------------------------------------------------------------------------------
-------------------------------------- LANE 1 --------------------------------------
------------------------------------------------------------------------------------
function firstLane()
	local oo = require "loop.simple"
	require "ActiveLua"
	
	OBJ_A = oo.class {
		obj_A_value = 4,
	}
	--------------------functions--------------------
	function OBJ_A:printMe(v,d,t)
		self.obj_A_value = v+self.obj_A_value
		print ("Obj_A_value: ".. self.obj_A_value)
		--[[--
		print ("\n\n:A:Received:_"..v.."_"..d.."_"..t.."\n\n")
		for i=1,3 do
			print (":A_"..i)
		end
		--]]--
		--print "\n:A:End_of_FuntionA\n" 
		local useTheseArgs={2,7}
		sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda)
	end
	
	function OBJ_A:updateFromA()
		local x=8
		local y=14
		useTheseArgs={x,y}
		sendMsg(self, "OBJ_B", "printMe", useTheseArgs, linda) -- this will only work if linda is passed..	
	end
--
--	THIS HERE HAVE TO BE A THREAD | GET & EXECUTE
--	
	function OBJ_A:Main()
		--cant loop for ever as it will block other stuff from running
		local messagesForMe={}
		while messagesForMe ~= nil do
			messagesForMe=nil
			messagesForMe = getMsg("OBJ_A",linda)
			if messagesForMe ~= nil then
				execMsg(messagesForMe)		
			end
		end
		print "End of Main_A"
	end
	-----------------------Main-----------------------
	createID(OBJ_A,"OBJ_A") --must be done.
	OBJ_A:updateFromA()
	OBJ_A:Main()
end

------------------------------------------------------------------------------------
-------------------------------------- LANE 2 --------------------------------------
------------------------------------------------------------------------------------

function secondLane()
	local oo = require "loop.simple"
	require "ActiveLua"
	
	OBJ_B = oo.class {
		obj_B_value = 555,
	}
	--------------------functions--------------------
	function OBJ_B:printMe(q,a)
		self.obj_B_value= self.obj_B_value+q+a
		print ("Obj_B_value: "..self.obj_B_value.."\n")
		--[[--
		-- output passed parameters to prove that it works.
		print ("\n\n:B:Received:_"..q.."_"..a.."_"..c.."\n")
		for i=1,3 do
			print ("B_"..i)
		end
		--]]--
		--print "\n:B:End_of_FuntionB\n"
		local useTheseArgs={1,3,5}
		sendMsg(self, "OBJ_A", "printMe", useTheseArgs, linda)
		--os.execute("ping 1.1.1.1 -n 1 -w 1000 > nul") -- create delay
	end
	function OBJ_B:updateFromA()
		local x=3
		local y=6
		local z=22
		local useTheseArgs={x,y,z}
		sendMsg(self, "OBJ_A", "printMe", useTheseArgs, linda) -- this will only work if linda is passed..	
	end
--
--	THIS HERE HAVE TO BE A THREAD | GET & EXECUTE
--	
	function OBJ_B:Main()
		--cant loop for ever as it will block other stuff from running
		local messagesForMe={}
		while messagesForMe ~= nil do
			messagesForMe=nil
			messagesForMe = getMsg("OBJ_B",linda)
			if messagesForMe ~= nil then
				execMsg(messagesForMe)		
			end
		end
		print "End of Main_B"
	end
	-----------------------Main-----------------------
	createID(OBJ_B,"OBJ_B") --must be done.
	--createID(OBJ_B,"OBJ_B") --must be done.
	
	--os.execute("ping 1.1.1.1 -n 1 -w 3000 > nul") -- create delay
	OBJ_B:updateFromA()
	OBJ_B:Main()
end

-------------------------Main------------------------

--Create lanes
thread1 = lanes.gen("*",firstLane)
thread2 = lanes.gen("*",secondLane)

--Run lanes
t1 = thread1()
t2 = thread2()
---------------------Test Area I------------------------

t1:join()--don't do anything under these because it wont work.
t2:join()--don't do anything under these because it wont work.

--------------------------END--------------------------

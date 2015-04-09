os.execute("cls")
local oo = require "loop.simple"
local lanes = require "lanes".configure()
local linda = lanes.linda()
require "ActiveLua"

------------------------------------------------------------------------------------
------------------------------- CREATE OBJECTS -------------------------------------
------------------------------------------------------------------------------------
---------------------------------- OBJ_A -------------------------------------------
local OBJ_A = oo.class {
	i=0
}

function OBJ_A:ping(startTime)
	if self.i<8000 then
		self.i=self.i+1
		print 'Ping'
		print(string.format("elapsed time: %.2f\n", os.clock() - startTime))
		sendMsg(self, "OBJ_B", "pong", {startTime}, linda)
	else
		return 0
	end
end

---------------------------------- OBJ_B -------------------------------------------
local OBJ_B = oo.class {
	i=0
}

function OBJ_B:pong(startTime)
	if self.i<8000 then
		self.i=self.i+1
		print(self.i)
		print 'Pong\n'
		print(string.format("elapsed time: %.2f\n", os.clock() - startTime))
		sendMsg(self, "OBJ_A", "ping", {startTime}, linda)
	else
		return 0
	end
end
------------------------------------------------------------------------------------
------------------------------------- THE MAIN -------------------------------------
------------------------------------------------------------------------------------
-- Put all objects into list
local objList={	OBJ_A, "OBJ_A",
				OBJ_B, "OBJ_B"}
local startTime = os.clock()
-- Run some object functions that will initialize messages
OBJ_A:ping(startTime)
OBJ_B:pong(startTime)

-- send list of objects and start sending and executing messages
start(objList, lanes, linda)

------------------------------------- END ----------------------------------------

























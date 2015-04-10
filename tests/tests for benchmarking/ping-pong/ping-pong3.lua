--	Name:	Sebastian Horoszkiewicz
--	Date:	20/03/2015
--	Copyright (c) 2015, Sebastian Horoszkiewicz
os.execute("cls")
local oo = require "loop.simple"
local lanes = require "lanes".configure()
local linda = lanes.linda()
require "activelua"

------------------------------------------------------------------------------------
------------------------------- CREATE OBJECTS -------------------------------------
------------------------------------------------------------------------------------
---------------------------------- OBJ_A -------------------------------------------
local OBJ_A = oo.class {
	i=0
}

function OBJ_A:ping()
	if self.i<3 then
		self.i=self.i+1
		print 'Ping'
		sendMsg(self, "OBJ_B", "pong", {}, linda)
	end
end

---------------------------------- OBJ_B -------------------------------------------
local OBJ_B = oo.class {
	i=0
}

function OBJ_B:pong()
	if self.i<3 then
		self.i=self.i+1
		print 'Pong\n'
		sendMsg(self, "OBJ_A", "ping", {}, linda)
	end
end
------------------------------------------------------------------------------------
------------------------------------- THE MAIN -------------------------------------
------------------------------------------------------------------------------------
-- Put all objects into list
local objList={	OBJ_A, "OBJ_A",
				OBJ_B, "OBJ_B"}

-- Run some object functions that will initialize messages
OBJ_A:ping()
OBJ_B:pong()

-- send list of objects and start sending and executing messages
start(objList, lanes, linda)

------------------------------------- END ----------------------------------------

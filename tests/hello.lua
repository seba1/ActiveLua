os.execute("cls")
local oo = require "loop.simple"
local lanes = require "lanes".configure()
local linda = lanes.linda()
require "ActiveLua"

------------------------------------------------------------------------------------
------------------------------- CREATE OBJECTS -------------------------------------
------------------------------------------------------------------------------------
---------------------------------- OBJ_A -------------------------------------------
local OBJ_A = oo.class {}

function OBJ_A:askForHelloFromB()
	sendMsg(self, "OBJ_B", "helloB", {}, linda) -- this will only work if linda is passed..	
end

function OBJ_A:helloA()
	print 'Hello From A'
end

---------------------------------- OBJ_B -------------------------------------------
local OBJ_B = oo.class {}

function OBJ_B:askForHelloFromA()
	sendMsg(self, "OBJ_A", "helloA", {}, linda)
end

function OBJ_B:helloB()
	print 'Hello From B'
end
------------------------------------------------------------------------------------
------------------------------------- THE MAIN -------------------------------------
------------------------------------------------------------------------------------
-- Put all objects into list
local objList={	OBJ_A, "OBJ_A",
				OBJ_B, "OBJ_B"}

-- Run some object functions that will initialize messages
OBJ_A:askForHelloFromB()
OBJ_B:askForHelloFromA()

-- send list of objects and start sending and executing messages
start(objList, lanes, linda)

------------------------------------- END ----------------------------------------

























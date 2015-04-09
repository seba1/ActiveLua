--	Name:	Sebastian Horoszkiewicz
--	Date:	20/03/2015
--	Copyright (c) 2015, Sebastian Horoszkiewicz
os.execute("cls")
local oo = require "loop.simple"
local lanes = require "lanes".configure()
local linda = lanes.linda()
require "activelua"
local lockf = lanes.genlock(linda,"M",1)

------------------------------------------------------------------------------------
------------------------------- CREATE OBJECTS -------------------------------------
------------------------------------------------------------------------------------
---------------------------------- OBJ_A -------------------------------------------
local OBJ_A = oo.class {
	x=1,
	objIDList={}
}

function OBJ_A:newObj(x,startTime)
	print ('x: '..x)
	if x~=1 then
		local i=0
		x=x-1
		for i=1, 2 do
			local obj = copy(OBJ_A)
			lockf(1)
				local objID = OBJ_A:createNewId()
			lockf(-1)
			obj:newObj(x,startTime)
		end
	else
		print(string.format("elapsed time: %.2f\n", os.clock() - startTime))
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

function OBJ_A:beginSending(startTime)
	sendMsg(self, "OBJ_A", "newObj", {10,startTime}, linda)
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
local startTime = os.clock()

-- Put all objects into list
local objList={	OBJ_A, "OBJ_A"}

-- Run some object functions that will initialize messages
OBJ_A:newObj(10,startTime)

------------------------------------- END ----------------------------------------

























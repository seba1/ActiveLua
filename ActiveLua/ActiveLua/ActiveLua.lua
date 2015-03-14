
function createID(object, ID)
	--user has to remember about that ID that he wants to create must be unique.
	--	table     ID
	--  ________________
	-- | objA_ID | objA |
	-- |_________|______|
	-- | objB_ID | objB |	> objsIDs < > {{A_ID,A}},{B_ID,B}...}
	-- |_________|______|	
	-- | etc..   | etc..|	table of ID's
	-- |_________|______|
	
	-- check if obj id has been already added
	local objectAndID = {ID, object}
	if objsIDs == nil then
		objsIDs={} --must be global
		table.insert(objsIDs, objectAndID)
	else
		local eachID
		local notfound = true
		for k, eachID in pairs(objsIDs) do
			if (k == 1) and (eachID == object) then
				notfound=false
			end
		end
		if notfound then
			table.insert(objsIDs, objectAndID)
		end
	end
end

--send message: from which obj, to which obj, funct, argTable
function sendMsg(fromObj, toObj, funct, argTable, linda)
	--   from     to        fun   argTable
	--  _____________________________
	-- | objB | objA_ID | funct | {} |
	-- |______|_________|_______|____|
	
	-- if no errors send message
	local message = {tostring(fromObj), toObj, funct, argTable}
	local msgID = tostring(toObj)
	linda:send(msgID, message)
end

function getMsg(objectID,linda)
	--pass in self or id of object requiring message
	if type(objectID)== "table" then
		objectID = tostring(objectID)
	end
	local message = nil
	-- If timed out then no more messages for me
	local key, message = linda:receive(2.5, objectID)
	return message
end

function execMsg(messageTable)
	local tableElements={}
	local values=""
	local i=0
	local keyset={}
	for key, val in pairs(messageTable) do
		i=i+1
		keyset[i]=key
		tableElements[i] = messageTable[keyset[i]]
	end
	to = tableElements[2]
	fun = tableElements[3]
	values = tableElements[4]

	-- from `objsIDs` get table corresponding to the id provided
	found = false
	for k, v in pairs(objsIDs) do
		for key, val in pairs(v) do
			if (key == 1) and (to == val) then
				found = true
			elseif (found == true)and (key == 2) then
				to = val
			end
		end
		if found then
			break
		end
	end
	--run object function with args
	assert(loadstring('to:'..fun..'(...)'))(unpack(values))
end

function runMain(objID, numOfloops, linda)
	local messagesForMe={}
	local x=0
	for x=0,numOfloops do
		x=x+1
		messagesForMe=nil
		messagesForMe = getMsg(objID,linda)
		if messagesForMe ~= nil then
			execMsg(messagesForMe)		
		end
	end
end

-- Function copy creates a shallow copy of an object,
-- Code for this function wasn't written by my
-- Link to the source: https://gist.github.com/MihailJP/3931841
function copy(t) -- shallow-copy a table
    if type(t) ~= "table" then 
		return t 
	end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
		target[k] = v 
	end
	setmetatable(target, meta)
    return target
end

-- starts everything
function start(allOBJs, numOfloops, lanes)
	local copied={}
	local threadList={}
	local t={}
	local i=0
	local objID={}
	objID[0]='OBJ_A'
	objID[1]='OBJ_B'
	objID[2]='OBJ_C'
	
	
	print ''
	-- Get number of cores
	print('Number of cores: '.. tonumber(os.getenv("NUMBER_OF_PROCESSORS")))
	print '\n'
	
	NUM_OF_CORES = 2 --tonumber(os.getenv("NUMBER_OF_PROCESSORS"))
	
	--shallow copy of all objects
	for k, obj in pairs(allOBJs) do
		copied[k-1] = copy(obj)
		--Create lanes
		threadList[k-1] = lanes.gen("*",activeLane)
	end
	-- Run lanes
	for i=0,NUM_OF_CORES do
		t[i] = threadList[i](copied[i],objID[i], numOfloops)
	end

	-- Terminate lanes
	for i=0,NUM_OF_CORES do
		t[i]:join()
	end
end
















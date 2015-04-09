--	Name:	Sebastian Horoszkiewicz
--	Date:	20/03/2015
--	Title:	Active Lua
--	Purpose: Implementation of active objects into Lua to allow parallelization
--			 across multiple cores.
--	Copyright (c) 2015, Sebastian Horoszkiewicz

-- Function 'copy' creates a shallow copy of an object,
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

-- insertNewObj allows user to add new objects dynamically
function insertNewObj(obj, objID, linda)
	local newObjs={obj, objID}
	linda:send('insertNewObjs', newObjs)
end

--send message: from which obj, to which obj, funct, argTable
function sendMsg(fromObj, toObj, funct, argTable, linda)
	--   from     to        fun   argTable
	--  _____________________________
	-- | objB | objA_ID | funct | {} |
	-- |______|_________|_______|____|
	local message = {fromObj, toObj, funct, argTable}
	local msgID = tostring(toObj)
	linda:send(msgID, message)
end

-- starts everything
function start(allOBJs, lanes, linda)
	local copied, threadList, t, objID = {},{},{},{}
	local NUM_OF_LOOPS=10 --start at 0
	local finished, val, i, c = 1,0,0,0
	local k,v
	local copyOfAllObjs = {}
	-- Get number of cores (-1 because Main is one thread and my counting starts at 0)
	local NUM_OF_CORES = tonumber(os.getenv("NUMBER_OF_PROCESSORS"))-2
	
	for k, obj in pairs(allOBJs) do
		if k % 2 == 0 then
			objID[c] = obj
			c=c+1
		else
			--shallow copy of object
			copied[i] = copy(obj)
			i=i+1
		end
	end

	for i=0,NUM_OF_CORES do
		--Create lanes
		threadList[i] = lanes.gen("*",activeLane)
		-- Remove used values
		table.remove(allOBJs, 1)
		table.remove(allOBJs, 1)
		-- Run lanes
		t[i] = threadList[i](copied[i],objID[i], NUM_OF_LOOPS, linda)
	end
	--------------------------------------------------------------------------
	-------------------------- LOOPING THROUGH ALL ---------------------------
	--------------------------------------------------------------------------
	
	while true do
		local obj,obid, key, message, state = nil,nil,nil,nil,nil
		-- if new objects were dynamically added then add them to the list
		key, message = linda:receive(0.0, 'insertNewObjs')
		if message ~=nil then
			obj, obid = unpack(message)
			table.insert(allOBJs, obj)
			table.insert(allOBJs, obid)
		end
		obj,obid, message= nil,nil,nil
		-- get object that were executed on the thread
		key, message = linda:receive(0.0, 'finished')
		if message ~= nil then
			obj, obid, state = unpack(message)
			if state == 1 then
				-- put it back on stack of obj's
				table.insert(allOBJs, obj)
				table.insert(allOBJs, obid)
			end
			-- get next msg
			local head, head2 = nil, nil
			head = table.remove(allOBJs, 1)
			head2 = table.remove(allOBJs, 1)
			if head ~= nil then
				local sendThis = {head, head2}
				linda:send('nextMessage', sendThis)
			end
		end
	end
	
	-- Terminate lanes
	for i=0,NUM_OF_CORES do
		t[i]:join()
	end
	
	-- Finished with messaging
	return 0
end

-------------------------------------------------------------------------------------
-------------------------------FUNCTIONS USED ON LANES-------------------------------
-------------------------------------------------------------------------------------

function activeLane(OBJ, objID, NUM_OF_LOOPS, linda)
	require "ActiveLua"
	----------------------- Main -----------------------
	while true do
		if OBJ ~= nil and objID~=nil then
			local state = runMain(OBJ, objID, NUM_OF_LOOPS, linda)
			idAndObj = {OBJ, objID, state}
			linda:send('finished', idAndObj)
		end
		local _, newObj = linda:receive(0.0, 'nextMessage')
		if newObj ~= nil then
			OBJ, objID = unpack(newObj)
		else
			OBJ,objID = nil,nil
		end
	end
end

function getMsg(obj, objectID,linda)
	-- If timed out then no more messages for me
	local key, message = linda:receive(0.0, objectID)
	if message ~= nil then
		--replace string id with the actual object
		message[2]=obj
		return message		
	else
		return nil
	end
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

	--run object function with args
	assert(loadstring('to:'..fun..'(...)'))(unpack(values))
end

function runMain(obj, objID, NUM_OF_LOOPS, linda)
	local x=0
	local messagesForMe={}
	for x=0, NUM_OF_LOOPS do
		messagesForMe={}
		messagesForMe = getMsg(obj, objID,linda)
		if messagesForMe ~= nil then
			execMsg(messagesForMe)

		end
	end
	return 1
end

















function sendMsg(fromObj, toObj, funct, argTable, linda)
	--str,str,str,table
	--check if both ID's exist(from/to obj)
	--
	--
	--check if arguments passed are correct (int, int, ???, table, linda)
	--
	--
	--create unique ID and connect it to table that is used to send message
	--if table with this id exist don't create id just send msg
	--
	--
	if objAndID == nil then
		objAndID={}
	end
	table.insert(objAndID,{fromObj,tostring(fromObj)})
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
--send message: from which obj, to which obj, funct, argTable
function execMsg(table_OR_fromObj, toOb, fun, argTbl)
	local tableElements={}
	local values=""
	--check if user passed table with elements or set of elements 
	--Eg exec(table) OR exec(toObj, fromObj, funct, argTable)
	if (toOb == nil) then
		local i=0
		local keyset={}
		for key, val in pairs(table_OR_fromObj) do
			i=i+1
			keyset[i]=key
			tableElements[i] = table_OR_fromObj[keyset[i]]
		end
		to = tableElements[2]
		--print (to)
		fun = tableElements[3]
		values = tableElements[4]
	else 
		to = toOb
		values = argTbl
	end
	
	--	table     ID
	--  ________________
	-- | objA_ID | objA |
	-- |_________|______|
	-- | objB_ID | objB |	> objsIDs < > {{A_ID,A}},{B_ID,B}...}
	-- |_________|______|	
	-- | etc..   | etc..|	table of ID's
	-- |_________|______|

	found = false
	for k, v in pairs(objsIDs) do
		for key, val in pairs(v) do
			if (key == 1) and (to == val) then
				found = true
			elseif (found == true)and (key == 2) then
				to = val
			end
		end
		if found==true then
			break
		end
	end

	--   from     to        fun   argTable
	--  __________________________________
	-- | objB | objA_ID |  funct  |  {}   |
	-- |______|_________|_________|_______|
	--

	--run object function with args
	assert(loadstring('to:'..fun..'(...)'))(unpack(values))
end

function createID(object, ID)
	--user have to remembear about that ID that he wants to create must be unique.
	local objectAndID = {ID, object}
	if objsIDs == nil then
		objsIDs={} --must be global
	end	
	table.insert(objsIDs, objectAndID)
	--[[--
	else
		local alreadyDefinied = false
		for ke, objid in pairs(objsIDs) do
			print ("xxx",objid, ke)
			for k, objct in pairs(objid) do
			    print ("ppp",k,ppp)
				if objct == objectAndID then
					alreadyDefinied = true
					print ("WARNING: Object".. objectAndID .." already definied.")
				end
			end
		end
		if alreadyDefinied == false then
			table.insert(objsIDs, objectAndID)
		end
	end
	--]]--
	--
	--check does ID exist, if it exists don't create it
	--
	--
end










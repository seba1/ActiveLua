function sendMsg(fromObj, toObj, funct, argTable)
	if type(obj_mailbox) ~= "table" then
		obj_mailbox={} --if mailbox is empty initialize it
	end
	obj_elements={} --table for each element sent
	obj_elements = {fromObj, toObj, funct, argTable}
	table.insert(obj_mailbox, obj_elements) --insert into mailbox
end

function getMsg(objectID)
	local itsThatObj = false
	local keyset={}
	local i=0
	--retrieve element from mailbox
	for k,v in pairs(obj_mailbox) do
		sent_elements={}
		i=i+1
		keyset[i]=k
		--now, retrieve element from mailbox element
		local i1=0 local keyset1={}
		for k1, v1 in pairs(obj_mailbox[keyset[k]]) do
			i1=i1+1
			keyset1[i1]=k1
			table.insert(sent_elements, obj_mailbox[keyset[k]][keyset1[k1]])
			if (i==2) and (obj_mailbox[keyset[k]][keyset1[k1]] == objectID) then
				itsThatObj = true
			end
		end
		if itsThatObj == true then
			--starts at 1... so element 1 which is element '0' is deleted
			table.remove(obj_mailbox,i)
			break
		end
	end
	return sent_elements
end
--send message: from which obj, to which obj, funct, argTable
function execMsg(table_OR_fromObj, toOb, fun, argTbl)
	local tableElements={}
	local values=""
	if (toOb == nil) then
		local i=0
		local keyset={}
		for key, val in pairs(table_OR_fromObj) do
			i=i+1
			keyset[i]=key
			tableElements[i] = table_OR_fromObj[keyset[i]]
		end
		to = tableElements[2]
		fun = tableElements[3]
		values = tableElements[4]
	else 
		to = toOb
		values = argTbl
	end
	local stringToProcess ='to:'..fun..'('
	valuesStr=""
	i=0
	keyset={}
	for key, val in pairs(values) do
		i=i+1
		keyset[i]=key
		if (i ~= table.getn(values)) then
			stringToProcess = stringToProcess..values[keyset[i]]..","
		else
			stringToProcess = stringToProcess..values[keyset[i]]..")"
		end
	end
	loadstring(stringToProcess)()
end

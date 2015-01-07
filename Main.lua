require "ActiveLua"
oo = require "loop.simple"
-------------------- Create Objects ------------------------
----------------------- OBJ_A OBJ --------------------------
OBJ_A = oo.class {
  obj_A_value = 0,
}
function OBJ_A:updateFromA(p)
	self.obj_A_value = self.obj_A_value + p
	pxT ={p}
	sendMsg(self, myOBJ_B, "updateFromB", pxT)
end
function OBJ_A:Main(threadID)
	while true do
		execMsg(getMsg(self))
		coroutine.yield(thread[threadID])
	end
end
------------------------ OBJ_B OBJ -------------------------
OBJ_B = oo.class {
  obj_B_value = 0,
}
function OBJ_B:updateFromB(a)
	self.obj_B_value = self.obj_B_value+a
	axT ={a}
	sendMsg(self, myOBJ_A, "updateFromA", axT)
end
function OBJ_B:Main(threadID)
	while true do
		execMsg(getMsg(self))
		coroutine.yield(thread[threadID])
	end
end

--------------------------- MAIN ---------------------------
function Main()
	print()
	myOBJ_A = OBJ_A {
		obj_A_value=240,
	}
	myOBJ_B = OBJ_B {
		obj_B_value=240,
	}
	local x=5
	myOBJ_A:updateFromA(x)
	myOBJ_B:updateFromB(x)
	
	print ("\nFrom Main:")
	objList={myOBJ_A,myOBJ_B}
	print("OBJ_A:   ",myOBJ_A)
	print("OBJ_B:   ",myOBJ_B)
	print("objList: ",objList)
	
	
	thread ={}
	thread['0'] = coroutine.create(function()
		while true do
			--for each_obj do
			local i=0
			for _, value in pairs(objList) do 
				i=i+1
				local c=tostring(i)
				thread[c] = coroutine.create(function()
					value:Main(c)
				end)
				coroutine.resume(thread[c])
				
			end
			print(myOBJ_A.obj_A_value)
			print(myOBJ_B.obj_B_value,"\n")
			os.execute("ping 1.1.1.1 -n 1 -w 1000 > nul") -- wait 1 sec
		end
	end)
	coroutine.resume(thread['0'])

end	--Main
Main()

	
	
	
	
	
	
	
	
	
	

------------------------- END OF FILE ----------------------

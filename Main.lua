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
function OBJ_A:Main()
--loop until not empty BUT firstly do threads
--while ... do
	execMsg(getMsg(self))
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
function OBJ_B:Main()
--loop until not empty BUT firstly do threads
--while ... do
	execMsg(getMsg(self))
end
--------------------------- MAIN ---------------------------
print()
--create two objects
myOBJ_A = OBJ_A {
	obj_A_value=240,
}
myOBJ_B = OBJ_B {
	obj_B_value=240,
}

local x=5
myOBJ_A:updateFromA(x)
--mailbox after line above: {{myOBJ_A, myOBJ_B, "updateFromB", {x}}}
myOBJ_B:updateFromB(x)
--mailbox after line above:
--[[ 				Mailbox
	{{myOBJ_A, myOBJ_B, "updateFromB", {x}},
	 {myOBJ_B, myOBJ_A, "updateFromA", {x}}}	 
--]]

--TODO add Thread for while
while true do
--TODO for 'each obj' do
--TODO add Thread
	myOBJ_A:Main()
	myOBJ_B:Main()
	print ("OBJ A Value: "..myOBJ_A.obj_A_value)
	print ("OBJ B Value: "..myOBJ_B.obj_B_value.."\n")
	os.execute("ping 1.1.1.1 -n 1 -w 1000 > nul") -- wait 1 sec
end

------------------------- END OF FILE ----------------------

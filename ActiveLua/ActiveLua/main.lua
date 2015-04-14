os.execute("cls")
package.path = ';.\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\?.lua;C:\\Program Files (x86)\\Lua\\5.1\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.luac'
package.cpath = ';.\\?.dll;.\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\?.dll;C:\\Program Files (x86)\\Lua\\5.1\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\?.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\?51.dll;C:\\Program Files (x86)\\Lua\\5.1\\loadall.dll;C:\\Program Files (x86)\\Lua\\5.1\\clibs\\loadall.dll;C:\\Program Files (x86)\\Lua\\5.1\\lib\\?.dll'

local oo = require "loop.simple"
local lanes = require "lanes".configure()
local linda = lanes.linda()
require "ActiveLua"

--print C++ value
print(someString)

--set new value to C++ static variable
someString = "This string has been changed in Lua"


------------------------------------- END ----------------------------------------

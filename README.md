# ActiveLua

# REQUIREMENTS
Make sure that you have installed lua lanes and LOOP rocks, you can get them from:
Lanes:	https://rocks.moonscript.org/modules/benoitgermain/lanes
LOOP: 	https://rocks.moonscript.org/modules/luarocks/loop
NOTICE: This extension was only tested with lua lanes and LOOP rocks, using other rocks may result with unexpected behaviour of your script and/or crashing your script.

# INSTALLATION
You can install this extension in two ways;
1. First way is to use luarocks
You will be required to have installed luarocks on your machine. You can download it form https://github.com/keplerproject/luarocks/wiki/Download
After you have installed luarocks run 'luarocks install activelua-learningtool' command in command prompt.

2. Second way is to download source folder from github which can be found here: https://github.com/seba1/ActiveLua and after that run 'luarocks make' in the source folder (the one containing README.md)

# HOW TO USE IT
First lines of your script should be exactly the same as below:
local oo = require "loop.simple"
local lanes = require "lanes".configure()
local linda = lanes.linda()
require "activelua"

Now, if you wat to send messages between objects, use send message function in the following format:
sendMsg(from_object, to_object, "function", arguments_table, linda)

To start messaging use start function:
start(allObjects, lanes, linda)
NOTE: 'allObjects' is a table containing all objects that you want to use and should be constructed in the following way:
allObjects={object, "objectID"} 
where object is the actual object and objectID is string ID that you have to create, it also has to be unique.

If you would like to add more active objects use insert new object function:
insertNewObj(object, "objID", linda)

If you would like to know more about this extension see http://active-lua.appspot.com/ for documentation

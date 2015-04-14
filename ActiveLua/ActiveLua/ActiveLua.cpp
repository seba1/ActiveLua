// luatry7.cpp : Defines the entry point for the console application.
//
//#define LUA_BUILD_AS_DLL
#include "stdafx.h"
#include <iostream>
#include "statcVars.h"
extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
}

/* Lua interpreter */
lua_State* L;

int staticVarClass::someInteger = 4;
char* staticVarClass::someString = "This is a string in static variable from C++";

int main(int argc, char *argv[])
{
	/* Initialize lua stuff*/
	L = luaL_newstate();
	/* load Lua base libraries */
	luaL_openlibs(L);
	/* load the script */
	if (luaL_loadfile(L, "main.lua")) {
		std::cerr << "Something went wrong loading the chunk (syntax error?)" << std::endl;
		std::cerr << lua_tostring(L, -1) << std::endl; // display error from lua
		lua_pop(L, 1);
	}

	/*-------------------Start Here-------------------*/

	lua_pushstring(L, staticVarClass::someString);
	lua_setglobal(L, "someString");
	if (lua_pcall(L, 0, LUA_MULTRET, 0)) {
		std::cerr << "This is from c++ :\nSomething went wrong during execution" << std::endl;
		std::cerr << lua_tostring(L, -1) << std::endl; // display error from lua
		lua_pop(L, 1);
	}

	const char* someString2 = "";
	lua_getglobal(L, "someString");
	someString2 = lua_tostring(L, -1);

	// Here in C++
	printf("\n%s", someString2);

	/* Close lua file*/
	lua_close(L);
	std::cin.get();
	return 0;
}

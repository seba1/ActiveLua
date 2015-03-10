
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


struct foo
{
static int set_i(lua_State* L);
int i;
};

int foo::set_i(lua_State* L)
{
foo* pFoo = reinterpret_cast<foo*>(lua_touserdata(L, lua_upvalueindex(1)));
pFoo->i = lua_tonumber(L, 1);
return 0;
}

int main(int argc, char *argv[])
{
foo f;

lua_State* L = lua_open();
lua_pushstring(L, "set_i");
lua_pushlightuserdata(L, &f);
lua_pushcclosure(L, foo::set_i, 1);
lua_settable(L, LUA_GLOBALSINDEX);

luaL_openlibs(L);

if (luaL_loadfile(L, "main.lua")) {
std::cerr << "Something went wrong loading the chunk (syntax error?)" << std::endl;
std::cerr << lua_tostring(L, -1) << std::endl; // display error from lua
lua_pop(L, 1);
}

if (lua_pcall(L, 0, LUA_MULTRET, 0)) {
std::cerr << "This is from c++ :\nSomething went wrong during execution" << std::endl;
std::cerr << lua_tostring(L, -1) << std::endl; // display error from lua
lua_pop(L, 1);
}

lua_close(L);
std::cin.get();
return 0;
}

};
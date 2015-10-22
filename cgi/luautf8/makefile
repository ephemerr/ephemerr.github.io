compile: lua_utf8

lua_utf8: lua_utf8.c
	$(CC) $(CFLAGS) $(LUA_CFLAGS) -fpic -I/usr/include/lua5.1/ -c lua_utf8.c 
	$(CC) $(CFLAGS) $(LUA_LDFLAGS) -shared -fpic -llua5.1 -o libluautf8.so lua_utf8.o

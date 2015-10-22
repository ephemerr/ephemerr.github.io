all:
	gcc -c `mysql_config --cflags` mysqlcli.c 
	gcc -o mysqlcli  mysqlcli.o `mysql_config --libs`

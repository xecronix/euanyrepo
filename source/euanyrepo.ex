#!/usr/bin/env eui
with trace 
include std/filesys.e 
include std/error.e 
include std/io.e 
include std/pipeio.e as pipe 
include oshelper.e

object   void = 0 
sequence InitialDir 
integer  f_debug 


sequence cmd = command_line() 
sequence info = pathinfo(cmd[2]) 
void = chdir(info[PATH_DIR]) 
InitialDir = current_dir() 
f_debug = open(InitialDir&SLASH&info[PATH_BASENAME]&".log", "w") 
crash_file(InitialDir&SLASH&info[PATH_BASENAME]&".err") 

sequence s = read_lines(InitialDir&SLASH&"dependencies.txt") 
for i = 1 to length(s) do 
    installIfNot(s[i]) 
end for 

close(f_debug) 

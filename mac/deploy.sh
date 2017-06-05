#!/usr/bin/osascript

#PLEASE DONOT EDIT THIS SCRIPT

on run argv
	set dir to quoted form of (first item of argv)
	tell app "Terminal" to do script "docker-compose up -f " & dir
end run
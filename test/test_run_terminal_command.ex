#!/usr/bin/env eui
include std/pretty.e
include std/os.e
include eushouldtest.e

function confirm_can_open_terminal()
	atom pass = 1
	if system_exec("bash ../ext/runasroot.sh \"Execute the date command as root\" date", 2) then
	    puts(2, "failure!\n")
	    pass = 0
	end if
	return pass
end function

confirmReportOrAbort(confirm_can_open_terminal(), "test_run_terminal_command:confirm_can_open_terminal")


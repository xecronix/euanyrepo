constant TRUE = 1
constant FALSE = 0
with trace

integer assertPassCount = 0
integer assertFailCount = 0
integer testPassCount = 0
integer testFailCount = 0
atom isQuiet = FALSE
sequence reportListeners = {} --function callbacks ie for logging

procedure report(atom stdWhat, sequence message)
	if isQuiet = FALSE then
		puts(stdWhat, message)
	end if
	-- TODO loop over the reportListeners
	-- for each listener call listener(std <> 2, message)
end procedure

public procedure confirm(atom bool, sequence confirmWhat, sequence fail)
	sequence message = ""
	if bool = FALSE then
		message = sprintf("FAIL %s %s", {confirmWhat, fail})
		assertFailCount +=  1
		report(2, sprintf("%s\n", {message}))
	else
		message = sprintf("PASS %s", {confirmWhat})
		assertPassCount += 1
		report(1, sprintf("%s\n", {message}))
	end if 	
end procedure

public procedure confirmReport(atom bool, sequence testName, atom andResetCounts = 1)
	atom stdWhat = 1
	sequence boolStr = {}
	if bool = 0 then
		testFailCount += 1
		stdWhat = 2
		boolStr = "FAIL"
	else
		testPassCount += 1
		boolStr = "PASS"
	end if
	report(stdWhat, sprintf("%s Test %s reporting [%d] confirm calls with [%d] passes and [%d] failures\n", 
	  {boolStr, testName, assertPassCount+assertFailCount, assertPassCount, assertFailCount}))
	if andResetCounts = TRUE then
		assertPassCount = 0
		assertFailCount = 0
	end if
end procedure

public procedure totalsReport(sequence fileName)
	atom stdWhat = 2
	sequence boolStr = "FAIL"
	if testFailCount = 0 then
		stdWhat = 1
		boolStr = "PASS"
	end if
	report(stdWhat, sprintf("%s Ran a total of [%d] tests in file %s. [%d] passed and [%d] failed\n", 
	  {boolStr, testPassCount+testFailCount, fileName, testPassCount, testFailCount}))
end procedure

public procedure beQuiet(atom isSilent=1)
	isQuiet = isSilent
end procedure

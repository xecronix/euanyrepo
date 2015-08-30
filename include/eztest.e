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

public procedure asrt(atom bool, sequence asrtWhat, sequence fail)
	sequence message = ""
	if bool = FALSE then
		message = sprintf("FAIL %s %s", {asrtWhat, fail})
		assertFailCount +=  1
		report(2, sprintf("%s\n", {message}))
	else
		message = sprintf("PASS %s", {asrtWhat})
		assertPassCount += 1
		report(1, sprintf("%s\n", {message}))
	end if 	
end procedure

public procedure asrtReport(atom bool, sequence testName, atom andResetCounts = 1)
	sequence boolStr = "PASS"
	sequence message = {}
	atom stdWhat = 1
	if bool = 0 then
		boolStr = "FAIL"
		testFailCount += 1
		stdWhat = 2
	else
		testPassCount += 1
	end if
	message = sprintf("%s %s\n", {boolStr, testName})
	report(stdWhat, sprintf("%s\n", {message}))
	report(stdWhat, sprintf("Test %s reporting [%d] asrt calls with [%d] passes and [%d] failures\n", 
	  {testName, assertPassCount+assertFailCount, assertPassCount, assertFailCount}))
	if andResetCounts = TRUE then
		assertPassCount = 0
		assertFailCount = 0
	end if
end procedure

public procedure totalsReport(sequence fileName)
	atom stdWhat = 2
	if testFailCount = 0 then
		stdWhat = 1
	end if
	report(stdWhat, sprintf("Ran a total of [%d] tests in file %s. [%d] passed and [%d] failed\n", 
	  {testPassCount+testFailCount, fileName, testPassCount, testFailCount}))
end procedure

public procedure beQuiet(atom isSilent=1)
	isQuiet = isSilent
end procedure

#!/usr/bin/env eui
include package_manager.e 
include std/pretty.e
include eushouldtest.e
function test_getPackageManagers()
	
	sequence packMan = getPackageManagers()
	sequence prettyPackMan = pretty_sprint(packMan,{3})
	sequence should
	sequence but
	atom results
	atom pass = 1
	
	should = "packMan should have a length greater than 0"
	but = "but, packMan was of length 0"
	results = length(packMan)
	confirm(results, should, but)
	pass = pass and results
	
	should = "packMan should know what yum is"
	but = sprintf("but, packMan does not [%s]", {prettyPackMan})
	results = match("yum", prettyPackMan)
	confirm(results, should, but)
	pass = pass and results
	
	return pass
end function

function test_isInstalled()
	sequence installedPackage = "gcc"
	sequence notInstalledPackage = "chinese-calendar"
	sequence should
	sequence but
	atom results
	atom pass = 1
	
	should = sprintf("package %s should be installed",  {installedPackage})
	but = "but, package_manager isInstalled couldn't find it."
	results = isInstalled(installedPackage) = 1
	confirm(results, should, but)
	pass = pass and results
	
	should = sprintf("package %s should not be installed",  {notInstalledPackage})
	but = "but, package_manager claims to have found it."
	results = isInstalled(notInstalledPackage) = 0
	confirm(results, should, but)
	pass = pass and results
	
	return pass
end function

confirmReport(test_getPackageManagers(), "test_getPackageManagers")
confirmReport(test_isInstalled(), "test_isInstalled")
totalsReport("test_package_manager")

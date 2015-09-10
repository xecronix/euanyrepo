#!/usr/bin/env eui
include package_manager.e 
include std/pretty.e
include eushouldtest.e
function confirm_getPackageManagers()
	
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

function confirm_isInstalled()
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

function confirm_installPackage()
	sequence packageToInstall = "chinese-calendar"
	sequence should
	sequence but
	atom results
	atom pass = 1
	
	sequence packMan = getPackageManagers()
	
	should = sprintf("package %s should not already be installed",  {packageToInstall})
	but = "but, package_manager claims to have found it. %s"
	but = sprintf(but, "This package needs to be removed from the system before testing can continue.")
	results = not isInstalled(packageToInstall)
	confirm(results, should, but)
	pass = pass and results
	
	-- We don't want to continue these tests because
	-- the package is already installed.  This means our
	-- test environment is bad.  
	if pass = 0 then
		return pass
	end if
		
	should = sprintf("package %s should now be installed",  {packageToInstall})
	but = "but, package_manager isInstalled couldn't find it."
	installPackage(packageToInstall, packMan)
	results = isInstalled(packageToInstall)
	confirm(results, should, but)
	pass = pass and results
	
	return pass
end function

function confirm_removePackage()
	sequence packageToRemove = "chinese-calendar"
	sequence should
	sequence but
	atom results
	atom pass = 1
	
	sequence packMan = getPackageManagers()
	
	should = sprintf("package %s should be installed",  {packageToRemove})
	but = "but, package_manager can't find it."
	results = isInstalled(packageToRemove) = 1
	confirm(results, should, but)
	pass = pass and results
	
	-- We don't want to continue these tests because
	-- the package is not installed.  This means our
	-- test environment is bad.  
	if pass = 0 then
		return pass
	end if
		
	should = sprintf("package %s should now be removed",  {packageToRemove})
	but = "but, package_manager claims it is still installed."
	removePackage(packageToRemove, packMan)
	results = isInstalled(packageToRemove) = 0
	confirm(results, should, but)
	pass = pass and results
	
	return pass
end function

-- Each of these are considered core functionality.
-- If any of these tests fail, no other tests are worth doing.
-- confirmReportOrAbort will call an abort with an non-zero exit code.
-- This means all testing will stop if any of these fail.
confirmReportOrAbort(confirm_getPackageManagers(), "test_package_manager:confirm_getPackageManagers")
confirmReportOrAbort(confirm_isInstalled(),        "test_package_manager:confirm_isInstalled")
confirmReportOrAbort(confirm_installPackage(),     "test_package_manager:confirm_installPackage")
confirmReportOrAbort(confirm_removePackage(),      "test_package_manager:confirm_removePackage")
totalsReport("test_package_manager")

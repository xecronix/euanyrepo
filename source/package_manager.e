include oshelper.e as oshelper
include std/pretty.e
sequence packageManagers ={}
enum type QUERY_TYPE INSTALLED, AVAILABLE end type
with trace

public function getPackageManagers()
	sequence retval = packageManagers
	sequence packageManager
	if length(packageManagers) = 0 then
		packageManager = oshelper:execCommand("which dnf")
		if length(packageManager) then
			packageManagers = append(packageManagers, packageManager)
		end if
		
		packageManager = oshelper:execCommand("which yum")
		if length(packageManager) then
			packageManagers = append(packageManagers, packageManager)
		end if
		
		packageManager = oshelper:execCommand("which apt")
		if length(packageManager) then
			packageManagers = append(packageManagers, packageManager)
		end if
		
		retval = packageManagers
	end if
	return retval
end function

function dnfInstall(sequence package)
	atom pass = 1
	sequence cmd = sprintf("bash ../ext/runasroot.sh \"Install %s as root\" \"dnf install %s\"", {package, package})
	if system_exec(cmd, 2) then
	    puts(2, "failure!\n")
	    pass = 0
	end if
	return pass
end function

function dnfRemove(sequence package)
	atom pass = 1
	sequence cmd = sprintf("bash ../ext/runasroot.sh \"Remove %s as root\" \"dnf remove %s\"", {package, package})
	if system_exec(cmd, 2) then
	    puts(2, "failure!\n")
	    pass = 0
	end if
	return pass
end function

function yumInstall(sequence package)
	atom success = 1
	sequence cmd = sprintf("bash ../ext/runasroot.sh \"dnf install %s as root\" \"yum install %s\"", {package, package})
	if system_exec(cmd, 2) then
	    puts(2, "failure!\n")
	    success = 0
	end if
	return success
end function

function yumRemove(sequence package)
	atom success = 1
	sequence cmd = sprintf("bash ../ext/runasroot.sh \"dnf remove %s as root\" \"yum remove %s\"", {package, package})
	if system_exec(cmd, 2) then
	    puts(2, "failure!\n")
	    success = 0
	end if
	return success
end function


function aptInstall(sequence package)
	atom success = 1
	sequence cmd = sprintf("bash ../ext/runasroot.sh \"apt-get install %s as root\" \"apt-get install %s\"", {package, package})
	if system_exec(cmd, 2) then
	    puts(2, "failure!\n")
	    success = 0
	end if
	return success
end function

function aptRemove(sequence package)
	atom success = 1
	sequence cmd = sprintf("bash ../ext/runasroot.sh \"apt-get remove %s as root\" \"apt-get remove %s\"", {package, package})
	if system_exec(cmd, 2) then
	    puts(2, "failure!\n")
	    success = 0
	end if
	return success
end function

public function installPackage(sequence package, sequence packageManagers)
	atom retval = 0
	for i = 1 to length(packageManagers)  do
		if  match("dnf", packageManagers[i]) then
			retval = dnfInstall(package)
		end if
		
		if retval = 0 and  match("yum", packageManagers[i])  then
			retval = yumInstall(package)
		end if
		
		if retval = 0 and  match("apt", packageManagers[i])  then
			retval = aptInstall(package)
		end if

		if retval = 1 then
			break
		end if
	end for
	return retval	
end function

public function removePackage(sequence package, sequence packageManagers)
	atom retval = 0
	for i = 1 to length(packageManagers)  do
		if  match("dnf", packageManagers[i]) then
			retval = dnfRemove(package)
		end if
		
		if retval = 0 and  match("yum", packageManagers[i])  then
			retval = yumRemove(package)
		end if
		
		if retval = 0 and  match("apt", packageManagers[i])  then
			retval = aptRemove(package)
		end if

		if retval = 1 then
			break
		end if
	end for
	return retval	
end function

function dnfQuery(sequence package, QUERY_TYPE queryType)
	--trace(1)
	atom retval = 0
	sequence matchValue = "Installed"
	if queryType = AVAILABLE then
		matchValue = "Available"
	end if
	sequence cmd = sprintf("dnf list %s", {package})
	sequence s = execCommand(cmd) 
	if match(matchValue, s) then
		retval = 1
	end if
	return retval
end function

function yumQuery(sequence package,  QUERY_TYPE queryType)
	atom retval = 0
	sequence matchValue = "Installed"
	if queryType = AVAILABLE then
		matchValue = "Available"
	end if
	sequence cmd = sprintf("yum list %s", {package})
	sequence s = execCommand(cmd) 
	if match(matchValue, s) then
		retval = 1
	end if
	return retval
end function

function aptQuery(sequence package,  QUERY_TYPE queryType)
    sequence s = execCommand("dpkg-query -s " & package & " | grep Status") 
    if length(s) and match("ok installed", s) then 
        return 1 
    else 
        return 0 
    end if 
end function

public function isInstalled(sequence package) 
	atom retval = 0
	for i = 1 to length(packageManagers)  do
		if  match("dnf", packageManagers[i]) then
			retval = dnfQuery(package, INSTALLED)
		end if
		
		if retval = 0 and  match("yum", packageManagers[i])  then
			retval = yumQuery(package, INSTALLED)
		end if
		
		if retval = 0 and  match("apt", packageManagers[i])  then
			retval = aptQuery(package, INSTALLED)
		end if

		if retval = 0 then
			break
		end if
	end for
	return retval
end function 

public function isAvailable(sequence package) 
	atom retval = 0
	for i = 1 to length(packageManagers)  do
		if packageManagers[i] = "dnf" then
			retval = dnfQuery(package, AVAILABLE)
		end if
		
		if retval = 0 and  packageManagers[i] = "yum"  then
			retval = yumQuery(package, AVAILABLE)
		end if
		
		if retval = 0 and  packageManagers[i] = "apt"  then
			retval = aptQuery(package, AVAILABLE)
		end if

		if retval = 0 then
			break
		end if
	end for
	return retval
end function 

public procedure installIfNot(sequence package) 
    if isInstalled(package) then 
        puts(2, package & " already installed\n") 
    else 
        puts(2, "apt-get install -y " & package & "\n") 
        sequence s = execCommand("apt-get install -y " & package) 
        puts(2, s & "\n") 
    end if 
end procedure 




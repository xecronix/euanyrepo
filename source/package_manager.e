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

public procedure removePackage(sequence package, sequence packageManagers)
	--Todo Install package using any of the the package managers provided
end procedure

public procedure installPackage(sequence package, sequence packageManagers)
	--Todo Install package using any of the the package managers provided
end procedure

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




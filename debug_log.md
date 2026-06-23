Debug Log

[2026-06-22] Questa Simulation Tool Setup Issue
# Issue
Unable to launch RTL simulation in Quartus after installing Questa.

# Symptoms
Quartus compilation succeeded, but simulation failed.

Observed errors included:
```
- make sure license file environment variable `SALT_LICENSE_SERVER`, LM_LICENSE_FILE is set correctly
- cannot find license file
```

# Initial Hypotheses
1. Questa not properly installed.
2. License file path miscondigured for environment variable `SALT_LICENSE_SERVER` and `LM_LICENSE_FILE`.

# Investigation Process
## Step 1 - Verified Simulator Installation
Tested simulator from command line
```
vsim -version
```
Result:
Questa executable was installed and accessible.

## Step 2 - Verified License File Path
Check environment variables:
```
echo %LM_LICENSE_FILE%
echo %SALT_LICENSE_SERVER%
```
Result:
Confirmed license.dat is not set to the environment variable.

## Step 3 - Checked Existance of Questa License
Searched online to see if license comes with Quartus download package.

Result:
Found that no usable license was downloaded for the simulator.

Action:

Created an Intel FPGA free licensing account and downloaded the appropriate Questa Starter Edition license.
Configured the license by etting the `SALT_LICENSE_SERVER` environment variable.
```
setx %SALT_LICENSE_SERVER% "C:\Siemens\Licenses\license.dat"
```
Restarted the system.

Restul:
Questa launch successfully.




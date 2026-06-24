Debug Log

[2026-06-22] Questa Simulation Tool Setup Issue
# Issue
Unable to launch RTL simulation in Quartus after installing Questa.

# Symptoms
Quartus compilation succeeded, but simulation failed.

Observed errors included:
```
- make sure license file environment variable `SALT_LICENSE_SERVER`, LM_LICENSE_FILE is set correctly and then run lmutil imadiag to diagnose the problem
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


## Step 4 - Set environment variable using command prompt
Configured the license by etting the `SALT_LICENSE_SERVER` environment variable.
```
setx %SALT_LICENSE_SERVER% "C:\Siemens\Licenses\license.dat"
```
Restarted the system.

Restul:
Questa launch still unsuccessful.

## Step 4 - Suspect duplicate environment variable definitio
Opened Environment Vairable Tab, found duplicate paths to the license file.

Action: 
Deleted the wrong path. Restarted the system.

Result:
Questa launch successfully.

# Root Cause
Did not download license and did not set environment variable to the correct path.


[2026-06-23] Quartus NativeLink RTL Simulation Launch Failure
### Issue
RTL simulation failed to launch in Quartus.

### Symptoms
- Quartus prompted for simulation tool language
- Language dropdown was empty
- Message indicated:
```text
Found ModelSim-Altera software installed
```
- Clicking OK resulted in:
```text
Error occurred during NativeLink execution
Check the NativeLink log file
```

### Investigation
Performed the following checks:

- Verified RTL compilation completed successfully
- Verified Questa simulator installation
- Investigated licensing configuration
- Confirmed simulator executable was accessible

This ruled out:
- RTL syntax issues
- Compilation issues
- License issues

---

### Root Cause
Quartus simulation tool configuration was incorrect.

The project was not properly configured to use the installed simulation tool.

---

### Resolution
Updated simulation settings in Quartus:

```text
Assignments → Settings → EDA Tool Settings → Simulation
```

Selected the correct simulation tool and tool configuration.

RTL simulation launched successfully afterward.

---

### Takeaways
1. Simulation launch failures are not always caused by RTL issues.
2. Quartus NativeLink is sensitive to simulation tool configuration.
3. Toolchain configuration should be verified early when debugging simulation issues.

<!--
This is a hidden note. It will not appear in the rendered view.

Fixed Tool Configurationn Issue
Demonstrated Skills:
- interpret confusing error messages
- separate toolchain issue from RTL issue
- systematically isolate root cause

-->

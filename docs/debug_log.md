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

[2026/06/27]
Milestone 3 debug log

# Bug 1 — tx_start missed due to baud_tick sampling delay
## Symptom
tx_start asserted in testbench
FSM remained in IDLE
No transition to START state

## Root Cause

FSM sampled tx_start only when baud_tick == 1.

tx_start pulse was shorter than baud interval, so it was missed.

## Fix
```verilog
reg tx_start_d;
wire tx_start_pulse;

always @(posedge clk) begin
    tx_start_d <= tx_start;
end

assign tx_start_pulse = tx_start & ~tx_start_d;
......
IDLE: begin
    if (tx_start_pulse)
        state <= START;
end
```

## Lesson
Control signals must not depend on baud-timed sampling.

# Bug 2 — START → DATA transition timing mismatch
## Symptom
FSM entered START state
Transition to DATA unreliable or delayed

## Root Cause

START → DATA transition depended on baud_tick, but timing alignment was inconsistent.

## Fix
```verilog
START: begin
    tx <= 0;

    if (baud_tick)
        state <= DATA;
end
```

## Lesson
State transitions must be aligned to baud_tick, but start detection must be independent.

# Bug 3 — tx always 0 due to shift_reg timing issue
## Symptom
state == DATA confirmed
shift_reg == 11110001 confirmed
tx always 0

## Root Cause
shift_reg was not correctly stable at the time tx was sampled.

## Fix
```verilog
DATA: begin
    if (baud_tick) begin
        tx <= shift_reg[0];
        shift_reg <= shift_reg >> 1;
    end
end
```

## Lesson
tx must always be derived from a stable snapshot of shift_reg.

# Bug 4— STOP bit timing incorrect
STOP bit not held for full baud period


Root Cause: tx updated only on baud_tick, shortening STOP duration.

Fix
```
STOP: begin
    tx <= 1;

    if (baud_tick)
        state <= IDLE;
end
```

Lesson: UART STOP bit must be held for full baud interval.

# Engineering Summary
tx_start must be edge-detected, not level-based
START state must synchronize with baud_tick
shift_reg must be loaded before DATA phase
nonblocking assignments require careful next-state reasoning
STOP bit must be held for full baud period
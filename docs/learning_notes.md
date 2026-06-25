UART = Universal Asynchronous Receiver / Transmitter

UART defines a protocol for exchanging serial data between 2 devices using 2 wires: TX and RX, without a shared clock.

[!TIP]
UART does not need an external clock line because it is **asynchronous** and relies on **pre-agreed timing and local clocks** to stay in sync.

[!NOTE]
serial = 1 bit at a time

UART is used for low-speed, low-throughput applicatoins because it is simple and cheap.

# TX/RX
TX = transmitter to receiver (DE1-SoC to computer)
        shift register -> serial output
RX = receiver to transmitter 
        serial input -> shift register
[!IMPORTANT]
When connecting devices, TX connects to RX, and RX connects to TX. If you connect TX to TX, no data will move.

## where is TX and RX
**A. The on-board UART-to-USB port**
This is a mini-usb port labeled UART on DE1-SoC.
This port connects to an on-board chip that converts FPGA serial data into a USB signal that the PC can read.

**B. The 40-pin GPIO Headers**
Let one build ones own UART controller in Verilog/VHDL to talk to a standalone Bluetooth module, GPS module or microcontroller. Will need to route TX and RX to the physical expansion headers on the board.
* GPIO_0(0) is often used as RX
* GPIO_0(1) is often used as TX

### TCL Script Assignment
If using external serial communication through the GPIO, 
```
pin_assignment.tcl
```
script will include lines to lock down those signals to the DE1-SoC pins:
```
# Example setup for connecting a serial device to GPIO_0
set_location_assignment PIN_AC18 -to uart_rx
set_location_assignment PIN_Y17  -to uart_tx

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart_rx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart_tx

```
## simplex
data send in one direction only.
## half-duplex
each side speaks but only one at a time.
## full-duplex
both sides transmit simultaneously.

# timing/synchronization
UART is asynchronous - transmitter and receiver do not share a common clock. So they must transmit at the same speed (baud rate) and the same structure/parameters (UART frame).

## UART frame
consists of
* start bits
* stop bits
* data bits
* parity bit (optional)

UART protocol does not specify the high or low voltage levels.
In idle state, the line is held high, "a mark", rather than low, a "space". 

[!TIP]
Idle is default high (achieved using a pull-up circuit) becuase can be used to check start bit (falling edge), it has better noise margin and is enables easier synchronization.

### start bit
a transition from idle to low. A falling edge signals the beginning of the communication.

### stop bit
either:
* a transitoin from low to idle. It is high becuase it gives receiver recovery time. It marks the end of a UART frame, it also returns to idle stage.

or 
* a remaining in the high for additional bit time.

A second, optional, stop bit can be configured.

The existence of the stop bit:
1. allows the receiving device's hardware to process the previous byte.
2. prevents timing drift.
3. creates a required voltage transition for detecting the next start bit.
4. acts like an bookend.

### date bits
* come immediately after the start bit.
* 5-9 bits, usually 7 or 8.
* typically sent with LSB first.

[!NOTE]
LSB first due to hardware optimization and historical legacy.
* in early shift-register-based electronics, sending LSB first simplidied the hardware design.
* sending LSB first aligns nicely with little-endian processing, since lower-value bits represent smaller mathematical shifts. This means, when the UART receiver gets the first incoming bit, and if a small clock timing error occurs at the start, moving or misinterpreting that LSB onlu skews the total numeric value by a tiny fraction. It minimizes the impact of data noise compared to accidentally shift an MSB, which would corrupt the number by 128.

#### example
to send letter "S", which has a 7-bit ASCII code of 1010011, the LSB order would be 1100101

### parity bit
* used for single-bit error detection
* inserted between end of data bit and the stop bit.
* even parity: parity bit takes value so that number of 1s in the bit is even.
* odd parity: parity bit takes value so that number of 1s in the bit is odd.
* for "S", there are already 4 1s, so the even parity bit is 0, and the odd parity bit is 1.

## baud rate
the rate at which signals can change. Unit is baud (Bd), a measurement of speed. 

1 baud = signal changes once per second OR one pulse per second.

115200 bauds = 115200 bits per second = 14400 bytes per second.

Mismatched baud rates cause data corruption:
* framing error: receiver samples a low bit instead of a high bit for the stop bit, triggers a Framing Error flag.
* gargabe data: for example, a single long bit from a slow transmitter might be read as two separate bits by a fast receiver. This turns valid characters into random, unrecognizable bytes.
* overrun errors: a fast transmitter sends bytes quicker than the slow receiver can process and clear them from its buffer, new data overwrites unread data.

UART typically tolerates a maximum baud rate discrepancy of +/- 2.5% to 4.5%.

## bit time
is 1/baud rate.

115200 = 8.68 us per bit.

## bit rate
the rate at which data is sent in bits per second. Unit is bps, a measurement of speed.

IF there are only 2 voltage levels, then the signal has a baud rate of 1 Bd, and a bit rate of 1 bps.

[!TIP]
IF there are 4 distinct voltage levels, then 1 bit is not enough to represent all voltage levels, 2 bits are required in this case. For example, 00 => 0 V, 01 => 2 V, 10 => 5 V , 11 => 10 V. Since the pulses still change once per second, the baud rate is still 1 Bd. But now the bit rate is 2 bps, becuase each signal represents 2 bits.

## bandwidth
is the maximum rate of data transfer, can be measured in bps.

Bandwidth is shared within the same network, so if many people are using a network, their individual bite rates will be less than the bandwidth. Just like sharing wifi at home.

## FPGA clock vs UART timing
DE1-SoC has 50MHz clock, and UART has 115200 baud.

50,000,000 / 115200 = 434 cycles per bit

which means FPGA outputs/samples 1 bit everu 434 clock cycles.

## mid-bit sampling
RX must perform intelligent sampling because UART has no clock sync. mid-bit sampling is one of the tricks and it goes like this: detect start edge -> wait half bit time -> sample center of bit -> repeat every bit time.

edge area is noisy and unstable.

## oversampling
the receiver determines the sampling point by using this technique, which acts as an internal clock to map out each bit.

process:
1. detect the start bit (falling edge from the idle state)
2. divide the bit with oversampling; the receiver typically uses an internal clock that is 16 times or 8 times faster than the target baud rate; if uses 16x oversampling, each bit width is divided into 16 equal time slices or clock cycles.
3. verify the start: once falling edge detected, receiver counts 8 clock cycles (halfway through the 16 clock cycles within the single bit), then it samples the line, if it is still low, it confirms a valid start bit, not a noise spike.
4. from the mid-point of the start bit, the receiver knows the center of the next bit is 16 clock cycles away.
5. the receiver counts 16 clock cycles, samples the first data bit, counts another 16 clock cycles, samples the second bit, repeats until it reads the stop bit.
6. to avoid errors from electrical noise, UART modules do not just sample once. They take 3 distinct samples around the center of the bit, like at clock cycles 7,8 and 9 of the 16x window.
7. the receiver uses a majority bote (2 out of 3) to determine if the bit is a 0 or a 1.

# Milestone 2 Baud Rate Generator
This milestone aims to produce a 115200 baud rate generator and complete its simulation on Questa.

FPGA clock runs at 50 MHz, but UART communication requires 115200 baud.
How many times must my high-speed system clock tick before exactly one bit-period/one oversampling slice has passed?

## calculations
FPGA has 50000000 cycles per second clock, which means the clock ticks 50 million times in one second;
the inverse of this number is the clock period:
1/50000000 = 2e-8, which means it takes 2e-8 seconds for every clock tick;
since we want 115200 bits per second,
for standard 16x oversampling modules, receiver will need to process
115200*16 = 1843200 bits per second,
the inverse of this number is the time needed for one bit to be processed:
1/1843200 = 5.425e-7 bit time;
the goal is to find how many times must the high-speed system clock tick before exactly one oversampling slice has passed;
so total bit time/one cycle time = x number of cycles to process one bit:
5.425e-7/2e-8 = (1/1843200) / (1/50000000) = 50000000/1843200 = 27 cycles.

This aligns with the formula:
$Register Value = /frac{f_clock}{Oversampling * Baud Rate}$

[!TIP]
Register Value is the number written into the hardware called Baud Rate Register, this register will do countdowns repeatedly, starting from the register value. When it hits 0, it sends out a pulse that tells the UART to sample the wire or shift out a bit. 

Note that TX does not require oversampling. So its Register Value is:
$RV_TX = /frac{50000000}{115200} = 434$

## CLOCK_50 and Pin Assignment
When writing the top level module
```uart_fpga.v```
there is an input 
```CLOCK_50```

How does Quartus know that this means something?
The answer is
==> Pin Assignment

in other words:
```.qsf```
file, which stands for project setting file.

Inside the .qsf there is a line 
```set_location_assignment PIN_AF14 -to CLOCK_50```
that connects the physical FPGA pin AF14 to the keyword `CLOCK_50`.

### Check Pin Assignment
#### On Quartus
Assignment -> Pin Planner
see if a location is assigned to the node "CLOCK_50".

#### in .qsf file
Open the uart_fpga.qsf file with NotePad, look for
```set_location_assignment Pin_AF14 -to CLOCK_50```

## Run Simulation on Questa
Best create a standalone Questa project than using RTL Simulation on Quartus to open Questa for you.

```vlib work``` creats a physical directory to save compiled data in the same dir as  the project file .mpf (Mentor Project File).

Only need to run ONCE for every project.

```vmap work work``` links the logical name "work" to that directory.

```vlog leaf_module.v tb_leaf_module.v``` compiles the listed design files. After compiling, can access the files uing ```work.file.v```.

[!NOTE]Must use relative path when using vlog.

```vsim -voptargs="+acc" work.tb_leaf_module``` load the simulation into memory with optimization arguments enabled.
Important for debugging. It tells Questa's optimizer to preserve internal wire and register names so can see in wave window.

```add wave -r /*``` adds all signals to the waveform viewer. "r" stands for recursive, grabs all signals from top-level testbench and inner leaf module structures.

```run -all``` runs the simulation. Stops until hits ```$stop``` or ```$finish``` in tb.

```run 100us``` to run for a specific duration.

or can use ";" to run multiple commands at one line:
```vlog leaf_module.v tb_leaf_module.v; restart -f; run -all```

```f``` stands for force, resets simulation clock back to 0 ns and clears waves without closing GUI, keeping current wave zoom levels.

# Milestone 3 UART Transmitter TX FSM
Design a complete finite state machine to realize serial transmission.
The inputs are 
```verilog  
clk
rst
baud_tick
tx_start
data_in[7:0]
```

## Learning Objective
- understand serial transimission and serial stream
- grasp UART frame transmission sequence
- FSM design
- shift register behavior
- clock domain vs baud domain


# Rotary-encoder-VHDL-design
VHDL design for rotary encoder. Can be used accessed via digital signals or AXI interface.

#Hardware
The rotary encoder for this project was purchased here:

https://www.aliexpress.com/item/Rotary-Encoder-Module-24-steps/32678025587.html

It can be powered from 5V or from 3.3V supply.

For the design the Digilent Zybo VHDL board was used. The encoder board fits directly into the PMOD for first fast tests.

#Operation
The inputs from the encoder are debounced using debouncer with time setting of about 300 us. This was experimentally set as a good value when you use the encoder for hand-turning for controlling anything the logic. This time is depended on the main clock. The clock for this project was used 100 MHz. The time can be calculated by the equation:

2^counter_size/CLKf
so, 15 bits gives 327us with 100MHz clock and 19 bits gives 10.5ms with 50MHz clock

Inputs are processed by component x1enc2.vhd. It is adjusted version from x4enc2.vhd. The difference is that x1enc2 creates one pulse per encoder "click" when turning. the x4enc2 generates 4 pulses for real quadrature output. 
I was going for only one pulse, since I use encoder to hand-control stuff.

UD_out(0) .. up-down out will generate one-clock-wide pulse when encoder is turned one "click" to one direction
UD_out(1) .. up-down out will generate one-clock-wide pulse when encoder is turned the other "click" to one direction

UD_latching works in similar manner, but pulse latches and stays at the changed state. For example: encoder is turned right one step, signal UD_latching changes from 00 to 01 and stays in this state until pulse on the input clear_latch is present. Then it resets back to 00. This funtionality is used for AXI interface, when latch is cleared when register is read from the processor (clear on read).

#Usage
Design can be used as only in VHDL project (no need to include my_rotary_encoder... files). Or it can be used with AXI interface for the processor.

#AXI register
register is at base address of the AXI

bit|31-6|5|4|3|2|1|0
---|---|---|---|---|---|---|---
||X|U|D|X|X|X|SW

* X not used bits
* U	latching output from rotation of encoder to one side
* D	latching output from rotation of encoder to the other side
* SW	latching output of switch rising edge. When sw is pressed this stays H till read. 
*	the register clears on read

#Sources
Design is based on code from these pages:

* https://eewiki.net/pages/viewpage.action?pageId=4980758
* http://dew.ninja/vhdl-code-for-quadrature-encoder-receiver-module/


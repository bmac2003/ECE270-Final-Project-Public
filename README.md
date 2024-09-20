# ECE270-Final-Project
Digital System Design drum machine final project files

This repository contains all files used to create my final project for Purdue's Digital System Design class, an 8-bit drum machine written on an FPGA 
integrated circuit that can be output directly to an audio port.  My design enabled the user to connect to an audio port and either edit a sequence containing
combinations of four samples across 8 beats and play it back or use 4 buttons to play the samples directly to the audio output.  

An example of the working design can be found in the drumbit.mp4 file; it shows the full functionality of the system which my design was able to match 
completely.

All .jpg files contain RTL diagrams for the modules used, logical circuit representations of the flip-flops and other elements used in the module design.
They also contain the flip-flop logic written in System Verilog, a requirement of the class.

project/audio contains the four 8-bit audio files that are loaded into the registers and played back as samples to the output

project/tests contains testing sequences for all of the modules used to create the drum machine, provided by the class

project/workdir contains the .sv files that constitue the System Verilog I wrote to build the drum machine.  They were all written from scratch to pass the
tests provided to us and then integrated into the top.sv module to implement the actual functionality of the program.  (These files have been removed so that 
I can make this repository public)

project/build and project/support were used to verify some elements of the design but were provided by the class

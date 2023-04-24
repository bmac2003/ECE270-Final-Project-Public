# ECE270-Final-Project
Digital System Design drum machine final project files

This repository contains all files used to create my final project for Purdue's Digital System Design class, an 8-bit drum machine written on an FPGA 
integrated circuit that can be output directly to an audio port.  My design enabled the user to connect to an audio port and either edit a sequence containing
combinations of four samples across 8 beats and play it back or use 4 buttons to play the samples directly to the audio output.  

All .jpg files contain RTL diagrams for the modules used, logical circuit representations of the flip-flops and other elements used in the module design.
They also contain the flip-flop logic written in System Verilog, a requirement of the class.

project/audio contains the four 8-bit audio files that are loaded into the registers and played back as samples to the output

project/

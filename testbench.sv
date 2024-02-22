`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2023 06:32:21
// Design Name: 
// Module Name: testhack
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testhack();
  
  reg [1:0] mode1,mode2;
  reg [3:0] inmux,inenc1;
  reg indemux;
  reg [1:0] indec1,indec2;
  reg [1:0] seldemux, selmux;
  wire outmux1, outmux2;
  wire [3:0] outdemux,outdec1,outdemux2,outdec2;
  wire [1:0] outenc1,outenc2;
  reg reset;
  reg clk;
  
  top t1(mode1,mode2,inmux,inenc1,indemux,indec1,indec2,seldemux,selmux,outmux1,outmux2,outdemux,outdec1,outdemux2,outdec2,outenc1,outenc2,reset,clk);
  
  initial begin 
  clk = 1;
    forever begin
    #5 clk = ~clk;
    end
 end 

 
  
  initial
    begin
      mode1=2'b01;
      @(posedge clk);
      mode2=2'b00;
      inmux=4'b1001;
      selmux=2'b00;
      @(posedge clk);
      indemux=1;
      seldemux=2'b10;
      #40;
      $finish;
    end
  
  

endmodule

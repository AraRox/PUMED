`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIITDM
// Engineer: SAMRAT & ARAVIND
// 
// Create Date: 08.10.2023 04:47:17
// Design Name: 
// Module Name: top
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




class Encoder4x2;
  bit [3:0] inputs;
  bit [1:0] enc_out;

  function new(input [3:0] inp, output [1:0] out);
    begin
    inputs = inp;
    enc_out = out;
    end
  endfunction

  function void perform_encoding(output [1:0] out);
    // Implementing 4x2 encoder using NAND gates
  begin
    enc_out[0] = ~(~inputs[0] & ~inputs[1]);
    enc_out[1] = ~(~inputs[2] & ~inputs[3]);
    out = enc_out;
    end
  endfunction

  function void display();begin
    $display("Inputs: %b", inputs);
    $display("Output: %b", enc_out);
    end
  endfunction
endclass

class Demux1x4;

  // Input and output variables
  bit [1:0] select;
  bit data_in;
  bit [3:0] outputs;

  // Constructor
  function new(input [1:0] sel, input data, output [3:0] out);
    begin
    select = sel;
    data_in = data;
    out = outputs;
    end
  endfunction

  // Method to perform Demux operation
  function void demux_operation(output [3:0] out);
    begin
  //  $display("s0,s1 = %d , %d", select[0],select[1]);
    outputs[0] = data_in & (~select[0] & ~select[1]);
    outputs[1] = data_in & (select[0] & ~select[1]);
    outputs[2] = data_in & (~select[0] & select[1]);
    outputs[3] = data_in & (select[0] & select[1]);
    out = outputs;
 //   $display("out = %d", out);
    end
  endfunction

  // Display function
  function void display();
    $display("Select: %b, Data In: %b", select, data_in);
    $display("Outputs: %b", outputs);
  endfunction

endclass

class Mux4x1;
  bit [1:0] select;
  bit [3:0] data_in;
  bit mux_out;

  function new(input [1:0] sel, input [3:0] data, output out);
    select = sel;
    data_in = data;
    mux_out = out;
  endfunction

  function void perform_mux(output out);
    // Implementing 4x1 MUX using NAND gates
    mux_out = ~((~data_in[0] & select[1]) & (~data_in[1] & select[0]) &
               (~data_in[2] & ~select[0]) & (~data_in[3] & ~select[1]));
    out = mux_out;
  endfunction

  function void display();begin
    $display("Select: %b", select);
    $display("Data Inputs: %b %b %b %b", data_in[0], data_in[1], data_in[2], data_in[3]);
    $display("Output: %b", mux_out);end
  endfunction
endclass


class Decoder2x4;
  bit [1:0] select;
  bit [3:0] outputs;
  
  function new(input [1:0] sel, output [3:0] out);
    select = sel;
    outputs = out;
  endfunction

  function void perform_decoding(output [3:0] out);
    // Implementing 1x4 decoder using NAND gates
    begin
    outputs[0] = (~select[0] & ~select[1]);
    outputs[1] = (select[0] & ~select[1]);
    outputs[2] = (~select[0] & select[1]);
    outputs[3] = (select[0] & select[1]);
    out = outputs;
    end
  endfunction

  function void display();
    begin
    $display("Select: %b", select);
    $display("Outputs: %b %b %b %b", outputs[0], outputs[1], outputs[2], outputs[3]);
    end
  endfunction
endclass


module top(
  input [1:0] mode1,mode2,
  input [3:0] inmux,inenc1,
  input indemux,
  input [1:0] indec1,indec2,
  input [1:0] seldemux, selmux,
  output reg outmux1, outmux2,
  output reg [3:0] outdemux,outdec1,outdemux2,outdec2,
  output reg [1:0] outenc1,outenc2,
  input reset,
  input clk
);
  Demux1x4 demux1,demux2, demux3;
  Mux4x1 mux1,mux2,mux3;
  Encoder4x2 enc1,enc2,enc3;
  Decoder2x4 dec1,dec2,dec3;
 
//  reg [3:0] demux_out, register;
  
    reg temp_indemux;
    reg [3:0] temp_outdemux;
    reg [1:0] temp_seldemux;
    reg temp_inmux;
    reg [3:0] temp_outmux;
    reg [1:0] temp_selmux;
  // Stage 1
  always@(posedge clk) begin
    if (mode1==2'b00 || mode2==2'b00) begin
     demux1 = new(seldemux,indemux,outdemux);
     temp_indemux <= demux1.data_in;
     temp_outdemux <= demux1.outputs;
     temp_seldemux <= demux1.select;
 //    demux1.display();
//     #10
     demux2=new(temp_seldemux,temp_indemux,temp_outdemux);
     demux2.demux_operation(outdemux2);
 //    demux2.display();
  //   #10
//     demux3=new(sel,indemux,outdemux);
//     demux3.display();
     end
    else if (mode1==2'b01 || mode2==2'b01) begin
     mux1 = new(selmux,inmux,outmux1);
     temp_inmux <= mux1.data_in;
     temp_outmux <= mux1.mux_out;
     temp_selmux <= mux1.select;

  //   #10
     //mux2<=mux1;
     mux2=new(temp_selmux,temp_inmux,temp_outmux);
          $display("temp_outmux = %b",temp_outmux);
     mux2.perform_mux(outmux2);
//     #10 
     //mux3<=mux2;
  //   mux3.display();
     end
//    else if (mode1==2'b10 || mode2==2'b10)
//    begin
//    demux1 = new(sel,indemux,outdemux);
//     #10
//     //demux2<=demux1;
//     demux2.demux_operation(outdemux2);
//     #10
//     //demux3<=demux2;
//     demux3.display();
//     end
    else if (mode1==2'b11 || mode2==2'b11) begin
     enc1 = new(inenc1,outenc1);
     #10
     //enc2<=enc1;
     enc2.perform_encoding(outenc2);
     #10 
     //enc3<=enc2;
     enc3.display();
    end
    else begin
     dec1 = new(indec1,outdec1);
     #10
     //dec2<=dec1;
     dec2.perform_decoding(outdec2);
     #10 
     //dec3<=dec2;
     dec3.display();
    end
  end
  
  
  
  
//  initial 
//    begin 
//      #1
//      demux = new(sel2,in1,out1,en_out[3]);
//      #2
//      mux = new(sel3,in2,out2,en_out[2]);
//      #1
//      enc = new(in3,out3,en_out[1]);
//      #1
//      dec = new(in4,out4,en_out[0]);
//    end
    
    
//  initial
//    begin
//      #5;

//      #2;
//      demux2.demux_operation(out1);
//      demux2.display();
//      #2
//      mux.perform_mux(out2);
//      mux.display();
//      #1
//      enc.perform_encoding(out3);
//      enc.display();
//      #1
//      dec.perform_decoding(out4);
//      dec.display();
//    end
  
  
  

  
endmodule

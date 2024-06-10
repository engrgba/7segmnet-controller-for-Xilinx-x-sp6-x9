`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:57:40 06/03/2024 
// Design Name: 
// Module Name:    Seven_Seg_Display_Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top_module(
    input wire clk,
	 input wire d_p,
	 input wire [3:0] sw,
	 input wire [7:0] data,
	 output wire [6:0] a_to_g,
	 output wire [7:0] en,
	 output wire dp
	 );
	 
	 reg [3:0] sw1;
	 reg [3:0] sw2;
	 
	 always@(posedge clk)
	 begin
			sw1 <= sw;
		   sw2 <= sw1;
	 end
	//assign en = 8'b11100111;
	assign dp = d_p;
	
hex7seg D1(
				.x(data),
				.a_to_g(a_to_g)
				);
endmodule
 
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:41:24 06/13/2024 
// Design Name: 
// Module Name:    KIT7_SEG_TOP 
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
module KIT7_SEG_TOP(
		input  wire        i_clk,
		input  wire        i_uart_rx,
		output wire        o_uart_tx,
		output wire [6:0]  a_to_g,
		output wire [7:0]  en  
	
    );

wire [31:0] wrx_data_reg0;
wire [31:0] wrx_data_reg1;
wire [31:0] wrx_data_reg2;
wire [31:0] wrx_data_reg3;
wire [31:0] wrx_data_reg4;
wire [31:0] wrx_data_reg5;
wire [31:0] wrx_data_reg6;
wire [31:0] wrx_data_reg7;

wire [7:0]data1;
//wire [7:0]en;
	 
Wishbone_Controller wc1(
								.i_clk(i_clk),
								.i_uart_rx(i_uart_rx),
								.o_uart_tx(o_uart_tx),
								
								.rx_data_reg0(wrx_data_reg0),
								.rx_data_reg1(wrx_data_reg1),
								.rx_data_reg2(wrx_data_reg2),
								.rx_data_reg3(wrx_data_reg3),
								.rx_data_reg4(wrx_data_reg4),
								.rx_data_reg5(wrx_data_reg5),
								.rx_data_reg6(wrx_data_reg6),
								.rx_data_reg7(wrx_data_reg7)
								);
								
ENABLER              e1(
								.i_clk(i_clk),
								.data(data1),
								.en(en),
								.rx_data_reg0(wrx_data_reg0),
								.rx_data_reg1(wrx_data_reg1),
								.rx_data_reg2(wrx_data_reg2),
								.rx_data_reg3(wrx_data_reg3),
								.rx_data_reg4(wrx_data_reg4),
								.rx_data_reg5(wrx_data_reg5),
								.rx_data_reg6(wrx_data_reg6),
								.rx_data_reg7(wrx_data_reg7)
							);
hex7seg seg(
					.x(data1),        //8-bit
					.a_to_g(a_to_g) //7-bit  
					); 
					
wire [255:0]DATA;
wire [35:0]CONTROL0;

ila ila (
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
    .CLK(i_clk), // IN
    .DATA(DATA), // IN BUS [255:0]
    .TRIG0(en) // IN BUS [7:0]
);

icon cntrl (
    .CONTROL0(CONTROL0) // INOUT BUS [35:0]
);

assign DATA[6:0]   = a_to_g;
assign DATA[14:7]  = en;
assign DATA[22:15] = data1;
endmodule

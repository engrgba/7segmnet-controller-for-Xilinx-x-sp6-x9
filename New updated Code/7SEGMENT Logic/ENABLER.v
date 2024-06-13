`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:53:06 06/13/2024 
// Design Name: 
// Module Name:    ENABLER 
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
module ENABLER(
		input wire        i_clk,
		input wire [31:0] rx_data_reg0,
		input wire [31:0] rx_data_reg1,
		input wire [31:0] rx_data_reg2,
		input wire [31:0] rx_data_reg3,
		input wire [31:0] rx_data_reg4,
		input wire [31:0] rx_data_reg5,
		input wire [31:0] rx_data_reg6,
		input wire [31:0] rx_data_reg7,

		output wire [7:0] data,
		output wire [7:0] en  
		);

reg [19:0] clk_counter = 20'd0; 
reg [2:0] en_count     = 3'd0;
reg [7:0]enable;
reg [7:0]index_data;

always@(posedge i_clk)
begin
	if (clk_counter == 'd125000)
	begin
			en_count <= en_count +1;
			clk_counter <= 0;
			
			if(en_count == 3'd0)
				begin enable <= 8'b01111111;  index_data <= rx_data_reg0[7:0];   end
		else if(en_count == 3'd1) 
				begin enable <= 8'b10111111;  index_data <= rx_data_reg1[7:0];   end
		else if(en_count == 3'd2) 
				begin enable <= 8'b11011111;  index_data <= rx_data_reg2[7:0];   end
		else if(en_count == 3'd3) 
				begin enable <= 8'b11101111;  index_data <= rx_data_reg3[7:0];   end
		else if(en_count == 3'd4) 
				begin enable <= 8'b11110111;  index_data <= rx_data_reg4[7:0];   end
		else if(en_count == 3'd5) 
				begin enable <= 8'b11111011;  index_data <= rx_data_reg5[7:0];   end
		else if(en_count == 3'd6) 
				begin enable <= 8'b11111101;  index_data <= rx_data_reg6[7:0];   end
		else if(en_count == 3'd7) 
				begin enable <= 8'b11111110;  index_data <= rx_data_reg7[7:0];   end
		else en_count  <= 3'd0;
	end
	else clk_counter <= clk_counter +1;
		
		
end

assign en   = enable;
assign data = index_data;

endmodule

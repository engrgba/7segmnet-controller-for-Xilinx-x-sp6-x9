`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Teresol Pvt Ltd
// Engineer: Gul Bahar Ali
// 
// Create Date:    11:08:31 05/24/2024 
// Design Name:    
// Module Name:    Wishbone_Controller 
// Project Name: 
// Target Devices: Xilinx X-SP6-X9
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
module Wishbone_Controller(
        input wire  i_clk,
        input wire  i_uart_rx,
        output wire o_uart_tx,
		  
	output wire [6:0] a_to_g,
	output wire [7:0] en,

		

        output reg         o_wb_we,
        output reg         o_wb_cyc,
        output reg         o_wb_stb,
	output reg  [3:0]  o_wb_sel,
        output reg  [1:0]  o_wb_addr,
        output reg  [31:0] o_wb_data
		  
        );
		  	
wire 		   i_wb_ack;
wire [31:0] i_wb_data;

reg  [31:0] rx_data_reg0 = 32'd0;
reg  [31:0] rx_data_reg1 = 32'd0;
reg  [31:0] rx_data_reg2 = 32'd0;
reg  [31:0] rx_data_reg3 = 32'd0;
reg  [31:0] rx_data_reg4 = 32'd0;
reg  [31:0] rx_data_reg5 = 32'd0;
reg  [31:0] rx_data_reg6 = 32'd0;
reg  [31:0] rx_data_reg7 = 32'd0;

reg  [2:0]  byte_num      = 3'd0;
reg [7:0]   enable        = 8'd0;
reg [2:0]   en_count      = 3'd0;
reg [19:0]  clk_counter   = 20'd0;
reg  [7:0]  index_data    = 8'd0;
wire [7:0]  data;

reg [25:0] t_a_time      = 26'd0; 

 
  wbuart wbu(
						.i_clk(i_clk),
						.i_reset(1'b0),
						.i_uart_rx(i_uart_rx),
						.o_wb_ack(i_wb_ack),
						.o_wb_data(i_wb_data),
						.i_wb_we(o_wb_we),
						.i_wb_cyc(o_wb_cyc),
						.i_wb_stb(o_wb_stb),
						.i_wb_sel(o_wb_sel),
						.i_wb_addr(o_wb_addr),
						.i_wb_data(o_wb_data),
						.o_uart_tx(o_uart_tx)
						);

wire [35:0]CONTROL0;
						

						
localparam IDLE        			 	= 3'd0,//states
			  UART_SETUP   		= 3'd1,
			  Setup_wait            = 3'd2,
			  UART_RX               = 3'd3,
			  Ack          		= 3'd4,
			  UART_TX		= 3'd5,
			  UART_TX_ACK		= 3'd6,
			  Turn_Around_time      = 3'd7;
			  
			  
			  
			  
	reg [2:0]state = IDLE;
	
always@(posedge i_clk)
begin
					 
       
		 case(state) 
		 IDLE: //0
						begin
						         state      <= UART_SETUP;
									o_wb_sel   <= 4'b1111;
									o_wb_we    <= 1'b1;
									o_wb_stb   <= 1'b1;
                                                                        o_wb_cyc   <= 1'b1;
									o_wb_addr  <= 2'b00;
									o_wb_data  <= 32'd434;
									t_a_time   <= 26'd0;
									
						end
							
		 UART_SETUP://1
						begin
							 if(i_wb_ack)
							 begin
									o_wb_we    <= 1'b0;
									o_wb_stb   <= 1'b0;
									o_wb_cyc   <= 1'b0;
									state      <= Setup_wait;
									t_a_time   <= 26'd0;
								end
							  else state <= UART_SETUP;
							  
						end
		Setup_wait://2
					begin
							 if(t_a_time == 26'd50000000)
									begin
									 state    <= UART_RX;
									 t_a_time <= 26'd0;
									end
									else   
									  begin
									  	t_a_time <= t_a_time+1;
										state    <= Setup_wait;
									  end
					end

		UART_RX://3
						begin
							  o_wb_we    <= 1'b0;					//continously wants to receive data from core
							  o_wb_stb   <= 1'b1;
							  o_wb_cyc   <= 1'b1;
							  o_wb_addr  <= 2'b10;
							  state      <= Ack;
						 end
		Ack://4
					begin
						if(i_wb_ack)
								if(i_wb_data[8] == 1'b0)			//whenever core gives valid data, display that on 7 segments and do not read until
								begin
							       o_wb_we      <= 1'b0; 
									 o_wb_cyc     <= 1'b0;
									 o_wb_stb     <= 1'b0;
									 o_wb_cyc     <= 1'b0;
									 
									 
									 if(byte_num == 3'd0)
													begin rx_data_reg0  <= i_wb_data;  state   <= UART_TX; end
									 else if(byte_num == 3'd1)
													begin rx_data_reg1  <= i_wb_data;  state   <= UART_TX; end
									else if(byte_num == 3'd2)
													begin rx_data_reg2  <= i_wb_data;  state   <= UART_TX; end
									else if(byte_num == 3'd3)
													begin rx_data_reg3  <= i_wb_data;  state   <= UART_TX; end
									else if(byte_num == 3'd4)
													begin rx_data_reg4  <= i_wb_data;  state   <= UART_TX; end
									else if(byte_num == 3'd5)
													begin rx_data_reg5  <= i_wb_data;  state   <= UART_TX; end
									else if(byte_num == 3'd6)
													begin rx_data_reg6  <= i_wb_data;  state   <= UART_TX; end
									else if(byte_num == 3'd7)
													begin rx_data_reg7  <= i_wb_data;  state   <= UART_TX; end
									
								 end	
								 else 
								 begin
									  state <= Turn_Around_time;     //if core gives data which is not valid, disable read operation for 30us and then read again
									  o_wb_we      <= 1'b0;
									  o_wb_cyc     <= 1'b0;
									  o_wb_stb     <= 1'b0;
									  o_wb_cyc     <= 1'b0;
									  t_a_time     <= 26'd0;
								end
						else state <= Ack;					 
						
					end	
			UART_TX://5
						begin
								o_wb_we      <= 1'b1; 
								o_wb_cyc     <= 1'b1;
								o_wb_stb     <= 1'b1;
								o_wb_cyc     <= 1'b1;
								o_wb_addr    <= 2'b11;
								 if(byte_num == 3'd0) 
											begin o_wb_data    <= rx_data_reg0; byte_num <= byte_num + 1; state  <= UART_TX_ACK;  end
								 else if(byte_num == 3'd1)
											begin o_wb_data    <= rx_data_reg1; byte_num <= byte_num + 1; state  <= UART_TX_ACK;  end
								 else if(byte_num == 3'd2)
											begin o_wb_data    <= rx_data_reg2; byte_num <= byte_num + 1; state  <= UART_TX_ACK;  end
								 else if(byte_num == 3'd3)
											begin o_wb_data    <= rx_data_reg3; byte_num <= byte_num + 1; state  <= UART_TX_ACK;  end
								 else if(byte_num == 3'd4)
										        begin o_wb_data    <= rx_data_reg4; byte_num <= byte_num + 1; state  <= UART_TX_ACK;  end
								 else if(byte_num == 3'd5)
											begin o_wb_data    <= rx_data_reg5; byte_num <= byte_num + 1; state  <= UART_TX_ACK;  end
								 else if(byte_num == 3'd6)
											begin o_wb_data    <= rx_data_reg6; byte_num <= byte_num + 1; state  <= UART_TX_ACK;  end
								 else if(byte_num == 3'd7)
											begin o_wb_data    <= rx_data_reg7; byte_num <= byte_num + 1; state  <= UART_TX_ACK;  end
						end
						
			UART_TX_ACK://6
						begin
								o_wb_stb     <= 1'b0;
								if(i_wb_ack)
								begin
									 o_wb_we      <= 1'b0; 
									 o_wb_cyc     <= 1'b0;
									 
									 o_wb_cyc     <= 1'b0;
									 t_a_time     <= 26'd0;
									 state        <= Turn_Around_time;
								end
								else state       <= UART_TX_ACK;
						end
						
		Turn_Around_time://7
						begin
							if(t_a_time == 26'd1500)				//wait for 30us after each byte received whether valid or invalid
								begin
									 t_a_time <= 26'd0;
									 state    <= UART_RX;
								end
							else   
								begin
									t_a_time <= t_a_time+1;
									state    <= Turn_Around_time;
								end
						end
		
				
			default: state <= IDLE;
			endcase
			
										
end  



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
		else en_count <= 3'd0;
	end
	else clk_counter <= clk_counter +1;
		
		
end

assign en = enable;
assign data = index_data;

 hex7seg seg(
					.x(data), //4-bit
					.a_to_g(a_to_g) //7-bit  
					); 

  
wire [255:0]DATA;

ila ila (
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
    .CLK(i_clk), // IN
    .DATA(DATA), // IN BUS [255:0]
    .TRIG0(i_wb_ack) // IN BUS [7:0]
);

icon cntrl (
    .CONTROL0(CONTROL0) // INOUT BUS [35:0]
);

assign DATA[2:0] = en_count;	
assign DATA[5:3] = byte_num;
assign DATA[13:6] = data;

endmodule


 

































































/*
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:08:31 05/24/2024 
// Design Name: 
// Module Name:    Wishbone_Controller 
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
module Wishbone_Controller(
        input wire  i_clk,
		  input wire  i_uart_rx,
		  output	wire o_uart_tx,
		  
		  output wire [6:0]a_to_g,
		  output wire [7:0]en,

		

        output reg         o_wb_we,
        output reg         o_wb_cyc,
        output reg         o_wb_stb,
		  output reg  [3:0]  o_wb_sel,
        output reg  [1:0]  o_wb_addr,
        output reg  [31:0] o_wb_data
		  
        );
		  	
wire 		   i_wb_ack;
wire [31:0] i_wb_data;

reg  [31:0] rx_data_reg0 = 32'd0;
reg  [31:0] rx_data_reg1 = 32'd0;
reg  [31:0] rx_data_reg2 = 32'd0;
reg  [31:0] rx_data_reg3 = 32'd0;
reg  [31:0] rx_data_reg4 = 32'd0;
reg  [31:0] rx_data_reg5 = 32'd0;
reg  [31:0] rx_data_reg6 = 32'd0;
reg  [31:0] rx_data_reg7 = 32'd0;

reg  [2:0]  byte_num = 3'd0;
reg [7:0]enable = 8'd0;
reg [2:0]en_count = 3'd0;
reg [19:0] clk_counter = 20'd0;
reg  [7:0]index_data;
wire [7:0] data;

reg [25:0] t_a_time = 26'd0; 


  wbuart wbu(
						.i_clk(i_clk),
						.i_reset(1'b0),
						.i_uart_rx(i_uart_rx),
						.o_wb_ack(i_wb_ack),
						.o_wb_data(i_wb_data),
						.i_wb_we(o_wb_we),
						.i_wb_cyc(o_wb_cyc),
						.i_wb_stb(o_wb_stb),
						.i_wb_sel(o_wb_sel),
						.i_wb_addr(o_wb_addr),
						.i_wb_data(o_wb_data),
						.o_uart_tx(o_uart_tx)
						);

wire [35:0]CONTROL0;
						

						
localparam IDLE        			 	= 3'd0,//states
			  UART_SETUP   			= 3'd1,
			  Setup_wait            = 3'd2,
			  UART_RX               = 3'd3,
			  Turn_Around_time      = 3'd4,
			  Ack          			= 3'd5;
			  
	reg [2:0]state = IDLE;
	
always@(posedge i_clk)
begin
					 
       
		 case(state) 
		 IDLE: //0
						begin
						         state      <= UART_SETUP;
									o_wb_sel   <= 4'b1111;
									o_wb_we    <= 1'b1;
									o_wb_stb   <= 1'b1;
                           o_wb_cyc   <= 1'b1;
									o_wb_addr  <= 2'b00;
									o_wb_data  <= 32'd434;
									t_a_time   <= 26'd0;
									
						end
							
		 UART_SETUP://1
						begin
							 if(i_wb_ack)
							 begin
									o_wb_we    <= 1'b0;
									o_wb_stb   <= 1'b0;
									o_wb_cyc   <= 1'b0;
									state      <= Setup_wait;
									t_a_time   <= 26'd0;
								end
							  else state <= UART_SETUP;
							  
						end
		Setup_wait://2
					begin
							 if(t_a_time == 26'd50000000)
									begin
									 state    <= UART_RX;
									 t_a_time <= 26'd0;
									end
									else   
									  begin
									  	t_a_time <= t_a_time+1;
										state    <= Setup_wait;
									  end
					end

		UART_RX://3
						begin
							  o_wb_we    <= 1'b0;					//continously wants to receive data from core
							  o_wb_stb   <= 1'b1;
							  o_wb_cyc   <= 1'b1;
							  o_wb_addr  <= 2'b10;
							  state      <= Ack;
						 end
		Ack://5
					begin
						if(i_wb_ack)
								if(i_wb_data[8] == 1'b0)			//whenever core gives valid data, display that on 7 segments and do not read until
								begin
							       o_wb_we      <= 1'b0; 
									 o_wb_cyc     <= 1'b0;
									 o_wb_stb     <= 1'b0;
									 o_wb_cyc     <= 1'b0;
									 t_a_time     <= 26'd0;
									 
									 if(byte_num == 3'd0)
													begin rx_data_reg0  <= i_wb_data; byte_num <= byte_num + 1; state   <= Turn_Around_time; end
									 else if(byte_num == 3'd1)
													begin rx_data_reg1  <= i_wb_data; byte_num <= byte_num + 1; state   <= Turn_Around_time; end
									else if(byte_num == 3'd2)
													begin rx_data_reg2  <= i_wb_data; byte_num <= byte_num + 1; state   <= Turn_Around_time; end
									else if(byte_num == 3'd3)
													begin rx_data_reg3  <= i_wb_data; byte_num <= byte_num + 1; state   <= Turn_Around_time; end
									else if(byte_num == 3'd4)
													begin rx_data_reg4  <= i_wb_data; byte_num <= byte_num + 1; state   <= Turn_Around_time; end
									else if(byte_num == 3'd5)
													begin rx_data_reg5  <= i_wb_data; byte_num <= byte_num + 1; state   <= Turn_Around_time; end
									else if(byte_num == 3'd6)
													begin rx_data_reg6  <= i_wb_data; byte_num <= byte_num + 1; state   <= Turn_Around_time; end
									else if(byte_num == 3'd7)
													begin rx_data_reg7  <= i_wb_data; byte_num <= byte_num + 1; state   <= Turn_Around_time; end
									else
										 byte_num     <= 3'd0;
									    state        <= Turn_Around_time;
								 end	
								 else 
								 begin
									  state <= Turn_Around_time;     //if core gives data which is not valid, disable read operation for 30us and then read again
									  o_wb_we      <= 1'b0;
									  o_wb_cyc     <= 1'b0;
									  o_wb_stb     <= 1'b0;
									  o_wb_cyc     <= 1'b0;
									  t_a_time     <= 26'd0;
								end
						else state <= Ack;					 
						
					end	
		Turn_Around_time://4
						begin
							if(t_a_time == 26'd1500)				//wait for 30us after each byte received whether valid or invalid
								begin
									 t_a_time <= 26'd0;
									 state    <= UART_RX;
								end
							else   
								begin
											t_a_time <= t_a_time+1;
											 state   <= Turn_Around_time;
								end
						end
		
				
			default: state <= IDLE;
			endcase
			
										
end  



always@(posedge i_clk)
begin
	if (clk_counter == 'd100000)
	begin
			en_count <= en_count +1;
			clk_counter <= 0;
			
			if(en_count == 3'd0)
				begin enable <= 8'b01111111;  index_data <= rx_data_reg0;  end
		else if(en_count == 3'd1) 
				begin enable <= 8'b10111111;  index_data <= rx_data_reg1;  end
		else if(en_count == 3'd2) 
				begin enable <= 8'b11011111;  index_data <= rx_data_reg2;  end
		else if(en_count == 3'd3) 
				begin enable <= 8'b11101111;  index_data <= rx_data_reg3;  end
		else if(en_count == 3'd4) 
				begin enable <= 8'b11110111;  index_data <= rx_data_reg4;  end
		else if(en_count == 3'd5) 
				begin enable <= 8'b11111011;  index_data <= rx_data_reg5;  end
		else if(en_count == 3'd6) 
				begin enable <= 8'b11111101;  index_data <= rx_data_reg6;  end
		else if(en_count == 3'd7) 
				begin enable <= 8'b11111110;  index_data <= rx_data_reg7;  end
		else en_count <= 3'd0;
	end
	else clk_counter <= clk_counter +1;
		
		
end

assign en = enable;
assign data = index_data;

 hex7seg seg(
					.x(data), //4-bit
					.a_to_g(a_to_g) //7-bit  
					); 

  
wire [255:0]DATA;

ila ila (
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
    .CLK(i_clk), // IN
    .DATA(DATA), // IN BUS [255:0]
    .TRIG0(i_wb_ack) // IN BUS [7:0]
);

icon cntrl (
    .CONTROL0(CONTROL0) // INOUT BUS [35:0]
);

assign DATA[2:0] = en_count;	
assign DATA[5:3] = byte_num;

endmodule


 

*/









`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:58:09 06/03/2024 
// Design Name: 
// Module Name:    Seven_Seg_Display_Controller 
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
module hex7seg(
    input wire [7:0]x,				//takes data to show on 7seg
	 output reg [6:0]a_to_g			//enables each light of 7 seg according to data
	 
	 );
	 
	 always@(*)
	 begin
		  case(x)
		  'h30:	 a_to_g =  7'b0000001;     //0
		  'h31:   a_to_g =  7'b1001111;     //1
		  'h32:   a_to_g =  7'b0010010;	   //2
		  'h33:   a_to_g =  7'b0000110;	   //3
		  'h34:   a_to_g =  7'b1001100;		//4
		  'h35:   a_to_g =  7'b0100100;		//5
		  'h36:   a_to_g =  7'b0100000;		//6
		  'h37:   a_to_g =  7'b0001111;		//7
		  'h38:   a_to_g =  7'b0000000;		//8
		  'h39:   a_to_g =  7'b0000100;		//9
		  'h61:	 a_to_g =  7'b0001000; 		//A
		  'h62:   a_to_g =  7'b1100000;		//b
		  'h63:   a_to_g =  7'b0110001;		//c
		  'h64:   a_to_g =  7'b1000010;		//d
		  'h65:   a_to_g =  7'b0110000;		//e
		  'h66:   a_to_g =  7'b0111000;		//f
		  
		  'h67:	 a_to_g = 7'b0100000;			//g
		  'h68:	 a_to_g = 7'b1001000;			//h
		  'h69:   a_to_g = 7'b1111001;			//i
		  'h6A:   a_to_g = 7'b1000011;			//j
														//k can not be drawn
		  'h6c:   a_to_g = 7'b1110001;       //l
														//m can not be drawn
		  'h6E:   a_to_g = 7'b1101010;			//n
		  'h6F:   a_to_g = 7'b1100010;			//O
		  'h70:   a_to_g = 7'b0011000;			//P
		  'h71:   a_to_g = 7'b0001100;			//q
		  'h72:   a_to_g = 7'b0001000;			//r
		  'h73:   a_to_g = 7'b0100100;			//s
														//t can not be drawn
		  'h75:   a_to_g = 7'b1000001;			//u
														//v,w,x,y,z cannot be drawn
		  
		  
		  
		  
		  
		default  a_to_g = 7'b1111111; 
		endcase 
	 end
	 
	 

endmodule

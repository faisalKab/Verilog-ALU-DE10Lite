module Lab4(SW, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

input [8:0]SW;
output [6:0]HEX2, HEX1, HEX0;
output [6:0]HEX4, HEX3;
output [6:5]HEX5;
wire [8:0] a;
wire [2:0] z;
wire cout, overflow, OpErrorCode;

assign a = SW;
assign OpErrorCode = ( (a[8] & a[7] & a[6]) | (a[8] & a[7] & ~a[6]) | (a[8] & ~a[7] & a[6]) ); //True when Opcode doesnt exists

	Lab4ALU mine(z, cout, overflow, a);

always@(a)
begin

	//this block is for the result being displayed in binary from HEX0 - HEX2
	//--------------------------------------------------------------------------------------
	HEX2[1] <= ~( ( (~overflow & z[2]) | overflow) & ~OpErrorCode );  
	HEX2[2] <= ~( ( (~overflow & z[2]) | overflow) & ~OpErrorCode );  
	HEX1[1] <= ~( ( (~overflow & z[1]) ) & ~OpErrorCode ); 
	HEX1[2] <= ~( ( (~overflow & z[1]) ) & ~OpErrorCode );  
	HEX0[1] <= ~( ( (~overflow & z[0]) ) & ~OpErrorCode ); 
	HEX0[2] <= ~( ( (~overflow & z[0]) ) & ~OpErrorCode );
	//--------------------------------------------------------------------------------------
	
	
	//these are for the overflow result displaying in HEX0 - HEX2 of all segments ON. 
	//-------------------------------------------------------------------------------
	HEX2[0] <= ~((overflow) & ~OpErrorCode );
	//HEX2[1] <= ~(overflow); 
	//HEX2[2] <= ~(overflow); 
	HEX2[3] <= ~((overflow) & ~OpErrorCode ); 
	HEX2[4] <= ~((overflow) & ~OpErrorCode );
	HEX2[5] <= ~((overflow) & ~OpErrorCode );
	HEX2[6] <= 1'b1;    // ~(overflow);
	
	HEX1[0] <= ~((overflow) & ~OpErrorCode ); 
	//HEX1[1] <= ~(overflow); 
	//HEX1[2] <= ~(overflow); 
	HEX1[3] <= 1'b1;    // ~(overflow); 
	HEX1[4] <= ~((overflow) & ~OpErrorCode ); 
	HEX1[5] <= ~((overflow) & ~OpErrorCode );
	HEX1[6] <= ~((overflow) & ~OpErrorCode );
	
	HEX0[0] <= 1'b1;    // ~(overflow);  
	//HEX0[1] <= ~(overflow); 
	//HEX0[2] <= ~(overflow); 
	HEX0[3] <= ~((overflow) & ~OpErrorCode ); 
	HEX0[4] <= ~((overflow) & ~OpErrorCode ); 
	HEX0[5] <= ~((overflow) & ~OpErrorCode );
	HEX0[6] <= 1'b1;    // ~(overflow);
	//-------------------------------------------------------------------------------------
	
	
	//this is for the E (error) if op code is not recognized
	//--------------------------------------------------------------------------------------
	HEX3[0] <= ~OpErrorCode;
	HEX3[1] <= 1'b1; 
	HEX3[2] <= 1'b1; 
	HEX3[3] <= ~OpErrorCode;
	HEX3[4] <= ~OpErrorCode;
	HEX3[5] <= ~OpErrorCode;
	HEX3[6] <= ~OpErrorCode;
	//--------------------------------------------------------------------------------------


	
	//these are for FUN, these are to display the 3 bit binary result in decimal [3 - (-4)].
	//--------------------------------------------------------------------------------------
	//A'B + BC' + AB'
	HEX4[6] <= ~(( ((~z[2] & z[1]) | (z[1] & ~z[0]) | (z[2]&~z[1]))  & ~overflow ) & ~OpErrorCode );

	//B'C'
	HEX4[5] <= ~(( (~z[1] & ~z[0])  & ~overflow ) & ~OpErrorCode );

	//A'C' + B'C' + AC   //A'C' + BC'
	HEX4[4] <= ~(( ( (~z[2] & ~z[0]) | (z[1] & ~z[0]) ) & ~overflow ) & ~OpErrorCode );

	//A'C' + A'B + BC' + AB'C
	HEX4[3] <= ~(( ((~z[2] & ~z[0]) | (~z[2] & z[1]) | (z[1] & ~z[0]) | (z[2] & ~z[1] & z[0]))  & ~overflow ) & ~OpErrorCode );

	//B' + C
	HEX4[2] <= ~(( (~z[1] | z[0])  & ~overflow ) & ~OpErrorCode );

	HEX4[1] <= ~(( 1'b1 & ~overflow) & ~OpErrorCode );

	//A'C' + A'B + BC' + AB'C
	HEX4[0] <= ~(( ( (~z[2] & ~z[0]) | (~z[2] & z[1]) | (z[1] & ~z[0]) | z[2] & ~z[1] & z[0] ) & ~overflow) & ~OpErrorCode );
	//--------------------------------------------------------------------------------------
	
	
	//this is for the negative sign for the 2's complement
	//--------------------------------------------------------------------------------------
	HEX5[6] <= ~(z[2] & ~overflow & ~OpErrorCode);
	HEX5[5] <= 1'b1;   //this is just there because verilog is stupid. dont touch this one. 
	//--------------------------------------------------------------------------------------
	
	
end

endmodule



//*****************************************************************************//
module Lab4ALU(output1, cout, overFlowDetection, input1);

input [8:0] input1;
output [2:0] output1;
output cout, overFlowDetection;
wire [2:0] temp1, temp2, temp3, temp4, b, a, op, outMux;
wire overflow;

assign b[2:0] = input1[2:0];
assign a[2:0] = input1[5:3];
assign op[2:0] = input1[8:6];

assign overFlowDetection = ( overflow & ( (op[2] & ~op[1] & ~op[0]) | (~op[2] & op[1] & op[0]) ) );  //If op is only sub or add
	
	or  myOr[2:0]   (temp1, a, b);
	xor myXor[2:0]  (temp2, a, b);
	and myAnd[2:0]  (temp3, a, b);

	yArith myArith(temp4, cout, overflow, a, b, op[2]);							//op[2] is only cared by the mux for selecting add or sub... op[2] = 0 means add... op[2] = 1 means sub
	yMux4to1 my_mux(outMux, temp1, temp2, temp3, temp4, op[1:0]);		//op[1:0](0-3) is only cared by ymux4to1 because there are four states

	yMux Mux_For_Add_or_Sub(output1, outMux, temp4, op[2]);

endmodule
//*****************************************************************************//
module yMux4to1(z, a0, a1, a2, a3, op);

output [2:0] z;
input  [2:0] a3, a2, a1, a0;
input  [1:0] op;

wire [2:0] temp1, temp2;

	yMux firstHalf(temp1, a0, a1, op[1]);
	yMux secondHalf(temp2, a2, a3, op[1]);
	yMux finalRight(z, temp1, temp2, op[0]);

endmodule
//*****************************************************************************//
module yMux(z, a, b, c);

parameter SIZE = 3;

output [SIZE-1:0] z;
input [SIZE-1:0] a, b;
input c;

	yMux1 mine[SIZE-1:0](z, a, b, c);			 //this how much times you are calling the 1bit multiplexer. NOT twice, that was just the two bit example. understood.
											
endmodule
//*****************************************************************************//
module yMux1(z, a, b, c);

output z;
input a, b, c;
wire notC, upper, lower;

not my_not(notC, c);
and upperAnd(upper, a, notC);
and lowerAnd(lower, b, c);
or my_or(z, upper, lower);

endmodule
//*****************************************************************************//
module yAdder1(z, cout, a, b, cin);

output z, cout;
input a, b, cin;

	xor left_xor(tmp, a, b);
	xor right_xor(z, cin, tmp);
	and left_and(outL, a, b);
	and right_and(outR, tmp, cin);
	or my_or(cout, outR, outL);

endmodule
//*****************************************************************************//
module yAdder(z, cout, overflow, a, b, cin);
output [2:0] z;							//not an interation of 32 times, but think instantiation. it does it to all bits of z
output cout, overflow;
input [2:0] a, b;
input cin;
wire[2:0] in, out;

	yAdder1 mine[2:0](z, out, a, b, in);   //calls it 31 times iterating from 0 - 11th bit

	assign in[0]  = cin;
	assign in[1]  = out[0];
	assign in[2]  = out[1];					//use cout to see if it is overflow
	assign cout   = out[2];	

	assign overflow = (in[2] ^ cout);

endmodule
//*****************************************************************************//
module yArith(z, cout, overflow, a, b, ctrl); 
output [2:0] z;
output cout, overflow;

input [2:0] a, b;
input ctrl;

wire[2:0] notB, tmpB;

    not c_not[2:0](notB, b);						//not b for subtracting method + 1
    yMux my_mux(tmpB, b, notB, ctrl);				//if we should use notB or b depending on ctrl. ctrl = 1 selects notB                          
    yAdder my_add(z, cout, overflow, a, tmpB, ctrl);			//if ctrl 0, add and no carryIn. if 1, subtract and use the 1 to add it to the invert by carryIn
	
endmodule
//*****************************************************************************//
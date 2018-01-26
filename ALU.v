`timescale 1ns / 1ps

module ALU16(A, B, Ctrl, S, Overflow, Zero);
	input [15:0] A, B;
	input [3:0] Ctrl;
	output [15:0] S;
	output Overflow, Zero;
	
	wire zero;
	wire  [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
	wire ci0, ci1, o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13, o14, o15;
	
	assign Zero = ~ (S[0] | S[1] | S[2] | S[3] | S[4] | S[5] | S[6] | S[7] | S[8] | S[9] | S[10] | S[11] | S[12] | S[13] | S[14] | S[15]);
	assign subtract_zero = ~ (r0[0] | r0[1] | r0[2] | r0[3] | r0[4] | r0[5] | r0[6] | r0[7] | r0[8] | r0[9] | r0[10] | r0[11] | r0[12] | r0[13] | r0[14] | r0[15]);
	
	adder16 adder_0(.a(A), .b(~B), .ci(1'b1) ,.sum(r0), .co(ci0));
	adder16 adder_1(.a(A), .b(B), .ci(1'b0) ,.sum(r1), .co(ci1));

	assign r2 = A | B;
	assign r3 = A & B;
	assign r4 = A - 1;
	assign r5 = A + 1;
	assign r6 = ~A + 1;
	assign r7 = 0;
	assign r8 = A << B;
	assign r9[15:1] = 15'b000000000000000;
	assign r9[0] = (~o9 & ((~r0[15]) | subtract_zero)) | (o9 & (~A[15])); //consider overflow
	assign r10 = A >> B;
	assign r11 = 0;
	assign r12 = $signed(A) <<< B;
	assign r13 = 0;
	assign r14 = $signed(A) >>> B;
	assign r15 = 0;
	
	assign o0 = (A[15] ^ B[15]) & (A[15] ^ r0[15]); //overflow when A and B have different signs, and the result is of different sign from A
	assign o1 = (A[15] ~^ B[15]) & (A[15] ^ r1[15]); //overflow when A and B have the same sign, and the result is of different sign
	assign o2 = 0;
	assign o3 = 0;
	assign o4 = A[15] & (~A[14]) & (~A[13]) & (~A[12]) & (~A[11]) & (~A[10]) & (~A[9]) & (~A[8]) & (~A[7]) & (~A[6]) & (~A[5]) & (~A[4]) & (~A[3]) & (~A[2]) & (~A[1]) & (~A[0]);
	assign o5 = (~A[15]) & A[14] & A[13] & A[12] & A[11] & A[10] & A[9] & A[8] & A[7] & A[6] & A[5] & A[4] & A[3] & A[2] & A[1] & A[0];
	assign o6 = A[15] & (~A[14]) & (~A[13]) & (~A[12]) & (~A[11]) & (~A[10]) & (~A[9]) & (~A[8]) & (~A[7]) & (~A[6]) & (~A[5]) & (~A[4]) & (~A[3]) & (~A[2]) & (~A[1]) & (~A[0]);
	assign o7 = 0;
	assign o8 = 0;
	assign o9 = 0;
	assign o10 = 0;
	assign o11 = 0;
	assign o12 = A[15] ^ r12[15]; //overflow when sigh changed
	assign o13 = 0;
	assign o14 = A[15] ^ r14[15]; //overflow when sign changed
	assign o15 = 0;
	
	
	mux16bit m_0(.in0(r0), .in1(r1), .in2(r2), .in3(r3), .in4(r4), .in5(r5), .in6(r6), .in7(r7), .in8(r8), .in9(r9), .in10(r10), .in11(r11), .in12(r12), .in13(r13), .in14(r14), .in15(r15), .sel(Ctrl), .out(S));
	mux16 m_1(.in0(o0), .in1(o1), .in2(o2), .in3(o3), .in4(o4), .in5(o5), .in6(o6), .in7(o7), .in8(o8), .in9(o9), .in10(o10), .in11(o11), .in12(o12), .in13(o13), .in14(o14), .in15(o15), .sel(Ctrl), .out(Overflow));
endmodule
 




module ALU(a, b, Binvert, CarryIn, Operation, CarryOut, Result);
	input a, b, Binvert, CarryIn;
	input [1:0] Operation;
	output CarryOut, Result;
	wire mux_out, r0, r1, r2, CarryOut, Result;
	mux2 mux2to1(.in0(b), .in1(~b), .sel(Binvert), .out(mux_out));
	assign r0 = a & mux_out;
	assign r1 = a | mux_out;
	addbit adder(.a(a), .b(mux_out), .ci(CarryIn), .sum(r2), .co(CarryOut));
	mux4 mux4to1(.in0(r0), .in1(r1), .in2(r2), .in3(1'b0), .sel(Operation), .out(Result));
endmodule


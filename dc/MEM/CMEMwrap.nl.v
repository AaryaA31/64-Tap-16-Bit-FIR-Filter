/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : U-2022.12-SP7
// Date      : Sat Nov 23 17:09:11 2024
/////////////////////////////////////////////////////////////


module CMEMwrap ( clk, Q, CEN, WEN, A, D );
  output [15:0] Q;
  input [5:0] A;
  input [15:0] D;
  input clk, CEN, WEN;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
;

  CMEM dut ( .Q(Q), .A({n14, n12, n10, n8, n6, n4}), .D(D), .CLK(clk), .CEN(n2), .WEN(n16) );
  INVX2TS U1 ( .A(CEN), .Y(n1) );
  INVX2TS U2 ( .A(n1), .Y(n2) );
  INVX2TS U3 ( .A(A[0]), .Y(n3) );
  INVX2TS U4 ( .A(n3), .Y(n4) );
  INVX2TS U5 ( .A(A[1]), .Y(n5) );
  INVX2TS U6 ( .A(n5), .Y(n6) );
  INVX2TS U7 ( .A(A[2]), .Y(n7) );
  INVX2TS U8 ( .A(n7), .Y(n8) );
  INVX2TS U9 ( .A(A[3]), .Y(n9) );
  INVX2TS U10 ( .A(n9), .Y(n10) );
  INVX2TS U11 ( .A(A[4]), .Y(n11) );
  INVX2TS U12 ( .A(n11), .Y(n12) );
  INVX2TS U13 ( .A(A[5]), .Y(n13) );
  INVX2TS U14 ( .A(n13), .Y(n14) );
  INVX2TS U15 ( .A(WEN), .Y(n15) );
  INVX2TS U16 ( .A(n15), .Y(n16) );
endmodule


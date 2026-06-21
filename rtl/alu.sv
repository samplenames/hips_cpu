module alu#(int w=32)
  (output logic [w-1:0]y, 
   output uwire n, z,
   input logic [w-1:0] a,b,
   input logic[2:0] op);

localparam logic[2:0] ADDop = 3'b000;
localparam logic[2:0] SUBop = 3'b001;
localparam logic[2:0] SRLop = 3'b010;
localparam logic[2:0] SLLop = 3'b011;
localparam logic[2:0] ANDop = 3'b100;
localparam logic[2:0] ORRop = 3'b101;
localparam logic[2:0] SLTop = 3'b110;
  
always_comb
  begin
    y = 0;
    if(op == ADDop)	
     y = a+b;	
    if(op == SUBop)
      y = a-b;	
    if(op == SRLop)	
      y = a >> b[4:0];
    if(op == SLLop)
      y = a << b[4:0];
    if(op == ANDop)
      y = a & b;
    if(op == ORRop)
      y = a | b;
    if(op == SLTop)
      y = ($signed(a) < $signed(b)) ? 1 : 0;
  end
  
  assign n =  y[w-1];
  assign z = ( y == 0) ? 1 : 0;

endmodule

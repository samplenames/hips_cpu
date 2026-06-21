
module instr_mem#(int w = 32, ww = w*2)
  (output uwire[w-1:0] instr,
   input uwire[w-1:0] pc);
  
  logic[w-1:0] mem[ww-1:0];
  
  assign instr = mem[pc];
  
  
endmodule
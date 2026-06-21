
module pc#(int w = 32)
  (output uwire [w-1:0] pc,
   input uwire clk, rst,
   input uwire [w-1:0] pc_next);
  
  
  logic[w-1:0] pc_reg = 0;
  
  always_ff@(posedge clk)
    begin
      if(rst)
        pc_reg <= 0;
      else
        pc_reg <= pc_next;
    end	
  
  assign pc = pc_reg;
  
endmodule
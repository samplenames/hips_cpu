

module mem_port#(int w = 32, ww = w*8)
  (output uwire[w-1:0] data_out,
   input uwire [w-1:0] data_in, data_addr, 
   input uwire clk, w_en);


  logic [w-1:0]mem[ww-1:0];
	
  always_ff@(posedge clk)begin
    
    if(w_en)
      mem[data_addr] <= data_in;
  
  end
  
  assign data_out = mem[data_addr];
endmodule

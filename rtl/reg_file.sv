module reg_file#(int w = 32 , wn = $clog2(w))
  (output uwire[w-1:0] Ra_data, Rb_data,
   input uwire w_en, clk, rst,
   input uwire[wn-1:0] Ra_addr, Rb_addr, w_addr,
   input uwire[w-1:0] w_data);
  
  logic [w-1:0] reg_file[w-1:0];
 
  always_ff@(posedge clk)
    begin
      if(rst)
        begin
        for(int i = 0; i < w ; i++)
          reg_file[i] <= 0;
        end
      
      else if(w_en)
        reg_file[w_addr] <= w_data;
    end
	  assign Ra_data = reg_file[Ra_addr];
      assign Rb_data = reg_file[Rb_addr];

endmodule
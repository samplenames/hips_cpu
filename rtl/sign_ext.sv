

module sign_ext#( int w = 32 )
  (output logic[w-1:0] z,
   input uwire[w-1:0] x,
   input logic[1:0] IJR);
  
localparam logic[1:0] R_type = 2'b00;
localparam logic[1:0] I_type = 2'b10;
localparam logic[1:0] J_type = 2'b11;
  
  always_comb
    begin
      
      case(IJR)
        R_type: begin z = x; end
        I_type: begin z = {{(w-16){x[15]}}, x[15:0]}; end
        J_type: begin z = {{(w-26){x[25]}}, x[25:0]};end
      default: z = x;
     endcase
      end
  
  
endmodule
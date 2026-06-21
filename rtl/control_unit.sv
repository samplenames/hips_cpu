
module control_unit#( int w = 32)
  (output logic[1:0] sign_ext, pc_sel, branch,
   output logic reg_sel, alu_src, w_en, wb_sel, mw_en,
   output logic[2:0] alu_op, 
   input logic[5:0] opcode, func);
  
localparam logic[5:0] ADD  = 6'b000000; //R
localparam logic[5:0] SUB  = 6'b000000; //R
localparam logic[5:0] AND  = 6'b000000; //R
localparam logic[5:0] ORR  = 6'b000000; //R
localparam logic[5:0] SLT  = 6'b000000; //R
localparam logic[5:0] JR   = 6'b000000; //R
localparam logic[5:0] ADDI = 6'b100000; //I
localparam logic[5:0] SLL  = 6'b100001; //I
localparam logic[5:0] SRL  = 6'b100010; //I
localparam logic[5:0] STW  = 6'b100011; //I
localparam logic[5:0] LDW  = 6'b100100; //I
localparam logic[5:0] BEQ  = 6'b100101; //I
localparam logic[5:0] BGT  = 6'b100110; //I
localparam logic[5:0] BNE  = 6'b100111; //I
localparam logic[5:0] J    = 6'b110000; //J

localparam logic[5:0] ADDFunc = 6'b000000;
localparam logic[5:0] SUBFunc = 6'b000001;
localparam logic[5:0] ANDFunc = 6'b000011;
localparam logic[5:0] ORRFunc = 6'b000100;
localparam logic[5:0] SLTFunc = 6'b000101;
localparam logic[5:0] JRFunc  = 6'b000111;

  
localparam logic[2:0] ADDop = 3'b000;
localparam logic[2:0] SUBop = 3'b001;
localparam logic[2:0] SRLop = 3'b010;
localparam logic[2:0] SLLop = 3'b011;
localparam logic[2:0] ANDop = 3'b100;
localparam logic[2:0] ORRop = 3'b101;
localparam logic[2:0] SLTop = 3'b110;
  
localparam logic[1:0] R_type = 2'b00;
localparam logic[1:0] I_type = 2'b10;
localparam logic[1:0] J_type = 2'b11;
  
  logic[1:0] instr_type;
  
  always_comb
    begin
      
      instr_type = (!opcode[5:5]) ? R_type :  opcode[4:4] ?  J_type : I_type ;
      
      sign_ext = instr_type;
      reg_sel  = (opcode == STW || (opcode == BEQ || opcode == BNE || opcode == BGT) ) ? 1 : 0;
      mw_en    = (opcode == STW ) ? 1 : 0;
      alu_src  = (instr_type == I_type && opcode != BGT && opcode != BEQ && opcode != BNE) ? 1 : 0;
      w_en = (opcode == STW || opcode == BEQ || opcode == BNE || opcode == BGT || opcode == J || ( instr_type == R_type && func == JRFunc) ) ? 0 : 1;
      wb_sel = (opcode == LDW) ? 1 : 0;
      branch = (opcode == BEQ) ? 2'b01:
    (opcode == BNE) ? 2'b10 :
    (opcode == BGT) ? 2'b11 :
                      2'b00;
      pc_sel = (opcode == J) ? 2'b10 : (instr_type == R_type && func == JRFunc) ? 2'b11 : (opcode == BEQ || opcode == BGT || opcode == BNE) ? 2'b01 : 2'b00;
      
   if(instr_type == R_type) begin
    case(func)
        ADDFunc: alu_op = ADDop;
        SUBFunc: alu_op = SUBop;
        ANDFunc: alu_op = ANDop;
        ORRFunc: alu_op = ORRop;
        SLTFunc: alu_op = SLTop;
        default:   alu_op = 3'b000;
    endcase
end else begin
  alu_op = (opcode == BEQ || opcode == BGT || opcode == BNE) ? SUBop :
  (opcode == SRL) ? SRLop :
  (opcode == SLL) ? SLLop : 3'b000;
end
      
    end
 
  
  
endmodule

module hips_cpu#(int w = 32)
  (input clk, rst);
  
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
  
  uwire[w-1:0] instr;
  logic[5:0] opcode,func;
  uwire[4:0] rd, rs,rt,ra_addr, rb_addr;
  uwire[1:0] instr_type;
 
  uwire[w-1:0] pc_curr;
  logic[w-1:0] pc_next;
  uwire[w-1:0] mem_out, alu_out,imm, ra_data, rb_data, w_data, alu_a, alu_b;
  logic[2:0] alu_op;
  logic w_en, mw_en, n, z, reg_sel, alu_src, wb_sel, n2,z2;
  logic[w-1:0] target;
  uwire[1:0] pc_sel, branch;
  
  pc program_counter(pc_curr, clk, rst, pc_next);
  
  instr_mem instruction_memory(instr, pc_curr);
  
  alu alu(alu_out, n, z, ra_data, alu_b, alu_op);
  
  mem_port memory_port(mem_out, rb_data, alu_out, clk, mw_en);
  
  sign_ext sign_extend(imm, instr, instr_type);
  
  reg_file register_file(ra_data, rb_data, w_en, clk, rst, ra_addr, rb_addr, rd, w_data);
    
  control_unit magic_cloud(instr_type, pc_sel, branch, reg_sel, alu_src, w_en, wb_sel, mw_en, alu_op, opcode, func);
  
  always_comb 
  begin
   opcode = instr[31:26];
   func   = instr[5:0];
  case(pc_sel)
    2'b00: pc_next = pc_curr + 1;
    2'b01: begin  
      if((branch == 2'b01 && z) || (branch == 2'b11 && n & !z) || (branch == 2'b10 && !z))
        pc_next = pc_curr + 1 + imm;
      else
        pc_next = pc_curr + 1;
      end
    2'b10:pc_next = imm; 
    2'b11: pc_next = ra_data;
  endcase
    

  end
  
  assign rd = instr[25:21];
  assign rs = instr[20:16];
  assign rt = instr[15:11];
  assign ra_addr = rs;
  assign rb_addr = (reg_sel) ? rd : rt; 
  assign alu_b = (alu_src ) ? imm : rb_data;
  assign w_data = (wb_sel) ? mem_out : alu_out;
  
endmodule
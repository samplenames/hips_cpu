//HIPS TESTBENCH
module hips_cpu_tb;
  int w = 32;
  logic clk;
  logic rst;

  // Instantiate Design Under Test (DUT)
  hips_cpu #(.w(32)) dut (
    .clk(clk),
    .rst(rst)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;

    // Zero out instruction memory space initially
    for (int i = 0; i < 64; i++) begin
      dut.instruction_memory.mem[i] = 32'b0;
    end


    // PC = 0: ADDI r1, r0, 20  -> r1 = 20
    dut.instruction_memory.mem[0] = {6'b100000, 5'd1, 5'd0, 5'd0, 11'd20};

    // PC = 1: ADDI r2, r0, 5   -> r2 = 5
    dut.instruction_memory.mem[1] = {6'b100000, 5'd2, 5'd0, 5'd0, 11'd5};

    // PC = 2: SUB r3, r1, r2   -> r3 = r1 - r2 = 15 (Func bits configured to 6'b000001)
    dut.instruction_memory.mem[2] = {6'b000000, 5'd3, 5'd1, 5'd2, 5'b00000, 6'b000001};

    // PC = 3: SLL r4, r1, 0    -> r4 = 20
    dut.instruction_memory.mem[3] = {6'b100001, 5'd4, 5'd1, 5'd0, 11'd0};

    // PC = 4: AND r5, r4, r1   -> r5 = r4 & r1 = 20 (Func bits configured to 6'b000011)
    dut.instruction_memory.mem[4] = {6'b000000, 5'd5, 5'd4, 5'd1, 5'b00000, 6'b000011};

    // PC = 5: STW r3, r0, 10   -> Mem[10] = r3 (15)
    dut.instruction_memory.mem[5] = {6'b100011, 5'd3, 5'd0, 5'd0, 11'd10};

    // PC = 6: LDW r6, r0, 10   -> r6 = Mem[10] (15)
    dut.instruction_memory.mem[6] = {6'b100100, 5'd6, 5'd0, 5'd0, 11'd10};

    // PC = 7: BEQ r5, r1, 2    -> r5 == r1 (20 == 20). Branches forward to PC = PC + 1 + 2 = 10
    dut.instruction_memory.mem[7] = {6'b100101, 5'd5, 5'd1, 5'd0, 11'd2};

    // PC = 8: ADDI r7, r0, 99  -> Isolated Trap Line (Should be skipped by BEQ branch)
    dut.instruction_memory.mem[8] = {6'b100000, 5'd7, 5'd0, 5'd0, 11'd99};

    // PC = 9: ADDI r7, r0, 99  -> Isolated Trap Line (Should be skipped by BEQ branch)
    dut.instruction_memory.mem[9] = {6'b100000, 5'd7, 5'd0, 5'd0, 11'd99};

    // PC = 10: BGT r2, r1, 2   -> Checks r2 > r1 (5 > 20 is False). Should Fall-through to PC = 11
    dut.instruction_memory.mem[10] = {6'b100110, 5'd2, 5'd1, 5'd0, 11'd2};

    // PC = 11: ADDI r8, r0, 88 -> r8 = 88 (Confirms BGT fallback execution path handled properly)
    dut.instruction_memory.mem[11] = {6'b100000, 5'd8, 5'd0, 5'd0, 11'd88};

    // PC = 12: J 15            -> Jumps straight to target PC = 15
    dut.instruction_memory.mem[12] = {6'b110000, 26'd15};

    // PC = 13: ADDI r9, r0, 66 -> Isolated Trap Line (Should be skipped by Unconditional Jump)
    dut.instruction_memory.mem[13] = {6'b100000, 5'd9, 5'd0, 5'd0, 11'd66};

    // PC = 14: ADDI r9, r0, 66 -> Isolated Trap Line (Should be skipped by Unconditional Jump)
    dut.instruction_memory.mem[14] = {6'b100000, 5'd9, 5'd0, 5'd0, 11'd66};

    // PC = 15: ADDI r9, r0, 77 -> r9 = 77
    dut.instruction_memory.mem[15] = {6'b100000, 5'd9, 5'd0, 5'd0, 11'd77};

    // Run execution tracking cycles
    #170;

  
    $display("          HIPS CPU RESULTS          ");
   

    if (dut.register_file.reg_file[1] == 20)
      $display("[PASS] ADDI Verification | Register r1 = %d", dut.register_file.reg_file[1]);
    else
      $error("[FAIL] ADDI Verification | Register r1 = %d (Expected: 20)", dut.register_file.reg_file[1]);

    if (dut.register_file.reg_file[2] == 5)
      $display("[PASS] ADDI Verification | Register r2 = %d", dut.register_file.reg_file[2]);
    else
      $error("[FAIL] ADDI Verification | Register r2 = %d (Expected: 5)", dut.register_file.reg_file[2]);

    if (dut.register_file.reg_file[3] == 15)
      $display("[PASS] SUB R-Type Verification | Register r3 = %d", dut.register_file.reg_file[3]);
    else
      $error("[FAIL] SUB R-Type Verification | Register r3 = %d (Expected: 15)", dut.register_file.reg_file[3]);

    if (dut.register_file.reg_file[4] == 20)
      $display("[PASS] SLL Shift Verification | Register r4 = %d", dut.register_file.reg_file[4]);
    else
      $error("[FAIL] SLL Shift Verification | Register r4 = %d (Expected: 20)", dut.register_file.reg_file[4]);

    if (dut.register_file.reg_file[5] == 20)
      $display("[PASS] AND Logical Verification | Register r5 = %d", dut.register_file.reg_file[5]);
    else
      $error("[FAIL] AND Logical Verification | Register r5 = %d (Expected: 20)", dut.register_file.reg_file[5]);

    if (dut.memory_port.mem[10] == 15)
      $display("[PASS] STW Memory Verification | Mem[10] = %d", dut.memory_port.mem[10]);
    else
      $error("[FAIL] STW Memory Verification | Mem[10] = %d (Expected: 15)", dut.memory_port.mem[10]);

    if (dut.register_file.reg_file[6] == 15)
      $display("[PASS] LDW Memory Verification | Register r6 = %d", dut.register_file.reg_file[6]);
    else
      $error("[FAIL] LDW Memory Verification | Register r6 = %d (Expected: 15)", dut.register_file.reg_file[6]);

    if (dut.register_file.reg_file[7] == 0)
      $display("[PASS] BEQ Branch Taken Isolation (r7 should be 0) | Register r7 = %d", dut.register_file.reg_file[7]);
    else
      $error("[FAIL] BEQ Branch Taken Isolation (r7 should be 0) | Register r7 = %d (Expected: 0)", dut.register_file.reg_file[7]);

    if (dut.register_file.reg_file[8] == 88)
      $display("[PASS] BGT Fall-through Fallback Verification | Register r8 = %d", dut.register_file.reg_file[8]);
    else
      $error("[FAIL] BGT Fall-through Fallback Verification | Register r8 = %d (Expected: 88)", dut.register_file.reg_file[8]);

    if (dut.register_file.reg_file[9] == 77)
      $display("[PASS] Unconditional Jump Verification | Register r9 = %d", dut.register_file.reg_file[9]);
    else
      $error("[FAIL] Unconditional Jump Verification | Register r9 = %d (Expected: 77)", dut.register_file.reg_file[9]);

    $finish;
  end

  initial begin
    $monitor("Time=%0t ns | PC=%d | Opcode=%b | Func=%b | ALU_Out=%d | PC_Next=%d", 
             $time, dut.pc_curr, dut.opcode, dut.func, dut.alu_out, dut.pc_next);
  end

endmodule
module main_tb;

reg clk;
reg rst;
reg rst_im;
reg write_en;
reg [14:0] write_addr;
reg [31:0] write_data;

wire [31:0] instr_wb;
wire [31:0] pc;

wire [31:0] s_alu_result_out;
wire [31:0] s_load_data_out;
wire [4:0]  s_rd_out;
wire        s_wb_reg_file_out;
wire        s_memtoreg_out;

wire [31:0] instr;

// ---------------- CORE ----------------
rv32i_core dut (
    .clk(clk),
    .instr_wb_out(instr_wb),
    .rst(rst),
    .rst_im(rst_im),
    .write_en(write_en),
    .write_addr(write_addr),
    .write_data(write_data),
    .pc(pc),
    .s_alu_result_out(s_alu_result_out),
    .s_load_data_out(s_load_data_out),
    .s_rd_out(s_rd_out),
    .s_wb_reg_file_out(s_wb_reg_file_out),
    .s_memtoreg_out(s_memtoreg_out),
    .instr(instr)
);

// ---------------- WB DATA ----------------
wire [31:0] wb_write_data;
wire wb_write_en;

assign wb_write_data = (s_memtoreg_out) ? s_load_data_out : s_alu_result_out;
assign wb_write_en   = (s_wb_reg_file_out && (s_rd_out != 5'd0));

// ---------------- FILE HANDLE ----------------
integer fd;
reg [1023:0] trace_file;

initial begin
    if (!$value$plusargs("trace_file=%s", trace_file)) begin
        trace_file = "rtl_trace.log";
    end

    $display("TRACE FILE = %s", trace_file);

    fd = $fopen(trace_file, "w");
    if (fd == 0) begin
        $display("ERROR: file open failed");
        $finish;
    end
end

// ---------------- CLOCK ----------------
initial begin
    clk = 1;
    forever #5 clk = ~clk;
end

// ---------------- RESET ----------------
initial begin
    rst_im = 0;
    write_en = 0;
    write_addr = 0;
    write_data = 0;
end

// ---------------- TRACE LOGIC ----------------
always @(posedge clk) begin
    if (!rst) begin

        // STORE instruction
        if (dut.mem_write_wb_out) begin
            case (dut.mem_store_type_wb_out)

                2'b00: // SB
                    $fdisplay(fd,
                        "core 0: %08h (%08h) mem %08h %02h",
                        dut.pc_wb,
                        dut.instr_wb,
                        dut.store_addr_wb_out,
                        dut.store_data_wb_out[7:0]);

                2'b01: // SH
                    $fdisplay(fd,
                        "core 0: %08h (%08h) mem %08h %04h",
                        dut.pc_wb,
                        dut.instr_wb,
                        dut.store_addr_wb_out,
                        dut.store_data_wb_out[15:0]);

                2'b10: // SW
                    $fdisplay(fd,
                        "core 0: %08h (%08h) mem %08h %08h",
                        dut.pc_wb,
                        dut.instr_wb,
                        dut.store_addr_wb_out,
                        dut.store_data_wb_out);

            endcase
        end

        // NORMAL instruction
        else begin
            $fdisplay(fd,
                "core 0: %08h (%08h) x%0d %08h",
                dut.pc_wb,
                dut.instr_wb,
                s_rd_out,
                wb_write_data);
        end
    end
end


initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
end

// ---------------- TEST STIMULUS ----------------
initial begin
    rst = 1;
    #10;
    rst = 0;

    #100000;
    $display("SIMULATION DONE");
    $finish;
end

endmodule

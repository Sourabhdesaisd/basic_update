module mem_wb_pipe (
    input clk,
    input rst,

    // From MEM stage
    input [31:0] pc_mem,
    input [31:0] instr_mem,

    input [31:0] alu_result_in,
    input [31:0] load_data_in,
    input [4:0]  rd_in,
    input        wb_reg_file_in,
    input        memtoreg_in,

    // ? STORE signals from MEM
    input        mem_write_mem,
    input [31:0] rs2_data_mem,
    input [1:0]  mem_store_type_mem,

    // Outputs to WB
    output reg [31:0] pc_wb,
    output reg [31:0] instr_wb,

    output reg [31:0] alu_result_out,
    output reg [31:0] load_data_out,
    output reg [4:0]  rd_wb,
    output reg        wb_reg_file_out,
    output reg        memtoreg_out,

    // ? STORE signals to TB
    output reg        mem_write_wb,
    output reg [31:0] store_data_wb,
    output reg [31:0] store_addr_wb,
    output reg [1:0]  mem_store_type_wb
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_wb <= 0;
        instr_wb <= 0;
        alu_result_out <= 0;
        load_data_out <= 0;
        rd_wb <= 0;
        wb_reg_file_out <= 0;
        memtoreg_out <= 0;

        mem_write_wb <= 0;
        store_data_wb <= 0;
        store_addr_wb <= 0;
        mem_store_type_wb <= 0;
    end
    else begin
        pc_wb <= pc_mem;
        instr_wb <= instr_mem;

        alu_result_out <= alu_result_in;
        load_data_out <= load_data_in;
        rd_wb <= rd_in;
        wb_reg_file_out <= wb_reg_file_in;
        memtoreg_out <= memtoreg_in;

        // ? STORE pipeline
        mem_write_wb <= mem_write_mem;
        store_data_wb <= rs2_data_mem;
        store_addr_wb <= alu_result_in;
        mem_store_type_wb <= mem_store_type_mem;
    end
end

endmodule

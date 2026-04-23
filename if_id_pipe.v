module if_id_pipe (
    input  clk,
    input  rst,
    input  en,         
    input  flush,        
    input  [31:0] pc_in,
    input  [31:0] instr_in,
    input         predictedTaken_in,
   

    // ID outputs
    output reg [31:0] pc_id,
    output reg [31:0] instr_id,
    output reg        predictedTaken_id
);
    parameter NOP = 32'h00000013;  // ADDI x0, x0, 0

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_id               <= 32'h0;
            instr_id            <= NOP;
            predictedTaken_id   <= 1'b0;
        end
        
        else if (flush) begin
            pc_id               <= 32'h0;
            instr_id            <= NOP;
            predictedTaken_id   <= 1'b0;
        end
        
        else if (en) begin
            // Normal advance
            pc_id               <= pc_in;
            instr_id            <= instr_in;
            predictedTaken_id   <= predictedTaken_in;
        end
    end
endmodule

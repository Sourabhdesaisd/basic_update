module inst_mem (
	input clk,
	input rst,
 	input   [14:0] pc, 
	input   write_en,
	input   [14:0] write_addr,
	input   [31:0] write_data,
	
    output  [31:0] instruction
);
    reg [31:0] mem [0:32767]; 
   
    integer i; 
    reg [1023:0] instr_file;
   initial begin
  
    if (!$value$plusargs("instr_file=%s", instr_file)) begin
    instr_file = "instruction_mem.hex";  
     end

    $display("Loading instruction memory from: %s", instr_file);

    $readmemh(instr_file, mem);
    end 
 

always@(posedge clk or posedge rst)
begin

    if(rst)begin

        for(i=0; i<32768 ; i= i+1 )
            mem[i] <= 32'd0; 
        end

    else if (write_en)

mem[write_addr] <= write_data ; 
end

assign instruction = mem[pc]; 
endmodule


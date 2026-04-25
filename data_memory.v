/*module data_memory (
    input          clk,
    input          mem_read,
    input          mem_write,
    input   [31:0] addr,          // byte address
    input   [31:0] write_data,    // from store datapath
    input   [3:0]  byte_enable,   // from store datapath
    output  [31:0] mem_data_out   // to load datapath
);
  //  parameter MEM_BYTES = 4294967296;
    parameter ADDR_BITS = 32;   // log2(1024)

    reg [7:0] mem [ 0 : 32767 ];

    wire [ADDR_BITS-1:0] mem_addr = addr; //[ADDR_BITS-1:0];

    integer i;
    initial begin
        for(i=0;i<32768;i=i+1)
            mem[i] = 8'b0; // avoid X in simulation
    end

    // WRITE — Byte controlled
    always @(posedge clk) begin
        if (mem_write) begin
          //  if (byte_enable[0]) mem[addr]     <= write_data[7:0];
            //if (byte_enable[1]) mem[addr+1]   <= write_data[15:8];
            //if (byte_enable[2]) mem[addr+2]   <= write_data[23:16];
            //if (byte_enable[3]) mem[addr+3]   <= write_data[31:24];

	    if (byte_enable[0]) mem[mem_addr] <= write_data[7:0];
            if (byte_enable[1]) mem[mem_addr + {{(ADDR_BITS-1){1'b0}}, 1'b1}] <= write_data[15:8];
            if (byte_enable[2]) mem[mem_addr + {{(ADDR_BITS-2){1'b0}}, 2'b10}] <= write_data[23:16];
            if (byte_enable[3]) mem[mem_addr + {{(ADDR_BITS-2){1'b0}}, 2'b11}] <= write_data[31:24];	
        end
    end

    // READ — Form 32-bit word from 4 bytes (combinational)
   // always @(mem_read  or addr ) begin
     //   if (mem_read) begin
       //     mem_data_out = { mem[addr+3], mem[addr+2], mem[addr+1], mem[addr] };
        //end else begin
          //  mem_data_out = 32'b0;
        //end 
    //end 
assign mem_data_out = mem_read ? { mem[mem_addr + {{(ADDR_BITS-2){1'b0}}, 2'b11}],
             			   mem[mem_addr + {{(ADDR_BITS-2){1'b0}}, 2'b10}],
             			   mem[mem_addr + {{(ADDR_BITS-1){1'b0}}, 1'b1}],
           		           mem[mem_addr]  } : 32'b0 ;
endmodule

*/

/*

module data_memory (
    input           clk,
    input           mem_read,
    input           mem_write,
    input   [31:0]  addr,          // full 32-bit address (4GB space)
    input   [31:0]  write_data,
    input   [3:0]   byte_enable,
    output  [31:0]  mem_data_out
);

    // ============================================================
    // CONFIGURATION (PHYSICAL MEMORY, NOT 4GB!)
    // ============================================================
    parameter MEM_BYTES = 1024 * 1024;   // 1MB actual memory
    parameter ADDR_BITS = 20;            // log2(1MB)

    reg [7:0] mem [0:MEM_BYTES-1];

    // ============================================================
    // ADDRESS MAPPING (4GB ? 1MB)
    // ============================================================
    // Wrap full 32-bit address into available memory
    wire [ADDR_BITS-1:0] mem_addr = addr[ADDR_BITS-1:0];

    // Word-aligned base address (CRITICAL for correctness)
    wire [ADDR_BITS-1:0] base_addr = {mem_addr[ADDR_BITS-1:2], 2'b00};

    // ============================================================
    // INITIALIZATION
    // ============================================================
    integer i;
    initial begin
        for (i = 0; i < MEM_BYTES; i = i + 1)
            mem[i] = 8'b0;
    end

    // ============================================================
    // WRITE (BYTE ENABLE SUPPORT)
    // ============================================================
    always @(posedge clk) begin
        if (mem_write) begin
            if (byte_enable[0]) mem[mem_addr]     <= write_data[7:0];
            if (byte_enable[1]) mem[mem_addr + 1] <= write_data[15:8];
            if (byte_enable[2]) mem[mem_addr + 2] <= write_data[23:16];
            if (byte_enable[3]) mem[mem_addr + 3] <= write_data[31:24];
        end
    end

    // ============================================================
    // READ (ALIGNED WORD, LITTLE ENDIAN)
    // ============================================================
    assign mem_data_out = mem_read ? {
        mem[base_addr + 3],
        mem[base_addr + 2],
        mem[base_addr + 1],
        mem[base_addr]
    } : 32'b0;

endmodule

*/


module data_memory (
    input           clk,
    input           mem_read,
    input           mem_write,
    input   [31:0]  addr,          // FULL address (e.g., 0x800040A8)
    input   [31:0]  write_data,
    input   [3:0]   byte_enable,
    output  [31:0]  mem_data_out
);

    // ============================================================
    // CONFIGURATION
    // ============================================================
    parameter MEM_BYTES = 1024 * 1024; // 1MB
    parameter ADDR_BITS = 20;

    parameter BASE_ADDR = 32'h80000000;

    reg [7:0] mem [0:MEM_BYTES-1];

    // ============================================================
    // ADDRESS TRANSLATION (FULL ? LOCAL)
    // ============================================================
    wire [31:0] translated_addr = addr - BASE_ADDR;
    wire [ADDR_BITS-1:0] mem_addr = translated_addr[ADDR_BITS-1:0];

    // Word aligned base (for loads)
    wire [ADDR_BITS-1:0] base_addr = {mem_addr[ADDR_BITS-1:2], 2'b00};

    // ============================================================
    // WRITE (BYTE ENABLE)
    // ============================================================
    always @(posedge clk) begin
        if (mem_write) begin
            if (byte_enable[0]) mem[mem_addr]     <= write_data[7:0];
            if (byte_enable[1]) mem[mem_addr + 1] <= write_data[15:8];
            if (byte_enable[2]) mem[mem_addr + 2] <= write_data[23:16];
            if (byte_enable[3]) mem[mem_addr + 3] <= write_data[31:24];
        end
    end

    // ============================================================
    // READ (ALIGNED, LITTLE ENDIAN)
    // ============================================================
    assign mem_data_out = mem_read ? {
        mem[base_addr + 3],
        mem[base_addr + 2],
        mem[base_addr + 1],
        mem[base_addr]
    } : 32'b0;

endmodule

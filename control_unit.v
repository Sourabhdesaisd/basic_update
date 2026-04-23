module control_unit(
    input  [6:0] opcode,
    input  [2:0] func3,
    input        func7,

    output reg ex_alu_src,
    output reg mem_write,
   // output reg mem_read,
    output reg [2:0] mem_load_type,
    output reg [1:0] mem_store_type,
    output reg wb_reg_file,
    output reg memtoreg,  //same memread
    output reg Branch_1,
    output reg jal,
    output reg jalr,
 //   output reg auipc,
 //   output reg lui,
    output reg [3:0] alu_ctrl
);
    always @(opcode or func7 or func3 ) begin
        
        case (opcode)
            7'b0110011: begin // R-type
	        	ex_alu_src = 1'b0; 	mem_write = 1'b0; //	mem_read = 1'b0; 
                mem_load_type = 3'b010;	 	
                mem_store_type = 2'b10;
        	    memtoreg = 1'b0; 
                Branch_1 = 1'b0; 	jal = 1'b0; jalr = 1'b0;	 //auipc = 1'b0; lui = 1'b0;
        	    alu_ctrl = 4'b0000; 

                wb_reg_file = 1'b1; 
                case (func3)
                    3'b000: alu_ctrl = func7 ? 4'b0001 : 4'b0000; 
                    3'b111: alu_ctrl = 4'b0010; 
                    3'b110: alu_ctrl = 4'b0011; 
                    3'b100: alu_ctrl = 4'b0100; 
                    3'b001: alu_ctrl = 4'b0101; 
                    3'b101: alu_ctrl = func7 ? 4'b0111 : 4'b0110; 
                    3'b010: alu_ctrl = 4'b1000; 
                    3'b011: alu_ctrl = 4'b1001; 
                endcase
            end
            7'b0010011: begin // I-type ALU
		    mem_write = 1'b0;  //	mem_read = 1'b0; 
            mem_load_type = 3'b010;	 mem_store_type = 2'b10;
      		memtoreg = 1'b0; 	Branch_1 = 1'b0; 		jal = 1'b0; jalr = 1'b0; //auipc = 1'b0; 			lui = 1'b0;
        	alu_ctrl = 4'b0000; 

                ex_alu_src = 1'b1; 
                wb_reg_file = 1'b1; 
                case (func3)
                    3'b000: alu_ctrl = 4'b0000; 
                    3'b111: alu_ctrl = 4'b0010; 
                    3'b110: alu_ctrl = 4'b0011; 
                    3'b100: alu_ctrl = 4'b0100; 
                    3'b001: alu_ctrl = 4'b0101;
                    3'b101: alu_ctrl = func7 ? 4'b0111 : 4'b0110; 
                    3'b010: alu_ctrl = 4'b1000; 
                    3'b011: alu_ctrl = 4'b1001; 
                endcase
            end
            7'b0000011: begin // LOAD
		 mem_write = 1'b0;  	mem_load_type = 3'b010; 	mem_store_type = 2'b10;
       		 Branch_1 = 1'b0;		 jal = 1'b0; 			jalr = 1'b0; 	//	auipc = 1'b0; lui = 1'b0;
       		 alu_ctrl = 4'b0000; 
		
                ex_alu_src = 1'b1; 
                wb_reg_file = 1'b1; 
                memtoreg = 1'b1; 
                case (func3)
                    3'b000: mem_load_type = 3'b000; 
                    3'b001: mem_load_type = 3'b001; 
                    3'b010: mem_load_type = 3'b010; 
                    3'b100: mem_load_type = 3'b011; 
                    3'b101: mem_load_type = 3'b100; 
                    default: mem_load_type = 3'b010; 
                  endcase
            end
            7'b0100011: begin // STORE
	 	// mem_read = 1'b0; 
         mem_load_type = 3'b010; 	mem_store_type = 2'b10;
        	wb_reg_file = 1'b0;	 memtoreg = 1'b0; 		Branch_1 = 1'b0;		 jal = 1'b0; jalr = 1'b0; //auipc = 1'b0; lui = 1'b0;
        	alu_ctrl = 4'b0000; 

                ex_alu_src = 1'b1; 
                mem_write = 1'b1; 
                case (func3)
                    3'b000: mem_store_type = 2'b00; 
                    3'b001: mem_store_type = 2'b01; 
                    3'b010: mem_store_type = 2'b10; 
                    default: mem_store_type = 2'b10; 
                endcase
            end
            7'b1100011: begin // BRANCH
		        ex_alu_src = 1'b0;	 
                mem_write = 1'b0; //	mem_read = 1'b0; 
                mem_load_type = 3'b010; 	
                mem_store_type = 2'b10;
       		    wb_reg_file = 1'b0; 	 
                memtoreg = 1'b0; 	 
                jal = 1'b0;		 
                jalr = 1'b0; 		//	auipc = 1'b0; lui = 1'b0;
       
		
                Branch_1 = 1'b1; 
                alu_ctrl = 4'b0001; 
            end
            7'b1101111: begin // JAL
		ex_alu_src = 1'b0; 	mem_write = 1'b0;	// mem_read = 1'b0;
        mem_load_type = 3'b010; 	mem_store_type = 2'b10;
        	memtoreg = 1'b0;	 Branch_1 = 1'b0; 	 jalr = 1'b0;	//	 auipc = 1'b0; 			lui = 1'b0;
       		 alu_ctrl = 4'b0000; 

                jal = 1'b1; 
                wb_reg_file = 1'b1; 
            end
            7'b1100111: begin // JALR
		 mem_write = 1'b0;	// mem_read = 1'b0; 
         mem_load_type = 3'b010; 	mem_store_type = 2'b10;
        	memtoreg = 1'b0; 	Branch_1 = 1'b0; 		jal = 1'b0;  		//	auipc = 1'b0; lui = 1'b0;
       		 alu_ctrl = 4'b0000; 

                jalr = 1'b1; 
                ex_alu_src = 1'b1; 
                wb_reg_file = 1'b1; 
            end
            7'b0110111: begin // LUI
		ex_alu_src = 1'b1;	 mem_write = 1'b0; 	//mem_read = 1'b0;
        mem_load_type = 3'b010; 	mem_store_type = 2'b10;
       		  memtoreg = 1'b0;	 Branch_1 = 1'b0; 	jal = 1'b0;		 jalr = 1'b0; 		//	auipc = 1'b0; lui = 1'b0;
        

                wb_reg_file = 1'b1; 
                alu_ctrl = 4'b1010; 
            end
            7'b0010111: begin // AUIPC
		ex_alu_src = 1'b1; 	mem_write = 1'b0;	// mem_read = 1'b0;
        mem_load_type = 3'b010; 	mem_store_type = 2'b10;
       		 memtoreg = 1'b0; 	Branch_1 = 1'b0; 		jal = 1'b0;		 jalr = 1'b0; 	//		auipc = 1'b0; lui = 1'b0;
                
		wb_reg_file = 1'b1; 
                alu_ctrl = 4'b1011; 
            end
            default: begin 
		// defaults
        	ex_alu_src = 1'b0; mem_write = 1'b0; //mem_read = 1'b0;
            mem_load_type = 3'b010; mem_store_type = 2'b10;
      		  wb_reg_file = 1'b0; memtoreg = 1'b0; Branch_1 = 1'b0; jal = 1'b0; jalr = 1'b0;// auipc = 1'b0; lui = 1'b0;
      		  alu_ctrl = 4'b0000; 

		end
        endcase
    end
endmodule


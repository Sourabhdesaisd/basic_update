module int_top(
				input ic_clk				 ,
  			    input ic_rst				 ,
			   	input ic_rst_ack			 ,
				input  ext_int0				,
				input  ext_int1				,
				input  ext_int2				,
				input  ext_int3				,
				input  ext_int4				,
				input  ext_int5				,
				input  ext_int6				,
				input  ext_int7				,
				input  ext_int8				,
				input  ext_int9				,
				input  ext_int10			,
				input  ext_int11			,
				input  ext_int12			,
				input  ext_int13			,
				input  ext_int14			,
				input  ext_int15			,
				input  ext_int16			,
				input  ext_int17			,
				input  ext_int18			,
				input  ext_int19			,
				input  ext_int20			,
				input  ext_int21			,
				input  ext_int22			,
				input  ext_int23			,
				input  ext_int24			,
				input  ext_int25			,
				input  ext_int26			,
				input  ext_int27			,
				input  ext_int28			,
				input  ext_int29			,
				input  ext_int30			,
				input  ext_int31				,
				input  ext_int32			,
				input  ext_int33			,
				input  ext_int34			,
				input  ext_int35			,
				input  ext_int36			,
				input  ext_int37			,
				input  ext_int38			,
				input  ext_int39			,
				input  ext_int40			,
				input  ext_int41			,
				input  ext_int42			,
				input  ext_int43			,
				input  ext_int44			,
				input  ext_int45			,
				input  ext_int46			,
				input  ext_int47			,
				input [7:0] threshold		,
				output irq_request			,
				output [7:0]interrupt_out   ,
				//write and read signals from/to the core
				input 		zic_mmr_write_en_i				,//enable for write to mmr
				input 		[15:0]zic_mmr_write_addr_i		,//mmr write address
				input 		[31:0]zic_mmr_write_data_i		,//mmr write data
				input 		zic_mmr_read_en_i				,//enable for read from mmr
				input 		[15:0]zic_mmr_read_addr_i		,//mmr read address
				output 		[31:0]zic_mmr_read_data_o		,//mmr read data 
				input 		zic_ack_read_valid_en			,
				output 	[7:0]	zic_ack_int_id_o			,
				input 		zic_eoi_valid_i					,
				input   [7:0] 	zic_eoi_id_i				,
				input 	[47:0]	global_int_enable_bit_i		,
				input  	  		global_int_enable_valid_i	
				);

				wire [7:0] 	zic_ack_int_id_w;			
				wire zic_ack_write_valid_w;			
				wire [7:0] irq0_ctrl_w	;
				wire [7:0] irq1_ctrl_w	;
				wire [7:0] irq2_ctrl_w	;
				wire [7:0] irq3_ctrl_w	;
				wire [7:0] irq4_ctrl_w	;
				wire [7:0] irq5_ctrl_w	;
				wire [7:0] irq6_ctrl_w	;
				wire [7:0] irq7_ctrl_w	;
				wire [7:0] irq8_ctrl_w	;
				wire [7:0] irq9_ctrl_w	;
				wire [7:0] irq10_ctrl_w	;
				wire [7:0] irq11_ctrl_w	;
				wire [7:0] irq12_ctrl_w	;
				wire [7:0] irq13_ctrl_w	;
				wire [7:0] irq14_ctrl_w	;
				wire [7:0] irq15_ctrl_w	;
				wire [7:0] irq16_ctrl_w	;
				wire [7:0] irq17_ctrl_w	;
				wire [7:0] irq18_ctrl_w	;
				wire [7:0] irq19_ctrl_w	;
				wire [7:0] irq20_ctrl_w	;
				wire [7:0] irq21_ctrl_w	;
				wire [7:0] irq22_ctrl_w	;
				wire [7:0] irq23_ctrl_w	;
				wire [7:0] irq24_ctrl_w	;
				wire [7:0] irq25_ctrl_w	;
				wire [7:0] irq26_ctrl_w	;
				wire [7:0] irq27_ctrl_w	;
				wire [7:0] irq28_ctrl_w	;
				wire [7:0] irq29_ctrl_w	;
				wire [7:0] irq30_ctrl_w	;
				wire [7:0] irq31_ctrl_w	;
				wire [7:0] irq32_ctrl_w	;
				wire [7:0] irq33_ctrl_w	;
				wire [7:0] irq34_ctrl_w	;
				wire [7:0] irq35_ctrl_w	;
				wire [7:0] irq36_ctrl_w	;
				wire [7:0] irq37_ctrl_w	;
				wire [7:0] irq38_ctrl_w	;
				wire [7:0] irq39_ctrl_w	;
				wire [7:0] irq40_ctrl_w	;
				wire [7:0] irq41_ctrl_w	;
				wire [7:0] irq42_ctrl_w	;
				wire [7:0] irq43_ctrl_w	;
				wire [7:0] irq44_ctrl_w	;
				wire [7:0] irq45_ctrl_w	;
				wire [7:0] irq46_ctrl_w	;
				wire [7:0] irq47_ctrl_w	;
				wire [47:0] zic_int_en_w;					
				wire [7:0]  out_w       ;          
				wire	zic_eoi_valid_w ;					
				wire	zic_eoi_w		;
				wire	zic_ack_w		;				
				wire zic_nxtp_valid_w	;	
				wire [7:0] zic_nxtp_id_w;				
				wire zic_int_pending_valid_w ;
			    wire [47:0] zic_int_pending_bit_w;
				//wire [47:0]interrupt_pending_w;

		zic_mmr_top mmr(
					.zic_clk					(ic_clk),
					.zic_rst					(ic_rst),
					.zic_mmr_write_en_i			(zic_mmr_write_en_i),
					.zic_mmr_write_addr_i		(zic_mmr_write_addr_i),
					.zic_mmr_write_data_i		(zic_mmr_write_data_i),
					.zic_mmr_read_en_i			(zic_mmr_read_en_i),
					.zic_mmr_read_addr_i		(zic_mmr_read_addr_i),
					.zic_mmr_read_data_o		(zic_mmr_read_data_o),
					.irq0_ctrl_o				(irq0_ctrl_w),
					.irq1_ctrl_o				(irq1_ctrl_w),
					.irq2_ctrl_o				(irq2_ctrl_w),
					.irq3_ctrl_o				(irq3_ctrl_w),
					.irq4_ctrl_o				(irq4_ctrl_w),
					.irq5_ctrl_o				(irq5_ctrl_w),
					.irq6_ctrl_o				(irq6_ctrl_w),
					.irq7_ctrl_o				(irq7_ctrl_w),
					.irq8_ctrl_o				(irq8_ctrl_w),
					.irq9_ctrl_o				(irq9_ctrl_w),
					.irq10_ctrl_o				(irq10_ctrl_w),
					.irq11_ctrl_o				(irq11_ctrl_w),
					.irq12_ctrl_o				(irq12_ctrl_w),
					.irq13_ctrl_o				(irq13_ctrl_w),
					.irq14_ctrl_o				(irq14_ctrl_w),
					.irq15_ctrl_o				(irq15_ctrl_w),
					.irq16_ctrl_o				(irq16_ctrl_w),
					.irq17_ctrl_o				(irq17_ctrl_w),
					.irq18_ctrl_o				(irq18_ctrl_w),
					.irq19_ctrl_o				(irq19_ctrl_w),
					.irq20_ctrl_o				(irq20_ctrl_w),
					.irq21_ctrl_o				(irq21_ctrl_w),
					.irq22_ctrl_o				(irq22_ctrl_w),
					.irq23_ctrl_o				(irq23_ctrl_w),
					.irq24_ctrl_o				(irq24_ctrl_w),
					.irq25_ctrl_o				(irq25_ctrl_w),
					.irq26_ctrl_o				(irq26_ctrl_w),
					.irq27_ctrl_o				(irq27_ctrl_w),
					.irq28_ctrl_o				(irq28_ctrl_w),
					.irq29_ctrl_o				(irq29_ctrl_w),
					.irq30_ctrl_o				(irq30_ctrl_w),
					.irq31_ctrl_o				(irq31_ctrl_w),
					.irq32_ctrl_o				(irq32_ctrl_w),
					.irq33_ctrl_o				(irq33_ctrl_w),
					.irq34_ctrl_o				(irq34_ctrl_w),
					.irq35_ctrl_o				(irq35_ctrl_w),
					.irq36_ctrl_o				(irq36_ctrl_w),
					.irq37_ctrl_o				(irq37_ctrl_w),
					.irq38_ctrl_o				(irq38_ctrl_w),
					.irq39_ctrl_o				(irq39_ctrl_w),
					.irq40_ctrl_o				(irq40_ctrl_w),
					.irq41_ctrl_o				(irq41_ctrl_w),
					.irq42_ctrl_o				(irq42_ctrl_w),
					.irq43_ctrl_o				(irq43_ctrl_w),
					.irq44_ctrl_o				(irq44_ctrl_w),
					.irq45_ctrl_o				(irq45_ctrl_w),
					.irq46_ctrl_o				(irq46_ctrl_w),
					.irq47_ctrl_o				(irq47_ctrl_w),
					.zic_int_en_o				(zic_int_en_w),
					.zic_ack_write_valid_i		(zic_ack_write_valid_w),
					.zic_ack_int_id_i			(zic_ack_int_id_w),
					.zic_ack_read_valid_en		(zic_ack_read_valid_en),
					.zic_ack_int_id_o			(zic_ack_int_id_o),
					.zic_ack_o					(zic_ack_w),
					.zic_eoi_valid_i			(zic_eoi_valid_i),
					.zic_eoi_id_i				(zic_ack_int_id_w),
					.zic_eoi_o					(zic_eoi_w),
					.zic_nxtp_valid_i			(zic_nxtp_valid_w),
					.zic_nxtp_id_i				(zic_nxtp_id_w),
					.zic_int_pending_valid_i 	(zic_int_pending_valid_w),
					.zic_int_pending_bit_i		(zic_int_pending_bit_w),
					.global_int_enable_bit_i	(global_int_enable_bit_i),
					.global_int_enable_valid_i  (global_int_enable_valid_i)
					);
		ic_top ic(
				.ic_clk				    (ic_clk),
  			    .ic_rst				    (ic_rst),
			   	.ic_rst_ack			    (ic_rst_ack),
				.ack_in				    (zic_ack_w),
				.ack_id					(zic_ack_int_id_o),
				 .interrupt_enable		(zic_int_en_w),
				 .ext_int0				(ext_int0),						  
				 .ext_int1				(ext_int1),
				 .ext_int2				(ext_int2),
				 .ext_int3				(ext_int3),
				 .ext_int4				(ext_int4),
				 .ext_int5				(ext_int5),
				 .ext_int6				(ext_int6),
				 .ext_int7				(ext_int7),
				 .ext_int8				(ext_int8),
				 .ext_int9				(ext_int9),
				 .ext_int10				(ext_int10),
				 .ext_int11				(ext_int11),
				 .ext_int12				(ext_int12),
				 .ext_int13				(ext_int13),
				 .ext_int14				(ext_int14),
				 .ext_int15				(ext_int15),
				 .ext_int16				(ext_int16),
				 .ext_int17				(ext_int17),
				 .ext_int18				(ext_int18),
				 .ext_int19				(ext_int19),
				 .ext_int20				(ext_int20),
				 .ext_int21				(ext_int21),
				 .ext_int22				(ext_int22),
				 .ext_int23				(ext_int23),
				 .ext_int24				(ext_int24),
				 .ext_int25				(ext_int25),
				 .ext_int26				(ext_int26),
				 .ext_int27				(ext_int27),
				 .ext_int28				(ext_int28),
				 .ext_int29				(ext_int29),
				 .ext_int30				(ext_int30),
				 .ext_int31				(ext_int31),						  
				 .ext_int32				(ext_int32),
				 .ext_int33				(ext_int33),
				 .ext_int34				(ext_int34),
				 .ext_int35				(ext_int35),
				 .ext_int36				(ext_int36),
				 .ext_int37				(ext_int37),
				 .ext_int38				(ext_int38),
				 .ext_int39				(ext_int39),
				 .ext_int40				(ext_int40),
				 .ext_int41				(ext_int41),
				 .ext_int42				(ext_int42),
				 .ext_int43				(ext_int43),
				 .ext_int44				(ext_int44),
				 .ext_int45				(ext_int45),
				 .ext_int46				(ext_int46),
				 .ext_int47				(ext_int47),
				.int0_lp_i				(irq0_ctrl_w),
				.int1_lp_i				(irq1_ctrl_w),
				.int2_lp_i				(irq2_ctrl_w),
				.int3_lp_i				(irq3_ctrl_w),
				.int4_lp_i				(irq4_ctrl_w),
				.int5_lp_i				(irq5_ctrl_w),
				.int6_lp_i				(irq6_ctrl_w),
				.int7_lp_i				(irq7_ctrl_w),
				.int8_lp_i				(irq8_ctrl_w),
				.int9_lp_i				(irq9_ctrl_w),
				.int10_lp_i				(irq10_ctrl_w),
				.int11_lp_i				(irq11_ctrl_w),
				.int12_lp_i				(irq12_ctrl_w),
				.int13_lp_i				(irq13_ctrl_w),
				.int14_lp_i				(irq14_ctrl_w),
				.int15_lp_i				(irq15_ctrl_w),
				.int16_lp_i				(irq16_ctrl_w),
				.int17_lp_i				(irq17_ctrl_w),
				.int18_lp_i				(irq18_ctrl_w),
				.int19_lp_i				(irq19_ctrl_w),
				.int20_lp_i				(irq20_ctrl_w),
				.int21_lp_i				(irq21_ctrl_w),
				.int22_lp_i				(irq22_ctrl_w),
				.int23_lp_i				(irq23_ctrl_w),
				.int24_lp_i				(irq24_ctrl_w),
				.int25_lp_i				(irq25_ctrl_w),
				.int26_lp_i				(irq26_ctrl_w),
				.int27_lp_i				(irq27_ctrl_w),
				.int28_lp_i				(irq28_ctrl_w),
				.int29_lp_i				(irq29_ctrl_w),
				.int30_lp_i				(irq30_ctrl_w),
				.int31_lp_i				(irq31_ctrl_w),
				.int32_lp_i				(irq32_ctrl_w),
				.int33_lp_i				(irq33_ctrl_w),
				.int34_lp_i				(irq34_ctrl_w),
				.int35_lp_i				(irq35_ctrl_w),
				.int36_lp_i				(irq36_ctrl_w),
				.int37_lp_i				(irq37_ctrl_w),
				.int38_lp_i				(irq38_ctrl_w),
				.int39_lp_i				(irq39_ctrl_w),
				.int40_lp_i				(irq40_ctrl_w),
				.int41_lp_i				(irq41_ctrl_w),
				.int42_lp_i				(irq42_ctrl_w),
				.int43_lp_i				(irq43_ctrl_w),
				.int44_lp_i				(irq44_ctrl_w),
				.int45_lp_i				(irq45_ctrl_w),
				.int46_lp_i				(irq46_ctrl_w),
				.int47_lp_i				(irq47_ctrl_w),
				.threshold				(threshold),
				.irq_request			(irq_request),
				.out_id					(zic_ack_int_id_w),
				.interrupt_out			(interrupt_out), 
				.interrupt_pending_o	(zic_int_pending_bit_w)
				);
endmodule

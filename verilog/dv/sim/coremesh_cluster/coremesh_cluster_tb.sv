/****************************************************************************
 * coremesh_cluster_tb.sv
 ****************************************************************************/
`ifdef NEED_TIMESCALE
`timescale 1ns/1ns
`endif

`include "generic_sram_byte_en_macros.svh"
  
/**
 * Module: coremesh_cluster_tb
 * 
 * TODO: Add module documentation
 */
module coremesh_cluster_tb(input clock);
	
`ifdef HAVE_HDL_CLOCKGEN
	reg clock_r = 0;
	initial begin
		forever begin
`ifdef NEED_TIMESCALE
			#10;
`else
			#10ns;
`endif
			clock_r <= ~clock_r;
		end
	end
	assign clock = clock_r;
`endif
	
`ifdef IVERILOG
`include "iverilog_control.svh"
`endif
	
	reg reset = 0;
	reg[7:0] reset_cnt = 0;

	always @(posedge clock) begin
		if (reset_cnt == 20) begin
			reset <= 0;
		end else begin
			if (reset_cnt == 1) begin
				reset <= 1;
			end
			reset_cnt <= reset_cnt + 1;
		end
	end
	
	`GENERIC_SRAM_BYTE_EN_WIRES(dut2sram_, 20, 32);
	
	coremesh_cluster_sram u_dut (
		.clock            (clock           ), 
		.reset            (reset           ), 
/*		.hartid           (0               ),*/ 
		`GENERIC_SRAM_BYTE_EN_CONNECT(sram_, dut2sram_));

    generic_sram_byte_en_target_bfm #(
    	.DAT_WIDTH  (32 ), 
    	.ADR_WIDTH  (20 )
    	) u_sram_bfm (
    	.clock      (clock     ), 
    	.adr        (dut2sram_addr       ), 
    	.we         (dut2sram_write_en        ), 
    	.sel        (dut2sram_byte_en       ), 
    	.dat_r      (dut2sram_read_data     ), 
    	.dat_w      (dut2sram_write_data     ));


endmodule



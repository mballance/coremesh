
/****************************************************************************
 * coremesh_cluster_sram.v
 ****************************************************************************/

`include "generic_sram_byte_en_macros.svh"
`include "wishbone_tag_macros.svh"

/**
 * Module: coremesh_cluster
 * 
 * TODO: Add module documentation
 */
module coremesh_cluster_sram(
		input			clock,
		input			reset,
		
		// Upper bits of the hartid
//		input[31:2]		hartid,

		`GENERIC_SRAM_BYTE_EN_INITIATOR_PORT(sram_, 20, 32)
		);
	
	localparam ENABLE_COMPRESSED = 1;
	localparam ENABLE_MUL_DIV = 0;
	localparam ENABLE_DEP = 0;
	localparam ENABLE_COUNTERS = 0;
	localparam VENDORID = 0;

	localparam N_CORES = 4;
	localparam N_INITIATORS = N_CORES;
	localparam N_TARGETS = 1;
	`WB_TAG_WIRES_ARR(core2ic_, 32, 32, 1, 1, 4, N_INITIATORS);
	`WB_TAG_WIRES_ARR(ic2out_, 32, 32, 1, 1, 4, N_TARGETS);
	
	wire[3:0] core_irq;
	
	wire[31:0] hartid = {32{1'b0}};

	generate
		genvar core_ii;
		for (core_ii=0; core_ii<N_CORES; core_ii=core_ii+1) begin : cores
			fwrisc_rv32imca_wb #(
				.VENDORID  (VENDORID )
				) u_core (
				.clock     (clock            ), 
				.reset     (reset            ), 
				.hartid    (hartid+core_ii   ), 
				`WB_TAG_CONNECT_ARR( , core2ic_, core_ii, 32, 32, 1, 1, 4),
				.irq       (core_irq[core_ii]));
		end
	endgenerate
	
	wb_interconnect_tag_NxN #(
		.ADR_WIDTH     (32    ), 
		.DAT_WIDTH     (32    ), 
		.TGC_WIDTH     (4     ), 
		.TGA_WIDTH     (1     ), 
		.TGD_WIDTH     (1     ), 
		.N_INITIATORS  (N_INITIATORS ), 
		.N_TARGETS     (N_TARGETS    ), 
		.T_ADR_MASK    ({
			32'hFFC0_0000
			}), 
		.T_ADR         ({
			32'h8000_0000
			})
		) u_ic (
		.clock         (clock        ), 
		.reset         (reset        ), 
		`WB_TAG_CONNECT( , core2ic_),
		`WB_TAG_CONNECT(t, ic2out_)
		);
	
	fw_wishbone_sram_ctrl_single #(
		.ADR_WIDTH     (20    ), 
		.DAT_WIDTH     (32    )
		) u_mem_ctrl (
		.clock         (clock        ), 
		.reset         (reset        ), 
		`WB_TAG_CONNECT(t_, ic2out_),
		`GENERIC_SRAM_BYTE_EN_CONNECT(i_, sram_));

endmodule



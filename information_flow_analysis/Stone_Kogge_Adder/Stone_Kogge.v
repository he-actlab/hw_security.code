module stone_kogge #(
	parameter	ADDER_WIDTH	=	4
)
(

	input	wire												CLK,
	input	wire												RST,

	input	wire	[ADDER_WIDTH-1	:	0]	ADD_VAL1,
	input	wire	[ADDER_WIDTH-1	:	0]	ADD_VAL2,
	input	wire												ADD_VAL1_VALID,
	input	wire												ADD_VAL2_VALID,
	
	output	reg												IS_READY,
	output	reg	[ADDER_WIDTH-1	:	0]	OUTPUT_VAL,
	output	reg												OUTPUT_VALID
);

	localparam	STAGE_BITS	=	$clog2(ADDER_WIDTH)+1;
	localparam	NUM_STAGES	=	$clog2(ADDER_WIDTH);

	reg	[ADDER_WIDTH-1	:	0]					PRP_CURR_REG;
	reg	[ADDER_WIDTH-1	:	0]					PRP_PREV_REG;
	reg	[ADDER_WIDTH-1	:	0]					GEN_REG;
	reg	[ADDER_WIDTH-1	:	0]					MODULE_FINISHED;

	reg	[STAGE_BITS-1		:	0]					STAGE;

	wire	[ADDER_WIDTH-1	:	0]				PRP_OUT;
	wire	[ADDER_WIDTH-1	:	0]				GEN_OUT;
	wire	[ADDER_WIDTH-1	:	0]				SUM_OUT;
	


	always @ (posedge CLK) 
	begin: CONTROL_SIGNALS
		if(RST) begin
			IS_READY				<=	1;
			OUTPUT_VAL			<=	0;
			OUTPUT_VALID		<=	0;

			PRP_CURR_REG		<=	0;
			PRP_PREV_REG		<=	0;
			GEN_REG					<=	0;
			STAGE						<=	0;
			MODULE_FINISHED	<=	0;
		end
		else begin
			if(IS_READY && ADD_VAL1_VALID && ADD_VAL2_VALID) begin
				IS_READY			<= 0;
				PRP_CURR_REG	<= ADD_VAL1;
				PRP_PREV_REG	<= ADD_VAL2;
			end
		end


	end

	always @ (posedge CLK) 
	begin: STAGE_UPDATE
			if(!IS_READY) begin
				STAGE <= STAGE + 1;
			end
			else begin
				STAGE <= 0;
			end
	end


	always @ (posedge CLK) 
	begin: SIGNAL_ROUTING
		if(!IS_READY) begin
			case(STAGE)
				'd0: begin
					PRP_CURR_REG				<= PRP_OUT;
					PRP_PREV_REG[3]			<= PRP_OUT[2];
					PRP_PREV_REG[2]			<= PRP_OUT[1];
					PRP_PREV_REG[1]			<= PRP_OUT[0];
			
					GEN_REG[3]					<=	GEN_OUT[2];
					GEN_REG[2]					<=	GEN_OUT[1];
					GEN_REG[1]					<=	GEN_OUT[0];
					MODULE_FINISHED[0]	<= 'b1;
				end
				'd1: begin
					PRP_CURR_REG				<= PRP_OUT;
					PRP_PREV_REG[3]			<= PRP_OUT[1];
					PRP_PREV_REG[2]			<= PRP_OUT[0];
			
					GEN_REG[3]					<=	GEN_OUT[1];
					GEN_REG[2]					<=	GEN_OUT[0];
					MODULE_FINISHED[1]	<= 'b1;
				end
				'd2: begin
					OUTPUT_VAL					<= SUM_OUT;
					OUTPUT_VALID				<= 1;
					IS_READY						<= 0;
					MODULE_FINISHED			<= 0;
				end

			endcase
		end
	end
	

genvar i;
generate
for(i=0; i< ADDER_WIDTH; i=i+1) begin
	stone_kogge_PE pe_i
	(
		.CLK				(CLK								),
		.RST				(RST								),
		.PRP_IN_CURR(PRP_CURR_REG[i]		),
		.PRP_IN_PREV(PRP_PREV_REG[i]		),
		.GEN_IN			(GEN_REG[i]					),
		.FINISHED		(MODULE_FINISHED[i]	),

		.PRP_OUT		(PRP_OUT[i]					),
		.GEN_OUT		(GEN_OUT[i]					),
		.SUM_OUT		(SUM_OUT[i]					)
		);
	end
endgenerate


endmodule

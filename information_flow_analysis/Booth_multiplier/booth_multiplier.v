/*
	Booth multiplication module
	Author : Hyoukjun Kwon
	Date   : 9-23-2015
*/

module booth_multiplier #(
	parameter INPUT_BITS = 32
)
(
	input	wire													CLK,
	input	wire													RST,

	input	wire		[INPUT_BITS-1 : 0]		MUL_1,
	input	wire		[INPUT_BITS-1 : 0]		MUL_2,

	input	wire													MUL_1_VALID,
	input	wire													MUL_2_VALID,

	output	reg		[STATE_BITS-1		: 0]	STATE,
	output	wire	[OUTPUT_BITS-1	: 0]	MUL_OUT,
	output	reg													MUL_OUT_VALID
);

/***********************************************/
//							Local parameters							 //
/***********************************************/
localparam	OUTPUT_BITS = 2 * INPUT_BITS;
localparam	STATE_BITS	= 2;
localparam	STAGE_BITS	=	$clog2(OUTPUT_BITS) +1;

//Module State
localparam	IDLE				= 0;
localparam	BUSY				= 1;

/***********************************************/
//									Registers									 //
/***********************************************/
reg			[STAGE_BITS		:	0]	STAGE;

reg			[INPUT_BITS-1	:	0]	MULTIPLICAND;
reg			[INPUT_BITS-1	:	0]	MULTIPLIER;
reg			[INPUT_BITS-1	:	0]	NEG_MULTIPLICAND;
reg			[INPUT_BITS-1	:	0]	NEG_MULTIPLIER;

reg			[OUTPUT_BITS	:	0]	PRODUCT;


/***********************************************/
//										Wires										 //
/***********************************************/
wire		[1						:	0]	LAST_TWO_BITS;
wire		[INPUT_BITS		:	0]	UPPER_PRODUCT;
wire		[INPUT_BITS+1	:	0]	LOWER_PRODUCT;


/***********************************************/
//							Combinational Logics					 //
/***********************************************/
assign	MUL_OUT				= PRODUCT[OUTPUT_BITS	:	1];
assign	LAST_TWO_BITS	=	PRODUCT[1:0];

assign	UPPER_PRODUCT	=	PRODUCT[OUTPUT_BITS -: INPUT_BITS];
assign	LOWER_PRODUCT	=	PRODUCT[0						+: INPUT_BITS+1];

/***********************************************/
//							Sequential Logics							 //
/***********************************************/

always @ (posedge CLK)
begin: CONTROL_LOGICS
	if(RST) begin
		STATE					<=	IDLE;
		PRODUCT				<=	0;
		MUL_OUT_VALID	<=	0;
		STAGE					<=	0;
	end
	else if(STATE == IDLE) begin
		if(MUL_1_VALID && MUL_2_VALID) begin
			STATE							<=	BUSY;
			STAGE							<=	0;
			MULTIPLICAND			<=	MUL_1;
			MULTIPLIER				<=	MUL_2;
			NEG_MULTIPLICAND	<=	~MUL_1 + 1;
			NEG_MULTIPLIER		<=	~MUL_2 + 1;
		end
	end
	else begin //if(!RST && STATE == BUSY)
		if(STAGE == INPUT_BITS-1) begin
			STATE					<=	IDLE;
			STAGE					<=	STAGE+1;	
			MUL_OUT_VALID <=	1;
		end
	end
end


always @ (posedge CLK)
begin: PRODUCT_CALCULATION
	if(STATE == BUSY) begin
		case(LAST_TWO_BITS)
			'b01: begin //Add multiplicand
				PRODUCT <= ({(UPPER_PRODUCT + MULTIPLICAND), LOWER_PRODUCT} >>> 1); 
			end
			'b10: begin	//Subtract multiplicand
				PRODUCT <= ({(UPPER_PRODUCT + NEG_MULTIPLICAND), LOWER_PRODUCT} >>> 1); 
			end
			default: begin
				PRODUCT	<= (PRODUCT >>> 1);
			end
		endcase
	end
end

endmodule

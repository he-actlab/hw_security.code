/*
	Author		: Hyoukjun Kwon
	Date		: 09-21-2015
	Module name : hamming_detector
	Description : It detects the error of the (7,4) hamming code.
*/

/*
	Information flow policy



*/




//TODO: Parameterized this module for general Hamming code generation.

module hamming_detector #(
	parameter HAMMING_BITS = 4
)
(
	/* Inputs */
	input	wire	[HAMMING_BITS-1	:	0]	DATA_IN,

	/* Outputs */
	output	wire							EXIST_ERROR
);

localparam	PARITY_BITS = HAMMING_BITS -1;

wire	[PARITY_BITS-1	:	0]	CHECK_VALUES;

assign CHECK_VALUES[0] = DATA_IN[6] ^ DATA_IN[4] ^ DATA_IN[2] ^ DATA_IN[0];
assign CHECK_VALUES[1] = DATA_IN[5] ^ DATA_IN[4] ^ DATA_IN[1] ^ DATA_IN[0];
assign CEHCK_VALUES[2] = DATA_IN[3] ^ DATA_IN[2] ^ DATA_IN[1] ^ DATA_IN[0];

assign EXIST_ERROR = CHECK_VALUES[0] ^ CHECK_VALUES[1] ^ CHECK_VALUES[2]; 

endmodule

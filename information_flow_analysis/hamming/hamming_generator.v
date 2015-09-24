/*
	Author		: Hyoukjun Kwon
	Date		: 09-21-2015
	Module name : hamming_generator
	Description : It generates (7,4) hamming code using the 4bit input data.
	              It should be parameterized in the future to support general hamming code generator.
*/

/*
	Information flow policy

	1.The original message must be conserved.
		(DATA_OUT[0] == DATA_IN[0])
		&& (DATA_OUT[1] == DATA_IN[1])
		&& (DATA_OUT[2] == DATA_IN[2])
		&& (DATA_OUT[4] == DATA_IN[3])

	2.The paritiy bits must be geneated properly.
		DATA_OUT[3] == (DATA_IN[4] + DATA_IN[2] + DATA_IN[0]) mod 2
		DATA_OUT[5] == (DATA_IN[4] + DATA_IN[1] + DATA_IN[0]) mod 2
		DATA_OUT[6] == (DATA_IN[2] + DATA_IN[1] + DATA_IN[0]) mod 2

	3.The same output should be obtained if we apply the same input. 

*/
//TODO: Parameterized this module for general Hamming code generation.

module hamming_generator #(
	parameter INPUT_BITS = 4
)
(
	/* Inputs */
	input	wire	[INPUT_BITS-1	:	0]	DATA_IN,

	/* Outputs */
	output	wire	[OUTPUT_BITS-1	:	0]	DATA_OUT
);


localparam PARITY_BITS	=	INPUT_BITS-1;
localparam OUTPUT_BITS	=	INPUT_BITS + (INPUT_BITS -1);

/* Original messages */
assign DATA_OUT[0] = DATA_IN[0];
assign DATA_OUT[1] = DATA_IN[1];
assign DATA_OUT[2] = DATA_IN[2];
assign DATA_OUT[4] = DATA_IN[3];

/* Parity bits */
assign DATA_OUT[3] = DATA_IN[4] ^ DATA_IN[2] ^ DATA_IN[0];
assign DATA_OUT[5] = DATA_IN[4] ^ DATA_IN[1] ^ DATA_IN[0];
assign DATA_OUT[6] = DATA_IN[2] ^ DATA_IN[1] ^ DATA_IN[0];

endmodule

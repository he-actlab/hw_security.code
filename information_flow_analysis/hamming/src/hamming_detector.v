module hamming_generator #(
	parameter INPUT_BITS = 4
)
(
	input	wire	[INPUT_BITS-1	:	0]	DATA_IN,
	
	output	wire	[OUTPUT_BITS-1	:	0]	DATA_OUT
);

localparam OUTPUT_BITS = OUTPUT_BITS + (OUTPUT_BITS -1);

/* Original messages */
assign DATA_OUT[0] = DATA_IN[0];
assign DATA_OUT[1] = DATA_IN[1];
assign DATA_OUT[2] = DATA_IN[2];
assign DATA_OUT[4] = DATA_IN[3];

assign DATA_OUT[3] = DATA_IN[4] ^ DATA_IN[2] ^ DATA_IN[0];
assign DATA_OUT[5] = DATA_IN[4] ^ DATA_IN[1] ^ DATA_IN[0];
assign DATA_OUT[6] = DATA_IN[2] ^ DATA_IN[1] ^ DATA_IN[0];

endmodule

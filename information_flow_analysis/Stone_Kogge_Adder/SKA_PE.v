module stone_kogge_PE
(
	input		wire	CLK,
	input		wire	RST,
	input		wire	PRP_IN_CURR,
	input		wire	PRP_IN_PREV,
	input		wire	GEN_IN,
	input		wire	FINISHED,

	output	reg		PRP_OUT,
	output	reg		GEN_OUT,
	output	reg		SUM_OUT

);

reg	IS_FINISHED;

always @(posedge CLK)
begin
	if(RST) begin
		PRP_OUT <= 0;
		GEN_OUT <= 0;
		SUM_OUT <= 0;
		IS_FINISHED <= 0;
	end
	else if(!IS_FINISHED) begin
		PRP_OUT <=	PRP_IN_CURR ^ PRP_IN_PREV;
		GEN_OUT	<=	(PRP_IN_CURR & PRP_IN_PREV) | GEN_IN;
		SUM_OUT	<=	PRP_IN_CURR ^ GEN_IN;	
		if(FINISHED) begin
			IS_FINISHED <= FINISHED;
		end
	end
end



endmodule

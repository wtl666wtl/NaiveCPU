module regfile(
	input wire clk,
	input wire rst,
	input wire rdy,
	//write
	input wire we,
	input wire[`RegAddrBus] waddr,
	input wire[`RegBus] wdata,
	
	//read1
	input wire re1,
	input wire[`RegAddrBus] raddr1,
	output reg[`RegBus] rdata1,
	
	//read2
	input wire re2,
	input wire[`RegAddrBus] raddr2,
	output reg[`RegBus] rdata2
);

//32 32-bits reg
reg[`RegBus] regs[0:`RegNum-1];
integer i;

//write
always @(posedge clk) begin
	if(rst==`RstDisable&&rdy) begin
		if((we==`WriteEnable)&&(waddr!=`RegNumLog2'h0)) begin
			regs[waddr]<=wdata;
		end
	end else if(rdy) begin
		for(i=0;i<`RegNum;i=i+1)regs[i]<=`ZeroWord;
	end
end

//read1
always @(*) begin
	if(rst==`RstEnable) begin
		rdata1<=`ZeroWord;
	end else begin
		if(raddr1==`RegNumLog2'h0) begin
			rdata1<=`ZeroWord;
		end else if((raddr1==waddr)&&(we==`WriteEnable)&&(re1==`ReadEnable)) begin
			rdata1<=wdata;
		end else if(re1==`ReadEnable) begin
			rdata1<=regs[raddr1];
		end else begin
			rdata1<=`ZeroWord;
		end
	end
end

//read2
always @(*) begin
	if(rst==`RstEnable) begin
		rdata2<=`ZeroWord;
	end else begin
		if(raddr2==`RegNumLog2'h0) begin
			rdata2<=`ZeroWord;
		end else if((raddr2==waddr)&&(we==`WriteEnable)&&(re2==`ReadEnable)) begin
			rdata2<=wdata;
		end else if(re2==`ReadEnable) begin
			rdata2<=regs[raddr2];
		end else begin
			rdata2<=`ZeroWord;
		end
	end
end

endmodule
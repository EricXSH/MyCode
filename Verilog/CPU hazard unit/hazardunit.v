module hazardunit(IFIDWrite,PCWrite,HazardMux, idex_rt, idex_memread, ifid_rs, ifid_rt);

	output 	IFIDWrite, PCWrite, HazardMux;
	input [4:0] idex_rt, ifid_rs, ifid_rt;
	input idex_memread;

		assign IFIDWrite = (idex_memread && (idex_rt == ifid_rs || idex_rt == ifid_rt))? 0:1;
		assign PCWrite = (idex_memread && (idex_rt == ifid_rs || idex_rt == ifid_rt))? 0:1;
		assign HazardMux = (idex_memread && (idex_rt == ifid_rs || idex_rt == ifid_rt))? 1 : 0;

endmodule

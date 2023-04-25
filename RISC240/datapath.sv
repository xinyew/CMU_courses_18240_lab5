/*
 * File: datapath.v
 * Created: 4/5/1998
 * Modules contained: datapath
 *
 * Changelog:
 * 23 Oct 2009: Separated paths.v into datapath.v and controlpath.v
 * 17 Nov 2009: Minor updates to facilitate synthesis (mcbender)
 * 13 Oct 2010: Updated always to always_comb and always_ff.Renamed to.sv(abeera)
 * 17 Oct 2010: Updated to use enums instead of define's (iclanton)
 * 24 Oct 2010: Updated to use stuct (abeera)
 * 9  Nov 2010: Slightly modified variable names (abeera)
 * 25 Apr 2013: Changed newMDR to tri (mromanko)
 * 8  Mar 2019: Changed to fit RISC240 spec (pbannai)
 * 4  Nov 2019: Changed MDR to fit Altera IP block (mgcai)
 */

`include "constants.sv"

/*
 * module datapath
 *
 * This is the datapath for the RISC240.  Modules are instantiated and
 * connected.
 */
module datapath (
   output [15:0] ir,
   output [3:0]  condCodes,
   output [15:0] aluSrcA,
   output [15:0] aluSrcB,
   output [127:0] viewReg, //register for viewing in debugging
   output [15:0] aluResult,
   output [15:0] pc,
   output [15:0] memAddr,
   output [15:0] MDRout,  // output of datapath just for viewing
   inout  [15:0] dataBus,
   output [2:0]  selRD,
   output [2:0]  selRS1,
   output [2:0]  selRS2,
   input controlPts  cPts,
   input logic  add32Sel,
   input         clock,
   input         reset_L);

   logic [15:0] regRS1, regRS2;
   logic [15:0] memOut;
   logic [14:0] marOut;
   logic [3:0]  newCC;
   logic loadReg_L, loadPC_L, loadMDR_L, writeMD_L, loadMAR_L, loadIR_L;
   tri   [15:0] newMDR;

   logic [2:0] rs1MuxOut, rs2MuxOut, rdMuxOut;
   logic [3:0] CCMuxOut;
   logic [15:0] aluResultTmp, aluResultAdd32;
   logic [3:0] add32CC;

   // Assign wires
   assign loadMDR_L = writeMD_L & cPts.re_L;
   assign selRD  = ir[8:6];
   assign selRS1 = ir[5:3];
   assign selRS2 = ir[2:0];

   assign memAddr = {marOut, 1'b0};

   // Instantiate the modules that we need:
   reg_file rfile(
           .outRS1(regRS1),
           .outRS2(regRS2),
           .outView(viewReg),
           .in(aluResult),
           .selRD(rdMuxOut),
           .selRS1(rs1MuxOut),
           .selRS2(rs2MuxOut),
           .clock,
           .reset_L,
           .load_L(loadReg_L));

   tridrive #(.WIDTH(16)) a(.data(aluResult), .bus(newMDR), .en_L(writeMD_L)),
                          b(.data(dataBus), .bus(newMDR), .en_L(cPts.re_L)),
                          c(.data(MDRout), .bus(dataBus), .en_L(cPts.we_L));

   aluMux #(.WIDTH(16)) MuxA(.inA(regRS1),
                             .inB(pc),
                             .inC(MDRout),
                             .out(aluSrcA),
                             .sel(cPts.srcA)),
                        MuxB(.inA(regRS2),
                             .inB(pc),
                             .inC(MDRout),
                             .out(aluSrcB),
                             .sel(cPts.srcB));

   alu alu_dp(.out(aluResultTmp), .condCodes(newCC), .inA(aluSrcA), .inB(aluSrcB),
              .opcode(cPts.alu_op));

   logic [7:0] dest_out;
   decoder #(8) reg_load_decoder(.I(cPts.dest),
                                 .en(1'b1),
                                 .D(dest_out));

   assign {loadIR_L, loadMAR_L, writeMD_L, loadPC_L, loadReg_L} = dest_out[4:0];

   register #(.WIDTH(16)) memDataReg(.out(MDRout), .in(newMDR), .load_L(loadMDR_L),
                                     .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(16)) pcReg(     .out(pc), .in(aluResult), .load_L(loadPC_L),
                                     .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(15)) memAddrReg(.out(marOut), .in(aluResult[15:1]), .load_L(loadMAR_L),
                                     .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(16)) instrReg(  .out(ir), .in(aluResult), .load_L(loadIR_L),
                                     .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(4)) condCodeReg(.out(condCodes), .in(CCMuxOut), .load_L(cPts.lcc_L),
                                     .clock(clock), .reset_L(reset_L));

   mux2to1 #(.WIDTH(3)) rs1Mux(.out(rs1MuxOut), .inA(selRS1), 
                                .inB(selRS1 + 3'b1), .sel(add32Sel));
   mux2to1 #(.WIDTH(3)) rs2Mux(.out(rs2MuxOut), .inA(selRS2), 
                                .inB(selRS2 + 3'b1), .sel(add32Sel));
   mux2to1 #(.WIDTH(3)) rdMux(.out(rdMuxOut), .inA(selRD), 
                                .inB(selRD + 3'b1), .sel(add32Sel));
   
   mux2to1 #(.WIDTH(4)) CCMux(.out(CCMuxOut), .inA(newCC),
                              .inB(add32CC), .sel(add32Sel));
   add32Adder fA(.out(aluResultAdd32), .condCodes(add32CC),
                 .inA(aluResultTmp), .inB(condCodes[2]));   

   mux2to1 #(.WIDTH(16)) aluOutMux(.out(aluResult), .inA(aluResultTmp), 
                                   .inB(aluResultAdd32), .sel(add32Sel));

endmodule

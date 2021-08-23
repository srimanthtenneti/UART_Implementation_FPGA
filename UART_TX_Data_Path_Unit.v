module Data_Path #(parameter WORD_SIZE = 8 , SIZE_BIT_COUNT = 3 , ALL_ONES = {(WORD_SIZE+1){1'b1}})(
  input CLOCK,
  input RESET,
  input [WORD_SIZE-1 : 0] DATA_BUS,
  input LOAD_XMT_DR,
  input LOAD_XMT_SHFTREG,
  input START,
  input SHIFT,
  input CLEAR,
  
  output SERIAL_OUT,
  output BC_LT_BCMAX
);
  reg [WORD_SIZE - 1 : 0] XMT_DATAREG;
  reg [WORD_SIZE : 0] XMT_SHFTREG;
  
  reg [SIZE_BIT_COUNT : 0] BIT_COUNT; 
  
  assign SERIAL_OUT = XMT_SHFTREG[0];
  assign BC_LT_BCMAX = (BIT_COUNT < WORD_SIZE + 1);
  
  always @ (posedge CLOCK , negedge RESET)
    begin
      if (~RESET)
        begin
          XMT_SHFTREG <= ALL_ONES;
          BIT_COUNT <= 0;
        end
      
      else
        begin
          if (LOAD_XMT_DR == 1)
            XMT_DATAREG <= DATA_BUS;
          if (LOAD_XMT_SHFTREG == 1)
            XMT_SHFTREG <= {XMT_DATAREG , 1'b1};
          if (START == 1)
            XMT_SHFTREG[0] <= 0;
          if (CLEAR == 1)
            BIT_COUNT <= 0;
          if (SHIFT == 1)
            begin
              XMT_SHFTREG <= {1'b1 , XMT_SHFTREG[WORD_SIZE : 1]};
              BIT_COUNT <= BIT_COUNT + 1;
            end
        end
    end
   
endmodule
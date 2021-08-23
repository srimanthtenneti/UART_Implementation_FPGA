module UART_TX #(parameter WORD_SIZE = 8)(
  input CLOCK,
  input RESET,
  input [WORD_SIZE - 1 : 0] DATA_BUS,
  input LOAD_XMT_DATAREG,
  input BYTE_READY,
  input T_BYTE,
  
  output SERIAL_OUT
);
  
  // Control Unit
  
  Control_Unit unit0(
    .CLOCK(CLOCK),
    .RESET(RESET),
    .BC_LT_BCMAX(BC_LT_BCMAX),
    .T_BYTE(T_BYTE),
    .BYTE_READY(BYTE_READY),
    .LOAD_XMT_DATAREG(LOAD_XMT_DATAREG),
    .LOAD_XMT_SHFTREG(LOAD_XMT_SHFTREG),
    .CLEAR(CLEAR),
    .SHIFT(SHIFT),
    .START(START),
    .LOAD_XMT_DR(LOAD_XMT_DR)
  );
  
  Data_Path unit1(
    .CLOCK(CLOCK),
    .RESET(RESET),
    .DATA_BUS(DATA_BUS),
    .CLEAR(CLEAR),
    .SHIFT(SHIFT),
    .START(START),
    .LOAD_XMT_SHFTREG(LOAD_XMT_SHFTREG),
    .LOAD_XMT_DR(LOAD_XMT_DR),
    .BC_LT_BCMAX(BC_LT_BCMAX),
    .SERIAL_OUT(SERIAL_OUT)
  );
   
endmodule
  
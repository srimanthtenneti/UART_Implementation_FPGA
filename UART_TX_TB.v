module UART_TX_TB();
  parameter WORD_SIZE = 8;
  reg CLOCK;
  reg RESET;
  reg [WORD_SIZE - 1 : 0] DATA_BUS;
  reg LOAD_XMT_DATAREG;
  reg BYTE_READY;
  reg T_BYTE;
  wire SERIAL_OUT;
  
  integer i;
  
  initial 
    begin
       CLOCK = 0;
       RESET = 0; // ON
       DATA_BUS = {(WORD_SIZE - 1){1'b0}};
       LOAD_XMT_DATAREG = 0;
       BYTE_READY = 0;
       T_BYTE = 0;
       forever #1 CLOCK = ~CLOCK;
    end
  
  UART_TX tx0(
    .CLOCK(CLOCK),
    .RESET(RESET),
    .DATA_BUS(DATA_BUS),
    .LOAD_XMT_DATAREG(LOAD_XMT_DATAREG),
    .BYTE_READY(BYTE_READY),
    .T_BYTE(T_BYTE),
    .SERIAL_OUT(SERIAL_OUT)
  );
  
  task TX(input [7:0] data);
    begin
      #1 DATA_BUS = data;
      #1 LOAD_XMT_DATAREG = 1;
      #1 LOAD_XMT_DATAREG = 0;
      #1 BYTE_READY = 1;
      #1 BYTE_READY = 0;
      #1 T_BYTE = 1;
      #1 T_BYTE = 0;
    end
  endtask
  
  initial
    begin
       // Uncomment for EDA Playground
      //$dumpfile("Dump.vcd");
      //$dumpvars(0);
      #1RESET = 1;
      for (i = 0 ; i < 256 ; i++)
        begin
          TX(i);
        end
      #1000 $finish;
    end
endmodule
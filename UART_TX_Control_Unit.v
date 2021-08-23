module Control_Unit(
  input CLOCK,  // Master Clock
  input RESET, // Resets the Control Unit
  input BC_LT_BCMAX, // Indicates the Status of the Counter
  input T_BYTE,   // Asserts the Start Signal
  input BYTE_READY, // Asserts Load_XMT_shftreg in state idle
  input LOAD_XMT_DATAREG, // Asserts Load_XMT_DR in state idle
  output CLEAR,
  output SHIFT,
  output START,
  output LOAD_XMT_SHFTREG,
  output LOAD_XMT_DR
);
  
  // Device Configuration parameters
  
  parameter one_hot_count = 3;
  parameter state_count = one_hot_count;
  parameter size_bit_count = 3;
  
  // Device state Parameters
  
  parameter IDLE = 3'b001;
  parameter WAITING = 3'b010;
  parameter SENDING = 3'b100;
  parameter ALL_ONES = 9'b1111_1111;
  
  // Temporary registers
  
  reg CLEAR_ , SHIFT_ , START_ , LOAD_ , LOAD_XMT_SHFTREG_ , LOAD_XMT_DR_;
  
  // State Registers
  reg [state_count-1 : 0] state , next_state;
  
  // Current State Logic
  always @ (posedge CLOCK , negedge RESET)
    begin
      if(~RESET)
        next_state <= IDLE;
      else
        state <= next_state; 
    end
  
  // Output and Next State Logic
  always @ (state , LOAD_XMT_DATAREG , BYTE_READY , T_BYTE, BC_LT_BCMAX)
    begin
      LOAD_XMT_DR_ = 0;
      LOAD_XMT_SHFTREG_ = 0;
      START_ = 0;
      SHIFT_ = 0;
      CLEAR_ = 0;
      next_state = IDLE;
      case(state)
        IDLE : begin
          if(LOAD_XMT_DATAREG == 1)
            begin
               LOAD_XMT_DR_ = 1;
               next_state = IDLE;
            end
          else
            if (BYTE_READY == 1)
              begin
                 LOAD_XMT_SHFTREG_ = 1;
                 next_state = WAITING;
              end
        end
        WAITING : begin
          if (T_BYTE == 1)
            begin
               START_ = 1;
               next_state = SENDING;
            end
          else
            next_state = WAITING;
        end
        SENDING : begin
          if (BC_LT_BCMAX)
            begin
               SHIFT_ = 1;
               next_state = SENDING;
            end
          else
            begin
               CLEAR_ = 1;
               next_state = IDLE;
            end
        end
        default : next_state = IDLE;
      endcase
    end
   assign START = START_;
   assign SHIFT = SHIFT_;
   assign CLEAR = CLEAR_;
   assign LOAD_XMT_SHFTREG = LOAD_XMT_SHFTREG_;
   assign LOAD_XMT_DR = LOAD_XMT_DR_;
endmodule
  
  
  
  
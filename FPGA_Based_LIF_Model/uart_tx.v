`timescale 1ns/1ps
// Filename: uart_tx.v
module uart_tx #(
    parameter integer CLOCK_FREQ = 12_000_000, // board clock
    parameter integer BAUD_RATE  = 115200      // desired UART baud
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] data_in,
    input  wire       send,
    output reg        tx,
    output reg        busy
);

  // Baud-tick generator
  localparam integer BAUD_TICK = CLOCK_FREQ / BAUD_RATE;
  localparam integer CNT_WIDTH = $clog2(BAUD_TICK);

  reg [CNT_WIDTH-1:0] baud_cnt;
  reg                 bit_tick;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      baud_cnt <= 0;
      bit_tick <= 1'b0;
    end else if (busy) begin
      if (baud_cnt == BAUD_TICK-1) begin
        baud_cnt <= 0;
        bit_tick <= 1'b1;
      end else begin
        baud_cnt <= baud_cnt + 1;
        bit_tick <= 1'b0;
      end
    end else begin
      baud_cnt <= 0;
      bit_tick <= 1'b0;
    end
  end

  // Shift-register transmit
  reg [3:0]  bit_index;
  reg [9:0]  shift_reg;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tx         <= 1'b1;            // idle high
      busy       <= 1'b0;
      bit_index  <= 4'd0;
      shift_reg  <= 10'b1111111111;
    end else begin
      if (!busy && send) begin
        // load: { stop(1), data[7:0], start(0) }
        shift_reg <= {1'b1, data_in, 1'b0};
        busy      <= 1'b1;
        bit_index <= 4'd0;
      end else if (busy && bit_tick) begin
        tx <= shift_reg[bit_index];
        bit_index <= bit_index + 1;
        if (bit_index == 4'd9) begin
          busy <= 1'b0;
          tx   <= 1'b1;  // return to idle
        end
      end
    end
  end

endmodule

module SensorSynchronizer (
    input clk,
    input async_in,                                                                // Asynchronous input signal
    output reg sync_out                                                         // Synchronized output signal
);

    reg intermediate;

    always @(posedge clk) begin
        intermediate <= async_in;                                           // First stage of synchronization
        sync_out <= intermediate;                                        // Second stage of synchronization
    end

endmodule
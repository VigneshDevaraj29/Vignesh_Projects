module KeypadScanner (
    input clk,
    input reset,
    input [3:0] row,
    output reg [2:0] col,
    output reg [3:0] key_value,
    output reg key_valid
);

    reg [1:0] col_index;
    reg [19:0] debounce_counter;
    reg key_stable;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            col_index <= 0;
            col <= 3'b111;
            key_value <= 4'd0;
            key_valid <= 0;
            debounce_counter <= 0;
            key_stable <= 0;
        end else begin
            // Scanning logic
            col <= ~(3'b001 << col_index);
            col_index <= (col_index == 2) ? 0 : col_index + 1;

            if (row != 4'b1111) begin
                debounce_counter <= debounce_counter + 1;
                if (debounce_counter > 100000) begin
                    key_stable <= 1;
                end
            end else begin
                debounce_counter <= 0;
                key_stable <= 0;
            end

            if (key_stable) begin
                key_valid <= 1;
                case ({row, col_index})
                    {4'b1110, 2'd0}: key_value <= 4'd1;
                    {4'b1101, 2'd0}: key_value <= 4'd4;
                    {4'b1011, 2'd0}: key_value <= 4'd7;
                    {4'b0111, 2'd0}: key_value <= 4'd0;

                    {4'b1110, 2'd1}: key_value <= 4'd2;
                    {4'b1101, 2'd1}: key_value <= 4'd5;
                    {4'b1011, 2'd1}: key_value <= 4'd8;
                    {4'b0111, 2'd1}: key_value <= 4'd10; // * key

                    {4'b1110, 2'd2}: key_value <= 4'd3;
                    {4'b1101, 2'd2}: key_value <= 4'd6;
                    {4'b1011, 2'd2}: key_value <= 4'd9;
                    {4'b0111, 2'd2}: key_value <= 4'd11; // # key

                    default: key_value <= 4'd15;
                endcase
            end else begin
                key_valid <= 0;
            end
        end
    end
endmodule
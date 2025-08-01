module PasswordInput (
    input clk,
    input reset,
    input key_valid,
    input [3:0] key_value,
    output reg [10:0] entered_password,
    output reg password_ready
);

    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            entered_password <= 11'd0;
            count <= 0;
            password_ready <= 0;
        end else if (key_valid && key_value < 10) begin
            entered_password <= {entered_password[6:0], key_value};
            count <= count + 1;
            if (count == 3) begin
                password_ready <= 1;
                count <= 0;
            end
        end else begin
            password_ready <= 0;
        end
    end
endmodule
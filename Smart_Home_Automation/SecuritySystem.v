module SecuritySystem (
    input clk,
    input reset,
    input [10:0] entered_password,
    input [10:0] stored_password,
    input password_ready,
    input change_mode,
    input room_door,
    input room_window,
    input garage_door,
    input fire,

    output reg security_active,
    output reg door_alarm,
    output reg window_alarm,
    output reg garage_alarm,
    output reg fire_alarm,
    output reg buzzer
);

    reg [1:0] attempt_count;
    reg [31:0] lockout_timer;
    reg locked_out;
    reg [10:0] password_reg;

    parameter LOCKOUT_DURATION = 30_000_000; // 30s at 1MHz clk

    // Track password
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            password_reg <= stored_password;
        end else if (change_mode && password_ready && !locked_out) begin
            password_reg <= entered_password;  // Change password
        end
    end

    // Lockout timer logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lockout_timer <= 0;
            locked_out <= 0;
            attempt_count <= 0;
        end else if (locked_out) begin
            if (lockout_timer < LOCKOUT_DURATION)
                lockout_timer <= lockout_timer + 1;
            else begin
                locked_out <= 0;
                attempt_count <= 0;
                lockout_timer <= 0;
            end
        end else if (password_ready) begin
            if (entered_password == password_reg) begin
                attempt_count <= 0;
                locked_out <= 0;
            end else begin
                attempt_count <= attempt_count + 1;
                if (attempt_count == 2)
                    locked_out <= 1;
            end
        end
    end

    // Buzzer output logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            buzzer <= 0;
        else if (password_ready && entered_password != password_reg)
            buzzer <= 1;
        else
            buzzer <= 0;
    end

    // Main system functionality
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            security_active <= 0;
            door_alarm <= 0;
            window_alarm <= 0;
            garage_alarm <= 0;
            fire_alarm <= 0;
        end else if (!locked_out && password_ready && entered_password == password_reg) begin
            security_active <= 1;
            door_alarm <= room_door;
            window_alarm <= room_window;
            garage_alarm <= garage_door;
            fire_alarm <= fire;
        end else if (locked_out) begin
            security_active <= 0;
            door_alarm <= 0;
            window_alarm <= 0;
            garage_alarm <= 0;
            fire_alarm <= 0;
        end
    end

endmodule

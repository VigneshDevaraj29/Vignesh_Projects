module SHA_Top_Module (
    // Inputs:
    input clk,
    input reset,
    input [10:0] stored_password,
    input room_door,
    input room_window,
    input garage_door,
    input smoke_detected,
    input motion_sens,
    input [6:0] temp_sens,
    input [8:0] lume_sens,
    input [3:0] row,              // Keypad row inputs
    output [2:0] col,             // Keypad column outputs
    input change_mode,           // New input to trigger password change

    // Outputs:
    output security_active,
    output door_alarm,
    output window_alarm,
    output garage_alarm,
    output fire_alarm,
    output heater,
    output ac,
    output bright_light,
    output dim_light,
    output normal_light,
    output buzzer                // Buzzer signal on wrong password
);

    wire sync_room_door, sync_room_window, sync_garage_door, sync_smoke_detected, sync_motion_sens;
    wire [10:0] entered_password;
    wire password_ready;
    wire [3:0] key_value;
    wire key_valid;

    SensorSynchronizer sync_door (.clk(clk), .async_in(room_door), .sync_out(sync_room_door));
    SensorSynchronizer sync_window (.clk(clk), .async_in(room_window), .sync_out(sync_room_window));
    SensorSynchronizer sync_garage (.clk(clk), .async_in(garage_door), .sync_out(sync_garage_door));
    SensorSynchronizer sync_smoke (.clk(clk), .async_in(smoke_detected), .sync_out(sync_smoke_detected));
    SensorSynchronizer sync_motion (.clk(clk), .async_in(motion_sens), .sync_out(sync_motion_sens));

    KeypadScanner keypad_inst (
        .clk(clk),
        .reset(reset),
        .row(row),
        .col(col),
        .key_value(key_value),
        .key_valid(key_valid)
    );

    PasswordInput pw_input (
        .clk(clk),
        .reset(reset),
        .key_valid(key_valid),
        .key_value(key_value),
        .entered_password(entered_password),
        .password_ready(password_ready)
    );

    SecuritySystem security_inst (
        .clk(clk),
        .reset(reset),
        .entered_password(entered_password),
        .stored_password(stored_password),
        .password_ready(password_ready),
        .change_mode(change_mode),
        .room_door(sync_room_door),
        .room_window(sync_room_window),
        .garage_door(sync_garage_door),
        .fire(sync_smoke_detected),
        .security_active(security_active),
        .door_alarm(door_alarm),
        .window_alarm(window_alarm),
        .garage_alarm(garage_alarm),
        .fire_alarm(fire_alarm),
        .buzzer(buzzer)
    );

    ComfortControl comfort_inst (
        .clk(clk),
        .reset(reset),
        .temp_sens(temp_sens),
        .lume_sens(lume_sens),
        .motion_sens(sync_motion_sens),
        .heater(heater),
        .ac(ac),
        .bright_light(bright_light),
        .dim_light(dim_light),
        .normal_light(normal_light)
    );

endmodule

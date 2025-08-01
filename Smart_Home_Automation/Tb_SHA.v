`timescale 1ns/1ps

module tb_SHA_Top_Module;

    reg clk, reset;
    reg [10:0] stored_password = 11'b10101010101; // Default password
    reg room_door, room_window, garage_door, smoke_detected, motion_sens;
    reg [6:0] temp_sens;
    reg [8:0] lume_sens;
    reg [3:0] row;
    wire [2:0] col;
    reg change_mode;

    wire security_active, door_alarm, window_alarm, garage_alarm, fire_alarm;
    wire heater, ac, bright_light, dim_light, normal_light;
    wire buzzer;

    SHA_Top_Module uut (
        .clk(clk),
        .reset(reset),
        .stored_password(stored_password),
        .room_door(room_door),
        .room_window(room_window),
        .garage_door(garage_door),
        .smoke_detected(smoke_detected),
        .motion_sens(motion_sens),
        .temp_sens(temp_sens),
        .lume_sens(lume_sens),
        .row(row),
        .col(col),
        .change_mode(change_mode),
        .security_active(security_active),
        .door_alarm(door_alarm),
        .window_alarm(window_alarm),
        .garage_alarm(garage_alarm),
        .fire_alarm(fire_alarm),
        .heater(heater),
        .ac(ac),
        .bright_light(bright_light),
        .dim_light(dim_light),
        .normal_light(normal_light),
        .buzzer(buzzer)
    );

    always #500 clk = ~clk;

    task press_key(input [3:0] key);
        begin
            row = key;
            #2000;
            row = 4'b0000;
            #2000;
        end
    endtask

    initial begin
        $display("========== Starting Smart Home Automation Testbench ==========");
        $monitor("[%0t] security_active=%b | buzzer=%b | door_alarm=%b | window_alarm=%b | garage_alarm=%b | fire_alarm=%b | heater=%b | ac=%b | light: bright=%b dim=%b normal=%b", 
                 $time, security_active, buzzer, door_alarm, window_alarm, garage_alarm, fire_alarm, heater, ac, bright_light, dim_light, normal_light);

        clk = 0;
        reset = 1;
        row = 4'b0000;
        room_door = 0;
        room_window = 0;
        garage_door = 0;
        smoke_detected = 0;
        motion_sens = 0;
        temp_sens = 7'd25;
        lume_sens = 9'd150;
        change_mode = 0;

        #2000;
        reset = 0;

        // === Test 1: Wrong password 3 times ===
        $display("\n=== Test 1: Enter wrong password 3 times ===");
        repeat (3) begin
            press_key(4'b0001);
            press_key(4'b0010);
            press_key(4'b0011);
            press_key(4'b0100);
            press_key(4'b0101);
            press_key(4'b0110);
            press_key(4'b0111);
            press_key(4'b1000);
            press_key(4'b1001);
            press_key(4'b1010);
            $display("[%0t] Entered wrong password attempt", $time);
            #10000;
        end

        // === Test 2: Lockout period (should be ignored) ===
        $display("\n=== Test 2: Attempt input during lockout===");
        press_key(4'b0001);
        press_key(4'b0010);
        #10000;

        // === Test 3: Wait lockout to clear and enter correct password ===
        $display("\n=== Test 3: Wait 30s lockout and enter correct password ===");
        #30_000_000;
        press_key(4'b0001);
        press_key(4'b0010);
        press_key(4'b0011);
        press_key(4'b0100);
        press_key(4'b0101);
        press_key(4'b0110);
        press_key(4'b0111);
        press_key(4'b1000);
        press_key(4'b1001);
        press_key(4'b1010);
        $display("[%0t] Entered correct password", $time);
        #10000;

        // === Test 4: Trigger alarms ===
        $display("\n=== Test 4: Trigger all alarms ===");
        room_door = 1;
        room_window = 1;
        garage_door = 1;
        smoke_detected = 1;
        #10000;

        // === Test 5: Trigger comfort controls (heater, light) ===
        $display("\n=== Test 5: Comfort control - heater ON, dim light ===");
        motion_sens = 1;
        temp_sens = 7'd10;
        lume_sens = 9'd500;
        #10000;

        $display("\n=== Test 5 (cont'd): Comfort control - AC ON, bright light ===");
        temp_sens = 7'd35;
        lume_sens = 9'd50;
        #10000;

        // === Test 6: Change password ===
        $display("\n=== Test 6: Change password ===");
        change_mode = 1;
        press_key(4'b1111);
        press_key(4'b0000);
        press_key(4'b0001);
        press_key(4'b0010);
        press_key(4'b0011);
        press_key(4'b0100);
        press_key(4'b0101);
        press_key(4'b0110);
        press_key(4'b0111);
        press_key(4'b1000);
        $display("[%0t] New password entered", $time);
        change_mode = 0;
        #10000;

        // === Test 7: Login with new password ===
        $display("\n=== Test 7: Login with new password ===");
        press_key(4'b1111);
        press_key(4'b0000);
        press_key(4'b0001);
        press_key(4'b0010);
        press_key(4'b0011);
        press_key(4'b0100);
        press_key(4'b0101);
        press_key(4'b0110);
        press_key(4'b0111);
        press_key(4'b1000);
        $display("[%0t] Logged in using changed password", $time);
        #10000;

        $display("\n========== Testbench Completed ==========");
        $finish;
    end

endmodule

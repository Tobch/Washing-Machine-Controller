`timescale 1ns / 1ps

module tb_washing_machine_controller;

    // Parameters
    reg clk;
    reg reset;
    reg power_button;
    reg start_button;
    reg [1:0] cycle_select;
    reg [1:0] water_level_select;
    reg [1:0] temp_select;
    reg [1:0] spin_speed_select;
    reg lid_closed;
    reg water_full;
    reg load_balanced;
    reg delay_start;

    // Outputs
    wire motor_on;
    wire water_pump_on;
    wire alarm;
    wire door_locked;
    wire power_led;
    wire cycle_led;
    wire [7:0] timer;
    wire end_of_cycle_alarm;

    // Instantiate the washing machine controller
    washing_machine_controller uut (
        .clk(clk),
        .reset(reset),
        .power_button(power_button),
        .start_button(start_button),
        .cycle_select(cycle_select),
        .water_level_select(water_level_select),
        .temp_select(temp_select),
        .spin_speed_select(spin_speed_select),
        .lid_closed(lid_closed),
        .water_full(water_full),
        .load_balanced(load_balanced),
        .delay_start(delay_start),
        .motor_on(motor_on),
        .water_pump_on(water_pump_on),
        .alarm(alarm),
        .door_locked(door_locked),
        .power_led(power_led),
        .cycle_led(cycle_led),
        .timer(timer),
        .end_of_cycle_alarm(end_of_cycle_alarm)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Randomized Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        power_button = 0;
        start_button = 0;
        cycle_select = 2'b01; // Default to Normal Wash
        water_level_select = 2'b01; // Medium
        temp_select = 2'b01; // Warm
        spin_speed_select = 2'b01; // Medium
        lid_closed = 0;
        water_full = 0;
        load_balanced = 0;
        delay_start = 0;

        // Reset the controller
        #10 reset = 0;

        // Power on the washing machine with some random delays
        random_power_on();

        // Randomized cycle start
        random_start_button();

        // Simulate water filling, and randomize water_full signal
        #10 water_full = 1;
        #10 water_full = 0;

        // Random delays between washing phases
        random_phase_delay();

        // Randomly change states
        random_rinse_cycle();

        // Randomly end cycle and check alarm
        random_end_of_cycle();

        // Final state check
        if (end_of_cycle_alarm !== 1) begin
            $display("Test failed: End of cycle alarm not activated.");
        end else begin
            $display("Test passed: End of cycle alarm activated.");
        end

        // Finish simulation
        $finish;
    end

    // Random power on function
    task random_power_on;
        begin
            #($random % 50); // Wait for a random time between 0 and 50 ns
            power_button = 1; // Press power button
            #10 power_button = 0;
        end
    endtask

    // Random start button press
    task random_start_button;
        begin
            #($random % 100); // Random delay before pressing start
            start_button = 1; // Press start button
            #10 start_button = 0;
        end
    endtask

    // Random delay for washing, rinse, spin, etc.
    task random_phase_delay;
        begin
            #($random % 50 + 20); // Random delay between 20ns to 70ns for different phases
        end
    endtask

    // Random rinse cycle simulation
    task random_rinse_cycle;
        begin
            #($random % 50 + 50); // Random rinse time, between 50ns to 100ns
        end
    endtask

    // Random end of cycle behavior
    task random_end_of_cycle;
        begin
            #($random % 30 + 10); // Random time for spin cycle to end
        end
    endtask

    // Assertions for verification
    initial begin
        // Wait for the simulation to start
        @(posedge clk); // Wait for the first clock edge
        forever begin
            // Assert that the motor is on during washing
            if (uut.current_state == uut.WASHING) begin
                if (motor_on !== 1) begin
                    $fatal("Error: Motor should be ON during washing.");
                end
            end

            // Assert that water pump is on while filling
            if (uut.current_state == uut.FILLING) begin
                if (water_pump_on !== 1) begin
                    $fatal("Error: Water pump should be ON during filling.");
                end
            end

            // Assert door is locked when washing
            if (uut.current_state == uut.WASHING) begin
                if (door_locked !== 1) begin
                    $fatal("Error: Door should be locked during washing.");
                end
            end

            // Assert alarm when lid is open
            lid_closed = 0; // Simulate lid open
            #10;
            if (alarm !== 1) begin
                $fatal("Error: Alarm should be ON when lid is open.");
            end
            lid_closed = 1; // Close lid

            // Assert end of cycle alarm is triggered at end of washing
            if (uut.current_state == uut.END_CYCLE) begin
                if (end_of_cycle_alarm !== 1) begin
                    $fatal("Error: End of cycle alarm should be activated.");
                end
            end

            // Wait for the next clock cycle
            @(posedge clk);
        end
    end

endmodule

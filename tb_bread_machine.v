`timescale 1ms/1ms

module tb_bread_machine;

localparam CLK_PERIOD = 1000; // 1000ms = 1s
localparam HALF_CLK_PERIOD = CLK_PERIOD / 2;

reg rst;
reg clk;
reg start_button;
wire bell;
wire heating_element;
wire paddle_motor;

reg heating_element_prev;
reg paddle_motor_prev;

bread_machine dut(
    rst,
    clk,
    start_button,
    bell,
    heating_element,
    paddle_motor
);


always #(HALF_CLK_PERIOD) clk = ~clk; // Generate 1Hz clock signal

integer i;

initial begin

    $display("t=%5ds | Reset: START", $time / 1000);

    clk = 1'b1;
    rst = 1'b1;
    start_button = 1'b0;

    @(negedge clk); @(negedge clk); // Keep rst high for at least one clock cycle

    rst = 1'b0;

    $display("t=%5ds | Reset: DONE", $time / 1000);

    for (i = 0; i < 10; i = i + 1) begin // The user waits for some time.
        @(negedge clk);
    end

    start_button = 1'b1; // The user presses the start button.
    @(negedge clk);
    start_button = 1'b0;

    #(4 * 60 * 60 * 1000); // The appliance stays on for 4 hours.

    $finish(); // After 4 hours, the simulation is stopped.

end


// This always construct displays messages whenever the state of the appliance is modified.
always @(posedge clk) begin
    if (start_button) $display("t=%5ds | <- Start button pressed", $time / 1000);
    if (heating_element_prev !== heating_element) begin
        if (heating_element == 1'b1)
            $display("t=%5ds | Heat:  ON", $time / 1000);
        else if (heating_element == 1'b0)
            $display("t=%5ds | Heat:  OFF", $time / 1000);
    end
    if (paddle_motor_prev !== paddle_motor) begin
        if (paddle_motor == 1'b1)
            $display("t=%5ds | Motor: ON", $time / 1000);
        else if (paddle_motor == 1'b0)
            $display("t=%5ds | Motor: OFF", $time / 1000);
    end
    if (bell) $display("t=%5ds | Bell:  DING!", $time / 1000);
    paddle_motor_prev = paddle_motor;
    heating_element_prev = heating_element;
end


endmodule

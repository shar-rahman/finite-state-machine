`timescale 1ns/1ns

module bread_machine(
    rst,
    clk,
    start_button,
    bell,
    heating_element,
    paddle_motor
    );

input rst;
input clk;
input start_button;

output bell;
output heating_element;
output paddle_motor;


localparam FREQ = 1; // 1Hz clock expected
localparam CYCLES_15MIN = FREQ * 15 * 60;
localparam CYCLES_2HR = FREQ * 2 * 60 * 60;
localparam CYCLES_25MIN = FREQ * 25 * 60;


reg [15:0] timer, timer_next;

wire [1:0] timer_select;
wire timer_elapsed;


assign timer_elapsed = (timer == 16'b0);

always @(*) begin
    case (timer_select)
        2'b00: timer_next = timer - 16'b1;
        2'b01: timer_next = CYCLES_15MIN;
        2'b10: timer_next = CYCLES_2HR;
        2'b11: timer_next = CYCLES_25MIN;
    endcase
end

always @(posedge clk) begin
    timer <= timer_next;
end

control control0(
    .rst(rst),
    .clk(clk),
    .start_button(start_button),
    .timer_elapsed(timer_elapsed),
    .timer_select(timer_select),
    .bell(bell),
    .heating_element(heating_element),
    .paddle_motor(paddle_motor)
);

endmodule

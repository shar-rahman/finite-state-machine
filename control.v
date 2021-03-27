`timescale 1ns/1ns

module control(
    rst,
    clk,
    start_button,
    timer_elapsed,
    timer_select,
    bell,
    heating_element,
    paddle_motor
    );

input rst;
input clk;
input start_button;
input timer_elapsed;

output reg [1:0] timer_select;
output reg bell;
output reg heating_element;
output reg paddle_motor;

localparam state_0 = 2'd0;
localparam state_1 = 2'd1;
localparam state_2 = 2'd2;
localparam state_3 = 2'd3;

reg [1:0] state, next_state;

always @(posedge rst or posedge clk) begin
    if(rst) begin
        state = state_0;
    end else begin
        state = next_state;
    end
end

always @(*) begin
    next_state = state;
    timer_select = 2'b00;
    heating_element = 1'b0;
    paddle_motor = 1'b0;
    bell = 1'b0;

    case(state)
        state_0: begin
            if(start_button)  begin
                timer_select = 2'b01;
                next_state = state_1;
            end else begin
                next_state = state_0;
            end
            paddle_motor = 1'b0;
            heating_element = 1'b0;
        end

        state_1: begin
            if(timer_elapsed == 1) begin
                next_state = state_2;
                timer_select = 2'b10;
                
            end else begin
                next_state = state_1;
            end
            paddle_motor = 1'b1;
            heating_element = 1'b0;

        end

        state_2: begin
            if(timer_elapsed == 1) begin
                timer_select = 2'b11;
                next_state = state_3;
            end else begin
                next_state = state_2;
            end
            paddle_motor = 1'b0;
            heating_element = 1'b0;

        end
        
        state_3: begin
            if(timer_elapsed == 1) begin
                bell = 1'b1;
                timer_select = 2'b00;
                next_state = state_0;
            end else begin
                next_state = state_3;
            end
            heating_element = 1'b1;
        end
    endcase

end

endmodule


`timescale 1ns/1ps

module counter_4bit(
    input logic clock,
    input logic reset,
    input logic enable,
    output logic [3:0] count
);

always_ff @(posedge clock)
begin
    if (reset)
        count <= 4'b0000;
    else if (enable)
        count <= count + 1'b1;
end

endmodule


`timescale 1ns/1ps

module counter_4bit_faulty(
    input logic clock,
    input logic reset,
    input logic enable,
    output logic [3:0] count
);

logic [3:0] internal_count;

always_ff @(posedge clock)
begin
    if (reset)
        internal_count <= 4'b0000;
    else if (enable)
        internal_count <= internal_count + 1'b1;
end

always_comb
begin
    count = internal_count;
    count[0] = 1'b0;
end

endmodule

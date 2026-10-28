`timescale 1ns/1ps

module tb_atpg_fault;

reg clock;
reg reset;
reg enable;

wire [3:0] good_count;
wire [3:0] faulty_count;

integer i;
integer detected_patterns;

counter_4bit GOOD_DUT(
    .clock(clock),
    .reset(reset),
    .enable(enable),
    .count(good_count)
);

counter_4bit_faulty FAULTY_DUT(
    .clock(clock),
    .reset(reset),
    .enable(enable),
    .count(faulty_count)
);

initial clock = 0;

always #5 clock = ~clock;

initial begin
    reset = 1;
    enable = 0;
    detected_patterns = 0;

    $dumpfile("sim/atpg_fault.vcd");
    $dumpvars(0, tb_atpg_fault);

    repeat (2) @(negedge clock);

    reset = 0;
    enable = 1;

    $display("TIME  GOOD  FAULTY  RESULT");

    for (i = 0; i < 16; i = i + 1) begin
        @(posedge clock);
        #1;

        if (good_count !== faulty_count) begin
            detected_patterns = detected_patterns + 1;
            $display("%4t   %h     %h     FAULT DETECTED",
                     $time, good_count, faulty_count);
        end
        else begin
            $display("%4t   %h     %h     NOT DETECTED",
                     $time, good_count, faulty_count);
        end

        @(negedge clock);
    end

    $display("\nTOTAL DETECTING PATTERNS = %0d",
             detected_patterns);

    if (detected_patterns > 0)
        $display("ATPG RESULT: FAULT DETECTED");
    else
        $display("ATPG RESULT: FAULT NOT DETECTED");

    $finish;
end

endmodule
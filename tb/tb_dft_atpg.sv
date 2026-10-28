
`timescale 1ns/1ps

module tb_dft_atpg;

reg clock;
reg reset;
reg enable;
wire [3:0] count;

integer i;
integer errors;
reg [3:0] expected_count;

counter_4bit DUT(
    .clock(clock),
    .reset(reset),
    .enable(enable),
    .count(count)
);

initial
    clock = 0;

always
    #5 clock = ~clock;

task check_count;
begin
    #1;
    if (count !== expected_count)
    begin
        $display("FAIL: Expected=%h Actual=%h Time=%0t",
                 expected_count, count, $time);
        errors = errors + 1;
    end
    else
        $display("PASS: Count=%h Time=%0t", count, $time);
end
endtask

initial
begin
    reset = 1;
    enable = 0;
    errors = 0;
    expected_count = 0;

    $dumpfile("sim/dft_atpg.vcd");
    $dumpvars(0, tb_dft_atpg);

    @(posedge clock);
    #1;
    check_count();

    @(negedge clock);
    reset = 0;
    enable = 1;

    for (i = 0; i < 16; i = i + 1)
    begin
        @(posedge clock);
        expected_count = expected_count + 1'b1;
        check_count();
        @(negedge clock);
    end

    enable = 0;

    repeat (3)
    begin
        @(posedge clock);
        check_count();
        @(negedge clock);
    end

    reset = 1;
    enable = 0;
    expected_count = 0;

    @(posedge clock);
    check_count();

    $display("\nTOTAL ERRORS = %0d", errors);

    if (errors == 0)
        $display("TEST PASSED");
    else
        $display("TEST FAILED");

    $finish;
end

endmodule

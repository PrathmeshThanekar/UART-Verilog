`timescale 1ns / 1ps

module UART_TOP_tb;

    reg clk;
    reg rst;
    reg load;
    reg [7:0] data_tx;
    wire [7:0] data_rx;

    UART_TOP DUT (
        .clk     (clk),
        .rst     (rst),
        .load    (load),
        .data_tx (data_tx),
        .data_rx (data_rx)
    );

    always #5 clk = ~clk;
    initial begin
        clk     = 1'b0;
        rst     = 1'b0;
        load    = 1'b0;
        data_tx = 8'b0;
        #10;
        rst = 1'b1;
        #10;
        data_tx = 8'b10101010;
        #10;
        load = 1'b1;
        #10;
        load = 1'b0;
        #1200000;
        $finish;
    end
endmodule
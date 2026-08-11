`timescale 1ns / 1ps

module UART_TOP (
    input clk,
    input rst,
    input load,
    input [7:0] data_tx,
    output [7:0] data_rx
);

    wire tx_rx;

    Transmitter tr (
        .clk     (clk),
        .rst     (rst),
        .load    (load),
        .data_tx (data_tx),
        .tx      (tx_rx)
    );

    Receiver rc (
        .clk     (clk),
        .rst     (rst),
        .rx      (tx_rx),
        .data_rx (data_rx)
    );

endmodule
`timescale 1ns / 1ps

module Receiver (
    input clk,
    input rst,
    input rx,
    output reg [7:0] data_rx
);

parameter BAUD_COUNT = 100000000 / 9600;

localparam IDLE      = 2'd0;
localparam START_BIT = 2'd1;
localparam RECEIVE   = 2'd2;
localparam STOP_BIT  = 2'd3;

reg [1:0]  state;
reg [15:0] baud_tick;
reg [3:0]  bit_count;
reg [7:0]  shift_reg;

always @(posedge clk or negedge rst) begin

    if (!rst) begin

        state     <= IDLE;
        baud_tick <= 16'd0;
        bit_count <= 4'd0;
        shift_reg <= 8'd0;
        data_rx   <= 8'd0;

    end

    else begin

        case (state)

            // --------------------------------
            // IDLE
            // --------------------------------
            IDLE: begin

                baud_tick <= 16'd0;
                bit_count <= 4'd0;

                // Start bit detected
                if (rx == 1'b0) begin
                    state <= START_BIT;
                end

            end


            // --------------------------------
            // START BIT
            // Wait half baud period
            // --------------------------------
            START_BIT: begin

                if (baud_tick == (BAUD_COUNT / 2) - 1) begin

                    baud_tick <= 16'd0;

                    // Confirm start bit
                    if (rx == 1'b0) begin
                        state <= RECEIVE;
                    end

                    else begin
                        // False start
                        state <= IDLE;
                    end

                end

                else begin
                    baud_tick <= baud_tick + 1'b1;
                end

            end


            // --------------------------------
            // RECEIVE DATA
            // Sample every full baud period
            // --------------------------------
            RECEIVE: begin

                if (baud_tick == BAUD_COUNT - 1) begin

                    baud_tick <= 16'd0;

                    // Sample data bit at its CENTER
                    shift_reg <= {rx, shift_reg[7:1]};

                    if (bit_count == 4'd7) begin

                        // All 8 data bits received
                        bit_count <= 4'd0;
                        state <= STOP_BIT;

                    end

                    else begin

                        bit_count <= bit_count + 1'b1;

                    end

                end

                else begin

                    baud_tick <= baud_tick + 1'b1;
                end

            end


            // --------------------------------
            // STOP BIT
            // Wait one baud period
            // --------------------------------
            STOP_BIT: begin

                if (baud_tick == BAUD_COUNT - 1) begin

                    baud_tick <= 16'd0;

                    // Check stop bit
                    if (rx == 1'b1) begin

                        // Valid UART frame
                        data_rx <= shift_reg;

                    end

                    state <= IDLE;

                end

                else begin

                    baud_tick <= baud_tick + 1'b1;
                end

            end


            default: begin

                state <= IDLE;
                baud_tick <= 16'd0;
                bit_count <= 4'd0;

            end

        endcase

    end

end

endmodule
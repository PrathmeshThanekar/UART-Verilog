`timescale 1ns / 1ps

module Transmitter (
    input clk,
    input rst,
    input load,
    input [7:0] data_tx,
    output reg tx
);

parameter BAUD_COUNT = 100000000 / 9600;

localparam IDLE = 1'b0;
localparam SEND = 1'b1;

reg state;

reg [9:0] shift_reg;
reg [15:0] baud_tick;
reg [3:0] bit_count;       //  4 bits needed for 0-9

always @(posedge clk or negedge rst) begin

    if (!rst) begin
        tx        <= 1'b1;
        shift_reg <= 10'b0;
        baud_tick <= 16'b0;
        bit_count <= 4'b0;
        state     <= IDLE;
    end

    else begin

        case (state)

            IDLE: begin

                tx        <= 1'b1;
                baud_tick <= 16'b0;
                bit_count <= 4'b0;

                if (load) begin

                    // {STOP, DATA, START}
                    shift_reg <= {1'b1, data_tx, 1'b0};

                    state <= SEND;
                end

            end

            SEND: begin

                if (baud_tick == BAUD_COUNT - 1) begin

                    baud_tick <= 16'b0;

                    // Send current LSB
                    tx <= shift_reg[0];

                    // Shift to next bit
                    shift_reg <= shift_reg >> 1;

                    if (bit_count == 4'd9) begin

                        // All 10 bits sent
                        bit_count <= 4'd0;
                        state <= IDLE;

                    end
                    else begin

                        bit_count <= bit_count + 1'b1;

                    end

                end

                else begin
                    baud_tick <= baud_tick + 1'b1;
                end

            end

            default: begin
                state <= IDLE;
            end

        endcase

    end
end

endmodule
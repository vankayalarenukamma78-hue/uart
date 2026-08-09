```verilog
`timescale 1ns/1ps

module uart_tx #(
    parameter CLKS_PER_BIT = 4
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_busy
);

    reg [7:0] data_reg;
    reg [3:0] bit_index;
    reg [15:0] clk_count;

    always @(posedge clk) begin
        if (rst) begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            data_reg <= 8'b0;
            bit_index <= 0;
            clk_count <= 0;
        end
        else begin
            if (!tx_busy) begin
                tx <= 1'b1;

                if (tx_start) begin
                    tx_busy <= 1'b1;
                    data_reg <= tx_data;
                    bit_index <= 0;
                    clk_count <= 0;
                    tx <= 1'b0;       // Start bit
                end
            end
            else begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end
                else begin
                    clk_count <= 0;

                    if (bit_index < 8) begin
                        tx <= data_reg[bit_index];
                        bit_index <= bit_index + 1;
                    end
                    else begin
                        tx <= 1'b1;   // Stop bit
                        tx_busy <= 1'b0;
                    end
                end
            end
        end
    end

endmodule


module uart_rx #(
    parameter CLKS_PER_BIT = 4
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    output reg [7:0] rx_data,
    output reg       rx_done
);

    reg [7:0] data_reg;
    reg [3:0] bit_index;
    reg [15:0] clk_count;
    reg receiving;

    always @(posedge clk) begin
        if (rst) begin
            rx_data <= 8'b0;
            rx_done <= 1'b0;
            data_reg <= 8'b0;
            bit_index <= 0;
            clk_count <= 0;
            receiving <= 1'b0;
        end
        else begin
            rx_done <= 1'b0;

            if (!receiving) begin
                if (rx == 1'b0) begin
                    receiving <= 1'b1;
                    clk_count <= 0;
                    bit_index <= 0;
                end
            end
            else begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end
                else begin
                    clk_count <= 0;

                    if (bit_index < 8) begin
                        data_reg[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                    end
                    else begin
                        rx_data <= data_reg;
                        rx_done <= 1'b1;
                        receiving <= 1'b0;
                    end
                end
            end
        end
    end

endmodule
```

```verilog
`timescale 1ns/1ps

module uart_tb;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;

    wire [7:0] rx_data;
    wire rx_done;

    // UART Transmitter
    uart_tx #(
        .CLKS_PER_BIT(4)
    ) transmitter (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // UART Receiver
    uart_rx #(
        .CLKS_PER_BIT(4)
    ) receiver (
        .clk(clk),
        .rst(rst),
        .rx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;

        #20;
        rst = 0;

        // Send 8'hA5
        #10;
        tx_data = 8'hA5;
        tx_start = 1;

        #10;
        tx_start = 0;

        // Wait for transmission
        wait(rx_done);

        #10;

        $display("--------------------------------");
        $display("UART Simulation");
        $display("Transmitted Data = %h", tx_data);
        $display("Received Data    = %h", rx_data);

        if (rx_data == tx_data)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        $display("--------------------------------");

        #20;
        $finish;
    end

endmodule
```

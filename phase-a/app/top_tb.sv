`timescale 1ns / 1ps

module tb_top;

    // Parameters
    parameter n = 16;

    // Inputs
    reg [n-1:0] a;
    reg [n-1:0] b;

    // Outputs
    wire [2*n-1:0] result;

    // Instantiate the module
    top #(.n(n)) uut (
        .a(a),
        .b(b),
        .result(result)
    );

    // File handlers
    integer input_file, output_file, scan_status;
    reg [2*n-1:0] expected_result;
    reg [255:0] input_line;

    initial begin
        // Open the input CSV file
        input_file = $fopen("input.csv", "r");
        if (input_file == 0) begin
            $display("Error: Could not open input.csv file!");
            $finish;
        end

        // Open the output CSV file
        output_file = $fopen("output.csv", "w");
        if (output_file == 0) begin
            $display("Error: Could not open output.csv file!");
            $finish;
        end

        // Write the output header
        $fwrite(output_file, "a,b,result\n");

        // Read inputs from CSV and simulate
        while (!$feof(input_file)) begin
            scan_status = $fscanf(input_file, "%h,%h\n", a, b);
            if (scan_status == 2) begin
                #10; // Wait for 10 time units
                $fwrite(output_file, "%h,%h,%h\n", a, b, result);
            end
        end

        // Close files
        $fclose(input_file);
        $fclose(output_file);
        $display("Simulation complete. Results written to output.csv.");
        $finish;
    end
endmodule


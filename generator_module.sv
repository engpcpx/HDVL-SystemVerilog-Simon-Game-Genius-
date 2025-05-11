/**
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: 05/06/2025 08:01:15 AM
    Design Name: Simon Game (Genius)
    Module Name: generator_module
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2024.1
    Description: Generator module for generate a pseudo-random number 
                between 1 and 4 when triggered.
    
    Dependencies: None
    
    Revision: 2025.5.1
    Revision 0.01 - File Created
**/

/**
Additional Comments:
    @file generator_module.sv
    @brief Random Number Generator with Status Signals
    
    @details
    This module generates a pseudo-random number between 1 and 4 when triggered.
    It provides three output signals through a 3-bit vector:
    - o_valuer[0]: Generated random number (1-4)
    - o_valuer[1]: Module active status (1 when enabled)
    - o_valuer[2]: Generation done - complete pulse
    
    @param i_clk     System clock input (posedge-triggered)
    @param i_enable  Active-high enable signal
    @param i_trigger Active-high generation trigger
    @param o_valuer  3-bit output vector [done, active, value]
**/

//------------------------------------------------------------------------------------------------
// generator_module.sv - Generator of the random numeber
//------------------------------------------------------------------------------------------------
`timescale 1ns / 1ps
module generator_module (
    input  logic       i_clk,       // System clock
    input  logic       i_enable,    // Module enable
    input  logic       i_trigger,   // Generation trigger
    output logic [2:0] o_value      // Output [done, active, value]
);

    // Internal signals
    logic [1:0] rand_val;        // Stores generated random value (1-4)
    logic       trigger_latched; // Latches trigger events
    logic [6:0] seed_counter;    // 7-bit seed counter (0-99)
    logic       generation_done; // Pulse signal when number is ready

    // Continuous module active status
    assign o_value[1] = i_enable;

    // Seed counter - increments continuously when enabled
    always_ff @(posedge i_clk) begin
        if (i_enable) begin
            if (seed_counter == 99)
                seed_counter <= 0;
            else
                seed_counter <= seed_counter + 1;
        end
    end

    // Random number generation logic
    always_ff @(posedge i_clk) begin
        generation_done <= 1'b0; // Default
        
        if (i_enable && i_trigger) begin
            // Generate random number 1-4
            rand_val <= ($urandom(seed_counter) % 4) + 1;
            trigger_latched <= 1'b1;
            generation_done <= 1'b1;
        end
    end

    // Trigger reset logic
    always_ff @(negedge i_clk) begin
        trigger_latched <= 1'b0;
    end

    // Output assignments
    assign o_value[0] = trigger_latched ? rand_val : 2'd0; // Number output
    assign o_value[2] = generation_done;                   // Done pulse

endmodule

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
    It provides status signals through o_active and o_done, and outputs the
    random value through the controls interface.
**/

//------------------------------------------------------------------------------------------------
// generator_module.sv - Generator of the random numeber
//------------------------------------------------------------------------------------------------
`timescale 1ns / 1ps

module generator_module (
    // Interface buses
    controls_if.bidir controls,  // Controls interface (consumer ready and produces random number)
    
    // Input ports
    input  logic    i_clk,          // System clock
    input  logic    i_enable,       // Module enable
    input  logic    i_trigger,      // Generation trigger
    
    // Output ports
    output logic    o_active,       // Module active status
    output logic    o_done          // Generation complete pulse
);

    // Internal signals
    logic [1:0] rand_val;           // Stores generated random value (1-4)
    logic       trigger_latched;    // Latches trigger events
    logic [6:0] seed_counter;       // 7-bit seed counter (0-99)
    logic       generation_done;    // Pulse signal when number is ready

    // Continuous module active status
    assign o_active = i_enable;
  

    // Seed counter - increments continuously when enabled
    always_ff @(posedge i_clk) begin
        if (i_enable) begin
            if (seed_counter == 99)
                seed_counter <= 0;
            else
                seed_counter <= seed_counter + 1;
        end
        else begin
            seed_counter <= 0;
        end
    end

    // Random number generation logic
    always_ff @(posedge i_clk) begin
        generation_done <= 1'b0;
        i_trigger <= controls.ready;
        
        if (i_enable && i_trigger) begin
            // Generate random number 1-4
            rand_val <= ($urandom(seed_counter) % 4) + 1;
            trigger_latched <= 1'b1;
            generation_done <= 1'b1;
        end
        else begin
            trigger_latched <= 1'b0;
        end
    end

    // Output assignments
    always_ff @(posedge i_clk) begin
        if (trigger_latched) begin
            controls.value <= rand_val;  // Output random value
            controls.ready <= 1'b1;      // Signal that value is valid
        end
        else begin
            controls.ready <= 1'b0;
        end
    end

    assign o_done = generation_done;

endmodule
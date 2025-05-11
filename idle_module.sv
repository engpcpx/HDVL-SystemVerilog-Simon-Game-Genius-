/**
Additional Comments:
    Company:
    Engineer: Paulo Cezar da Paixao
    Create Date: Create Date: 05/05/2025 03:48:34 PM
    Design Name: Simon Game (Genius)
    Module Name: idle_module
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2024.1
    Description: Idle  

    Dependencies: None
    
    Revision: 2025.5.1
    Revision 0.01 - File Created
**/

/**
Additional Comments:
  @file idle_module.sv
  @brief System Idle State Controller
 
  @details
  Handles the idle state of the system, managing configuration parameters
  and transitioning to active state upon start signal. Features:
    - Holds system configuration (mode, level, speed)
    - Generates initialization values when enabled
    - Synchronous design with system clock
    - Outputs state completion code
 
  @param i_clk     System clock input
  @param i_enable  Module enable signal (active-high)
  @param i_start   System start signal (active-high)
  @param i_mode    Operation mode [1:0]:
                   - 2'b00: Mode A
                   - 2'b01: Mode B
                   - 2'b10: Mode C
                   - 2'b11: Mode D
  @param i_level   Difficulty level [1:0]:
                   - 2'b00: Easy
                   - 2'b01: Medium
                   - 2'b10: Hard
                   - 2'b11: Expert
  @param i_speed   Operation speed [1:0]:
                   - 2'b00: Slow
                   - 2'b01: Medium
                   - 2'b10: Fast
                   - 2'b11: Turbo
  @param o_value   6-bit state completion/output value
 **/

//-----------------------------------------------------------------------------
// idle_module.sv - Handles the IDLE state
//-----------------------------------------------------------------------------
`timescale 1ns / 1ps
module idle_module(
    // Input ports
    input  logic       i_clk,          // System clock
    input  logic       i_enable,       // Enable signal (active-high)
    input  logic       i_start,        // Start signal (active-high)
    input  logic [1:0] i_mode,         // Mode configuration
    input  logic [1:0] i_level,        // Level configuration
    input  logic [1:0] i_speed,        // Speed configuration
     
    // Output ports
    output logic [5:0] o_value         // State completion/output value
);

    // Module logic
    //-------------------------------------------------
    // o_value[0]: Mode setting signal
    // o_value[1]: Level setting signal
    // o_value[2]: Speed setting signal
    // o_value[3]: Active module signal
    // o_value[4]: Done module signal
    
    // assign settings signals
    always_ff @(posedge i_clk && i_enable == 1'b1) begin
        // Update outputs
        o_value[0] <= i_enable;
        o_value[1] <= i_mode;
        o_value[2] <= i_level;
        o_value[3] <= i_speed;
        o_value[4] <= 1'b1;
        o_value[5] <= 1'b1;    
    end    
endmodule

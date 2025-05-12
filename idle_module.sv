/**
Additional Comments:
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: Create Date: 05/05/2025 03:48:34 PM
    Design Name: Simon Game (Genius)
    Module Name: idle_module
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2025
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
    // Interface buses
    settings_if.producer settings,     // Interface producer to write on settings
    controls_if.producer controls,     // Interface producer to write on controls

    // Input ports
    input  logic       i_clk,          // System clock
    input  logic       i_enable,       // Enable signal (active-high)
    input  logic       i_start,        // Start signal (active-high)
     
    // Output ports
    output logic       o_active,       // State active indicator
    output logic       o_done          // State completion indicator
);

    // Module logic
    //-------------------------------------------------
    always_ff @(posedge i_clk) begin
        if(i_enable == 1'b1) begin          
            // Write game params to controls interface 
            if(i_start == 1'b1) begin
                controls.ready <= 1'b1; 
                o_done         <= 1'b1;  
            end else begin
                controls.ready <= 1'b0;          
                o_done         <= 1'b0; 
            end
            
            o_active <= 1'b1; 
        end else begin
            // Disabled state
            settings.mode  <= 2'b0;    // Default values
            settings.level <= 1'b0;
            settings.speed <= 2'b0;
            
            controls.ready <= 1'b0;
            o_active       <= 1'b0; 
            o_done         <= 1'b0;
        end
    end
endmodule
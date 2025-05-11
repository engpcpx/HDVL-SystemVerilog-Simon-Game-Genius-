/**
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: 05/05/2025 01:05:11 PM
    Design Name: Simon Game (Genius)
    Module Name: chip_module
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2025
    Description: Chip abstraction 

    Dependencies: None
    
    Revision: 2025.5.1
    Revision 0.01 - File Created
**/

/**
Additional Comments:
    @file chip_module.sv
    @brief Top-level chip wrapper for game controller

    @details
    This module serves as the top-level wrapper for the game controller system,
    interfacing directly with physical pins and containing the main FSM logic.
    Manages:
    - Game configuration (mode/difficulty/speed)
    - Player input processing
    - LED output control
    - Score display generation

    @param i_clk_pin         Device clock input (200MHz, posedge-triggered)
    @param i_start_pin       Start button input [0:Off, 1:On]
    @param i_mode_pin        Game mode selection [0:Solo, 1:Two players]
    @param i_level_pin       Difficulty level [0:Easy, 1:Medium, 2:Hard] (3-level)
    @param i_speed_pin       Game speed selection [0:Slow, 1:Fast]
    @param i_play_pin        Player action buttons [bit0:Green, bit1:Yellow, bit2:Red, bit3:Blue]
    @param o_start_led_pin   Start status LED output [0:Stop, 1:Match]
    @param o_led_color_pin   Active color LED output [bit0:Green, bit1:Yellow, bit2:Red, bit3:Blue]
    @param o_display_score_pin 7-segment score display output (11-bit control)
**/

//-----------------------------------------------------------------------------
// FSM Instance with consistent naming
//-----------------------------------------------------------------------------
`timescale 1ns / 1ps
    fsm_module u_fsm (
        // Clock and Control
        .i_clk            (i_clk_pin),
        .i_start          (i_start_pin),
        
        // Configuration Inputs
        .i_mode_key       (i_mode_pin),
        .i_level_key      (i_level_pin),
        .i_speed_key      (i_speed_pin),
        .i_play_button    (i_play_pin),
        
        // Outputs
        .o_start_led      (o_start_led_pin),
        .o_led_color      (o_led_color_pin),
        .o_display_score  (o_display_score_pin)
    );

endmodule

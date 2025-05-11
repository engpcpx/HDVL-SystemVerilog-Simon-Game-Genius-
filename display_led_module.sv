/**
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: 05/05/2025 01:05:11 PM
    Design Name: Simon Game (Genius)
    Module Name: chip_module
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2025
    Description: LED display 

    Dependencies: None
    
    Revision: 2025.5.1
    Revision 0.01 - File Created
**/

/**
Additional Comments:
    @file display_LED_module.sv
    @brief LED state controller for multi-player sequence display

    @details
    Manages LED output states based on player sequences and current active player.
    Features:
    - Supports 2-player operation with separate sequences
    - Controls 4-color LED output (RGBY)
    - Synchronous design with 200MHz clock
    - Direct color mapping for LED outputs

    @param i_clk      Main system clock (200 MHz)
    @param i_player   Current active player selection [0:Player1, 1:Player2]
    @param i_seq_p1   6-bit sequence pattern for Player 1
    @param i_seq_p2   6-bit sequence pattern for Player 2
    @param o_led      4-bit LED output ([0]:Green, [1]:Yellow, [2]:Red, [3]:Blue)
**/

//-----------------------------------------------------------------------------
// display_led_module.sv - Handles the leds
//-----------------------------------------------------------------------------
`timescale 1ns / 1ps
module display_led_module (
    // Input ports
    input  logic       i_clk,        // FPGA clock (200 MHz)
    input  logic [1:0] i_player,     // Player selector
    input  logic [5:0] i_seq_p1,     // Sequence for player 1
    input  logic [5:0] i_seq_p2,     // Sequence for player 2

    // Output ports
    output logic [3:0] o_led         // Color LED output
);


endmodule
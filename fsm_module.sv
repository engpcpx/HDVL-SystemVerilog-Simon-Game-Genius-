/**
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: 05/05/2025 03:33:29 PM
    Design Name: Simon Game (Genius)
    Module Name: fsm_module
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2024.1
    Description: Finite State Machine 

    Dependencies: None
    
    Revision: 2025.5.1
    Revision 0.01 - File Created
**/

/** 
 Additional Comments:
    @file fsm_module.sv
    @brief Finite State Machine to control game flow

    @details
    This module implements a game controller FSM that manages:

        - Game modes (single/two players)
        - Difficulty levels
        - Game speed
        - Player inputs
        - LED outputs
        - Score display

    @param i_clk System clock input (200MHz, posedge-triggered)
    @param i_reset_button Active-high reset button
    @param i_start_button Start button [0:Off, 1:On]
    @param i_mode_key Mode selection [0:Solo, 1:Two players]
    @param i_level_key Difficulty level [0:Easy, 1:Hard]
    @param i_speed_key Game speed [0:Slow, 1:Fast]
    @param i_play_button Player input buttons [0:Green, 1:Yellow, 2:Red, 3:Blue]
    @param o_start_led Start status indicator [0:Stop, 1:Match]
    @param o_led_color Current active LED color [0:Green, 1:Yellow, 2:Red, 3:Blue]
    @param o_display_score Current score display (7-segment)
**/

// ----------------------------------------------------------------------------
// fsm_module.sv - Fiite State Machine controller
// ----------------------------------------------------------------------------
`timescale 1ns / 1ps
module fsm_module(

    // Interface buses
    settings_if.bidir settings,               // Interface producer to write on settings
    controls_if.bidir controls,               // Interface producer to write on controls
    
    // Clock and Control Inputs
    input  logic         i_clk,               // FPGA clock [200 MHz]
    input  logic         i_reset_button,      // Active-high reset button
    input  logic         i_start_button,      // Start button [0:Off, 1:On]
    
    // Configuration Inputs
    input  logic [1:0]   i_mode_key,          // Mode switch [0:Solo, 1:Two players]
    input  logic [2:0]   i_level_key,         // Level game [0:Easy, 1:Hard]
    input  logic [1:0]   i_speed_key,         // Speed [0:Slow, 1:Fast]
    input  logic [3:0]   i_play_button,       // Play buttons [0:Green, 1:Yellow, 2:Red, 3:Blue]
    
    // Output Indicators
    output logic         o_start_led,         // Start LED [0:Stop, 1:Match]
    output logic [3:0]   o_led_color,         // LED color [0:Green, 1:Yellow, 2:Red, 3:Blue]
    output logic [10:0]  o_display_score      // Score display (7-segment)
);

    //-------------------------------------------------
    // State Machine Definition
    //-------------------------------------------------
    typedef enum logic [2:0] {
        S_IDLE,
        S_GENERATOR,
        S_DISPLAY,
        S_EVALUATION,
        S_SCOREBOARD
    } state_t;
    
    // State registers
    state_t st_current_state, st_next_state;
            
    //-------------------------------------------------
    // Signal Declarations (changed to packed arrays)
    //-------------------------------------------------
    logic [5:0] w_idle_value; 
    logic [2:0] w_generator_value;
    logic [2:0] w_display_value;
    logic [5:0] w_evaluation_value;
    logic [5:0] w_scoreboard_value;
    
    //------------------------------------------------
    // State Machine Logic with reset
    //------------------------------------------------
    logic [31:0] seq_p1;
    logic [31:0] seq_p2;
    
    always_ff @(posedge i_clk or posedge i_reset_button) begin
        if (i_reset_button) begin
            st_current_state <= S_IDLE;
            seq_p1 <= 32'b0;  // Corrected syntax for 32-bit zero assignment
            seq_p2 <= 32'b0;  // Corrected syntax for 32-bit zero assignment
        end else begin
            st_current_state <= st_next_state;
        end
    end
        
    always_comb begin
        // Default state transition
        st_next_state = st_current_state;
        
        // Sequence flow control
        case (st_current_state)
            S_IDLE:        if (w_idle_value[5])         st_next_state = S_GENERATOR;
            S_GENERATOR:   if (w_generator_value[2])    st_next_state = S_DISPLAY;
            S_DISPLAY:     if (w_display_value[2])      st_next_state = S_EVALUATION;
            S_EVALUATION:  if (w_evaluation_value[5])   st_next_state = S_SCOREBOARD;
            S_SCOREBOARD:  if (w_scoreboard_value[5])   st_next_state = i_start ? S_GENERATOR : S_IDLE;
            default:       st_next_state = S_IDLE;
        endcase
        
        // Reset condition
        if (!i_start) st_next_state = S_IDLE;
    end
    
    //------------------------------------------------
    // Module Instantiations
    //------------------------------------------------
     
    // Idle module
    //------------------------------------------------
    idle_module u_idle(
        // Input ports
        .i_clk(i_clk),                                              // System clock
        .i_enable(st_current_state == S_IDLE && i_start == 1'b1),   // Module enable
        .i_mode(i_mode_key),                                        // Mode configuration
        .i_level(i_level_key),                                      // level configuration
        .i_speed(i_speed_key),                                      // Speed configuration
         
        // Output ports
        .o_value(w_idle_value)                                      // Module array values
    );
    
    // Generator module
    //------------------------------------------------
    generator_module u_generator_module(    
        // Input ports
        .i_clk(i_clk),                                              // System clock
        .i_enable(st_current_state == S_GENERATOR),                 // Module enable
        .i_trigger(),                                               // Generate trigger
        
         // Output ports
        .o_value(w_generator_value)                                 // Module values
    );

    // TODO: Add other module instantiations (display, evaluation, scoreboard)

    // Generator module
    //------------------------------------------------

     // Generator module
    //------------------------------------------------
    
endmodule
/**
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: 05/05/2025 01:20:05 PM
    Design Name: Simon Game (Genius)
    Module Name: controls_if interface
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2024.1
    Description: 
        Interface for control communication between game modules.
        Handles color sequences, user input, scoring and game state.

    Dependencies: None
    
    Revision: 2025.5.2
    Revision 0.01 - File Created
    Revision 0.02 - Signal organization and completeness check
**/

/**
Additional Comments:
    @file scontrols_if.sv
    @brief System Game configuration control interface
  
    @Description: Control interface for Simon Game (Genius) 
                Handles game sequences, user input, scoring and game state
    
    @details
        Signals:
            - Game configuration: User inputs and colors
            - Game state: Current game status and display
            - Player sequences: Stored patterns for both players
            - Scoring system: Player scores and update triggers
        
        Modports:
            - producer: Game controller perspective
            - consumer: Input handler perspective 
            - bidir: Score manager perspective
            - tb: Testbench perspective
 **/

//----------------------------------------------------------------------------- 
// cotrol_if.sv - Interface for control communication between modules
//-----------------------------------------------------------------------------
interface controls_if;
    //----------------------------------------------
    // Game Configuration Signals
    //----------------------------------------------
    logic [3:0]  incolor  = '0;    // Input color [0:Green, 1:Yellow, 2:Red, 3:Blue]
    logic [63:0] user_seq = '0;    // User input sequence (64-bit packed array)
    logic [31:0] user_pos = '0;    // Current position in user sequence [0-31]
    
    //----------------------------------------------
    // Game State Signals
    //----------------------------------------------
    logic        start    = '0;    // System ready indicator (active high)
    logic        ready    = '0;    // Game ready for input (active high)
    logic [3:0]  outcolor = '0;    // Output color display [0:Green, 1:Yellow, 2:Red, 3:Blue]
    logic        correct  = '0;    // Sequence match flag (1:match, 0:no match)
    
    //----------------------------------------------
    // Player Sequences
    //----------------------------------------------
    logic [31:0] seq_p1   = '0;    // Player 1 sequence (32 colors max)
    logic [31:0] seq_p2   = '0;    // Player 2 sequence (32 colors max)
    logic [63:0] seq_len  = '0;    // Current sequence length [1-64]
    logic [31:0] seq_pos  = '0;    // Current sequence position [0-31]
    
    //----------------------------------------------
    // Scoring System
    //----------------------------------------------
    logic [7:0]  score_p1 = '0;    // Player 1 score (0-255)
    logic [7:0]  score_p2 = '0;    // Player 2 score (0-255)
    logic        score_update = '0; // Score update trigger (pulse)

    //----------------------------------------------
    // Modport Definitions
    //----------------------------------------------
    
    // Game Controller Perspective (Producer)
    modport producer (
        output start, ready, outcolor, correct,
        output seq_p1, seq_p2, seq_len, seq_pos,
        output score_p1, score_p2,
        input  incolor, user_seq, user_pos,
        input  score_update
    );
    
    // Input Handler Perspective (Consumer)
    modport consumer (
        input  start, outcolor, correct,
        input  seq_p1, seq_p2, seq_len, seq_pos,
        input  score_p1, score_p2,
        output incolor, user_seq, user_pos,
        output score_update
    );
    
    // Score Manager Perspective (Bidirectional)
    modport bidir (
        inout seq_p1, seq_p2,
        inout score_p1, score_p2,
        inout seq_len, seq_pos,
        inout start, ready, correct,
        inout outcolor
    );
    
    // Testbench Perspective
    modport tb (
        output incolor, user_seq, user_pos, score_update,
        input  start, ready, outcolor, correct,
        input  score_p1, score_p2,
        input  seq_p1, seq_p2, seq_len, seq_pos,
        inout  seq_p1, seq_p2  // Allow testbench to force sequences
    );

endinterface
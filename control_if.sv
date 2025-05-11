`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: QuIIN - CIMATEC
// Engineer: Paulo Cezar da PAixao
// 
// Create Date: 05/05/2025 01:20:05 PM
// Design Name: 
// Module Name: controls_if
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// control_if.sv - Interface for data communication between modules
//-----------------------------------------------------
interface controls_if;
    //-------------------------------------------------
    // Control Signals with Initialization
    //-------------------------------------------------
    // Input Controls
    logic [3:0]  ctrl_incolor = 4'b0;         // Input color [0:Green, 1:Yellow, 2:Red, 3:Blue]
    logic [63:0] ctrl_user_seq = 64'h0;       // User input sequence
    logic [31:0] ctrl_user_pos = 32'd0;       // Current position in user sequence
    logic        ctrl_score_update = 1'b0;    // Score update trigger
    
    // Output Controls
    logic        ctrl_ready = 1'b0;           // System ready indicator
    logic [3:0]  ctrl_outcolor = 4'b0;        // Output color display
    logic [7:0]  ctrl_score_p1 = 8'h0;        // Player 1 score
    logic [7:0]  ctrl_score_p2 = 8'h0;        // Player 2 score
    logic        ctrl_correct = 1'b0;         // Sequence match flag
    
    // Game Sequence Data
    logic [31:0] ctrl_seq_p1 = 32'h0;         // Player 1 sequence (32 colors max)
    logic [31:0] ctrl_seq_p2 = 32'h0;         // Player 2 sequence (32 colors max)
    logic [63:0] ctrl_seq_len = 64'd0;        // Current sequence length
    logic [31:0] ctrl_seq_pos = 32'd0;        // Current sequence position

    //-------------------------------------------------
    // Modport Definitions
    //-------------------------------------------------
    
    // Producer Modport (Game Controller)
    modport producer (
        output ctrl_seq_p1,
        output ctrl_seq_p2,
        output ctrl_seq_len,
        output ctrl_outcolor,
        output ctrl_ready,
        output ctrl_score_p1,
        output ctrl_score_p2,
        output ctrl_correct,
        input  ctrl_incolor,
        input  ctrl_user_seq,
        input  ctrl_user_pos,
        input  ctrl_score_update,
        input  ctrl_seq_pos
    );
    
    // Consumer Modport (Input Handler)
    modport consumer (
        input  ctrl_seq_p1,
        input  ctrl_seq_p2,
        input  ctrl_seq_len,
        input  ctrl_outcolor,
        input  ctrl_ready,
        input  ctrl_score_p1,
        input  ctrl_score_p2,
        input  ctrl_correct,
        input  ctrl_seq_pos,
        output ctrl_incolor,
        output ctrl_user_seq,
        output ctrl_user_pos,
        output ctrl_score_update
    );
    
    // Bidirectional Modport (Score Manager)
    modport bidir (
        inout ctrl_seq_p1,
        inout ctrl_seq_p2,
        inout ctrl_seq_len,
        inout ctrl_outcolor,
        inout ctrl_ready,
        inout ctrl_score_p1,
        inout ctrl_score_p2,
        inout ctrl_incolor,
        inout ctrl_user_seq,
        inout ctrl_user_pos,
        inout ctrl_score_update,
        inout ctrl_correct,
        inout ctrl_seq_pos
    );

endinterface


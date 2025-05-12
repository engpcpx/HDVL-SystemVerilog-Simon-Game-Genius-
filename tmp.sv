/**
Additional Comments:
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: 05/05/2025 03:48:34 PM
    Design Name: Simon Game (Genius)
    Module Name: idle_module
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2025
    Description: Idle State Controller using interface buses

    Dependencies: 
        - settings_if.sv
        - controls_if.sv
    
    Revision: 2025.5.2
    Revision 0.01 - File Created
    Revision 0.02 - Modified to use interface buses
**/

/**
Additional Comments:
  @file idle_module.sv
  @brief System Idle State Controller using interface buses
 
  @details
  Handles the idle state of the system using interface buses for communication.
  Features:
    - Receives configuration through settings_if interface
    - Controls game state through controls_if interface
    - Synchronous design with system clock
    - Outputs state completion signal
 
  @param i_clk       System clock input
  @param i_reset     Active-high reset signal
  @param i_enable    Module enable signal (active-high)
  @param settings    Settings interface (mode, level, speed)
  @param controls    Controls interface (game state)
  @param o_active    Module active signal (active-high)
**/

`timescale 1ns / 1ps
module idle_module(
    // System inputs
    input  logic        i_clk,          // System clock
    input  logic        i_reset,        // Active-high reset
    input  logic        i_enable,       // Module enable
    
    // Interface buses
    settings_if.consumer settings,      // Settings interface (read-only)
    controls_if.producer controls,      // Controls interface (write-only)
    
    // Outputs
    output logic        o_active        // Module active signal
);

    // Internal registers for configuration
    logic [1:0] mode_reg;
    logic [1:0] level_reg;
    logic [1:0] speed_reg;
    
    // State machine
    typedef enum logic [1:0] {
        IDLE,
        CONFIG,
        READY
    } state_t;
    
    state_t current_state, next_state;
    
    // Configuration registers update
    always_ff @(posedge i_clk or posedge i_reset) begin
        if (i_reset) begin
            mode_reg  <= 2'b00;
            level_reg <= 2'b00;
            speed_reg <= 2'b00;
            current_state <= IDLE;
        end else if (i_enable) begin
            current_state <= next_state;
            
            // Latch configuration when in CONFIG state
            if (current_state == CONFIG) begin
                mode_reg  <= settings.mode;
                level_reg <= settings.level;
                speed_reg <= settings.speed;
            end
        end
    end
    
    // State machine transitions
    always_comb begin
        next_state = current_state;
        
        case (current_state)
            IDLE: 
                if (i_enable) next_state = CONFIG;
                
            CONFIG:
                if (settings.mode != 2'b11)  // Skip reserved modes
                    next_state = READY;
                    
            READY:
                if (!i_enable) next_state = IDLE;
        endcase
    end
    
    // Output assignments
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            controls.start <= 1'b0;
            controls.ready <= 1'b0;
            o_active <= 1'b0;
        end else begin
            // Update control interface
            controls.start <= (current_state == READY);
            controls.ready <= (current_state == READY);
            
            // Update active signal
            o_active <= (current_state != IDLE);
            
            // Propagate configuration to controls interface
            if (current_state == READY) begin
                // Map settings to controls interface
                controls.seq_len <= (level_reg == 2'b00) ? 8 :  // Easy: 8 steps
                                   (level_reg == 2'b01) ? 16 :   // Medium: 16 steps
                                   (level_reg == 2'b10) ? 24 :   // Hard: 24 steps
                                   32;                           // Expert: 32 steps
            end
        end
    end
    
endmodule
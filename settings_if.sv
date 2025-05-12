/**
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: 05/05/2025 01:20:05 PM
    Design Name: Simon Game (Genius)
    Module Name: settings interface
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2024.1
    Description: Interface Settings bus abstraction 

    Dependencies: None
    
    Revision: 2025.5.1
    Revision 0.01 - File Created
**/

/**
Additional Comments:
    @file settings_if.sv
    @brief System Game configuration settings interface
    
    @details
    Parameters:
        - mode:  Game mode selection
        - level: Difficulty level
        - speed: Animation speed
    
    Modports:
        - consumer: Read-only access (for game logic)
        - producer: Write-only access (for settings controller)
        - bidir:    Read-write access (for debug/tests)
        - tb:       Testbench access
 **/

//----------------------------------------------------------------------------- 
// settings_if.sv - Interface for settings communication between modules
//-----------------------------------------------------------------------------
interface settings_if;
    //----------------------------------------------
    // Configuration Parameters with Default Values
    //----------------------------------------------
    logic [1:0] mode  = 2'b0;   // Game mode [00:Solo, 01:Two players, 10:Reserved, 11:Reserved]
    logic [1:0] level = 1'b0;   // Level difficulty: [0]:Easy, [1]:Hard
    logic [1:0] speed = 2'b0;   // Speed: [0]:Slow (2s), [1]:Fast (1s)
    
    //----------------------------------------------
    // Modport Definitions
    //----------------------------------------------
    
    // Consumer modport (read-only) - Used by game logic
    modport consumer (
        input mode,
        input level, 
        input speed
    );
    
    // Producer modport (write-only) - Used by settings controller
    modport producer (
        output mode,
        output level,
        output speed
    );
    
    // Bidirectional modport (read/write) - For debug/configuration
    modport bidir (
        inout mode,
        inout level,
        inout speed
    );
    
    // Testbench modport - For verification
    modport tb (
        output mode,    // TB drives these
        output level,
        output speed,
        input  mode,    // TB monitors these (optional)
        input  level,
        input  speed
    );

endinterface
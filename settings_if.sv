/**
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: 05/05/2025 01:20:05 PM
    Design Name: Simon Game (Genius)
    Module Name: settings interface
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2024.1
    Description: Chip abstraction 

    Dependencies: None
    
    Revision: 2025.5.1
    Revision 0.01 - File Created
**/

//----------------------------------------------------------------------------- 
// settings_if.sv - Interface for settings communication between modules
//-----------------------------------------------------------------------------
interface settings_if;
    //-----------------------------------------
    // Configuration Parameters
    //-----------------------------------------
    logic [1:0] cfg_mode;          // Game mode [0:Solo, 1:Two players]
    logic [2:0] cfg_difficulty;    // Difficulty [0:Easy, 1:Medium, 2:Hard]
    logic [1:0] cfg_speed;         // Speed [0:Slow (2s), 1:Fast (1s)]
    
    //-----------------------------------------
    // Modport Definitions
    //-----------------------------------------
    
    // Consumer modport (read-only)
    modport consumer (
        input cfg_mode,
        input cfg_difficulty, 
        input cfg_speed
    );
    
    // Producer modport (write-only)
    modport producer (
        output cfg_mode,
        output cfg_difficulty,
        output cfg_speed
    );
    
    // Bidirectional modport (read/write)
    modport bidir (
        inout cfg_mode,
        inout cfg_difficulty,
        inout cfg_speed
    );

endinterface
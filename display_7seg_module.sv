/**
    Company: 
    Engineer: Paulo Cezar da Paixao
    Create Date: 05/05/2025 03:33:29 PM
    Design Name: Simon Game (Genius)
    Module Name: display_7seg_module
    Project Name: PBL1_Genius_Project
    Target Devices: FPGA
    Tool Versions: Xilinx Vivado 2024.1
    Description: Display 7 Segments 

    Dependencies: None
    
    Revision: 2025.5.1
    Revision 0.01 - File Created
**/

/**
Additional Comments:
    @file display_7seg_module.sv
    @brief 4-digit 7-segment display controller with time-division multiplexing

    @details
    Controls four 7-segment displays using multiplexing (TDM) to minimize pin usage.
    Features:
    - Displays numbers from 0 to 32 (6-bit input)
    - Time-division multiplexing at high speed (>100Hz refresh)
    - Supports common cathode displays (active-low selection)
    - Only 11 total output pins required (7 segments + 4 digit selects)

    @param i_clk       Main clock input (e.g., 50MHz)
    @param i_number    6-bit input value to display (0-32)
    @param o_seg       7-segment outputs [6:0] (A-G segments, active-high)
    @param o_disp_sel  Display select signals [3:0] (active-low for common cathode)

    @Function
	To control 4 7-segment displays, each displaying a digit of a number between 1 and 32, 
	we will use multiplexing (TDM - Time Division Multiplexing) to save FPGA pins. Hardware 
	Configuration 4 7-segment displays (common anode or cathode). 7 pins for segments (A-G) 
	Shared among all displays. 4 pins for display selection → Activates one display at a time. 
	Total pins = 11 (7 segments + 4 selection
*/

//-----------------------------------------------------------------------------
// display_7seg_module.sv - Handles the Dsven segment display
//-----------------------------------------------------------------------------
`timescale 1ns / 1ps
module display_7seg_module (
    // Input ports
    input  logic        i_clk,          // FPGA clock (200 MHz)
    input  logic [5:0]  i_number,       // Input number (0-32)
    
    // Output ports
    output logic [6:0]  o_seg,          // 7-segment outputs (A-G, active-high)
    output logic [3:0]  o_disp_sel      // Display select (active-low for common cathode)
);

// Refresh rate ~1 kHz (adjust based on FPGA clock)
localparam REFRESH_RATE = 50_000;  

// Registers
logic [31:0] counter = 0;
logic [1:0]  digit_pos = 0;        		// Current digit position (0-3)
logic [3:0]  bcd_digits [0:3];     		// Stores 4 BCD digits

// Convert number (0-32) to 4 BCD digits
always_comb begin
    // Initialize all digits to 0
    for (int i = 0; i < 4; i++) 
        bcd_digits[i] = 0;

    // Convert number to BCD (2 digits if ≤ 32)
    if (i_number <= 9) begin
        bcd_digits[0] = i_number[3:0];  // Units
    end else begin
        bcd_digits[0] = i_number % 10;  // Units
        bcd_digits[1] = i_number / 10;  // Tens
    end
end

// Multiplexing logic (~1 kHz refresh)
always_ff @(posedge i_clk) begin
    counter <= counter + 1;
    
    if (counter >= REFRESH_RATE) begin
        counter <= 0;
        digit_pos <= digit_pos + 1;  // Cycle through displays
    end
end

// Output segment and display select logic
always_comb begin
    // Default: all displays OFF (common cathode)
    o_disp_sel = 4'b1111;  
    o_seg = 7'b111_1111;   // All segments OFF

    case (digit_pos)
        0: begin  // Display 1 (Units)
            o_disp_sel = 4'b1110;
            o_seg = get_seg_code(bcd_digits[0]);
        end
        1: begin  // Display 2 (Tens)
            o_disp_sel = 4'b1101;
            o_seg = get_seg_code(bcd_digits[1]);
        end
        2: begin  // Display 3 (Unused)
            o_disp_sel = 4'b1011;
            o_seg = 7'b111_1111;  // OFF
        end
        3: begin  // Display 4 (Unused)
            o_disp_sel = 4'b0111;
            o_seg = 7'b111_1111;  // OFF
        end
    endcase
end

// BCD to 7-segment lookup (common cathode)
function logic [6:0] get_seg_code(input logic [3:0] bcd);
    case (bcd)
        0: return 7'b100_0000;  // 0
        1: return 7'b111_1001;  // 1
        2: return 7'b010_0100;  // 2
        3: return 7'b011_0000;  // 3
        4: return 7'b001_1001;  // 4
        5: return 7'b001_0010;  // 5
        6: return 7'b000_0010;  // 6
        7: return 7'b111_1000;  // 7
        8: return 7'b000_0000;  // 8
        9: return 7'b001_0000;  // 9
        default: return 7'b111_1111;  // OFF
    endcase
endfunction

endmodule
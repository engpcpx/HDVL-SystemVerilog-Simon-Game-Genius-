module idle_module(
    // Interface buses
    settings_if.consumer settings,     // Settings interface (read-only)
    controls_if.producer controls,     // Controls interface (write-only)

    // Input ports
    input  logic       i_clk,          // System clock
    input  logic       i_enable,       // Enable signal (active-high)
    input  logic       i_start,        // Start signal (active-high)
    input  logic [1:0] i_mode,         // Mode configuration
    input  logic [1:0] i_level,        // Level configuration
    input  logic [1:0] i_speed,        // Speed configuration
     
    // Output ports
    output logic       o_active,       // State completion/output value
    output logic       o_done          // State completion/output value
);

    // Module logic
    //-------------------------------------------------
 
    // assign settings signals to settings interface
    always_ff @(posedge i_clk) begin
        if(i_enable == 1'b1) begin          
            // Capture input settings (these are inputs from the consumer modport)
            // Note: Since settings is a consumer modport, we can only read from it
            // The actual settings values come from the interface connection
            
            // Write game params on controls interface 
            if(i_start == 1'b1) begin
                controls.ready <= 1'b1; 
                o_done        <= 1'b1;  
            end else begin
                controls.ready <= 1'b0;          
                o_done        <= 1'b0; 
            end
            
            o_active <= 1'b1; 
        end else begin
            // Disabled state
            controls.ready <= 1'b0;
            o_active       <= 1'b0; 
            o_done         <= 1'b0;
        end
    end
endmodule
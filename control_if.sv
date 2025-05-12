interface controls_if;
    //----------------------------------------------
    // Control Signals
    //----------------------------------------------
    logic       ready  = 1'b0;    // Ready signal
    logic [1:0] value  = 2'b0;    // Random value output (1-4)
    
    //----------------------------------------------
    // Modport Definitions
    //----------------------------------------------
    
    // Consumer modport (read-only)
    modport consumer (
        input ready,
        input value
    );
    
    // Producer modport (write-only)
    modport producer (
        output ready,
        output value
    );
    
    // Bidirectional modport
    modport bidir (
        inout ready,
        inout value
    );
    
    // Testbench modport
    modport tb (
        output ready,
        output value,
        input ready,
        input value
    );
endinterface
function user_inputs()
    inputs = Dict(
        #---------------------------------------------------------------------------
        # User define your inputs below: the order doesn't matter
        #---------------------------------------------------------------------------
        :tend                 => 100.0,
        :Δt                   => 0.5,#8.75e-4,
        :ode_solver           => "Tsit5", #"Tsit5",
        :ndiagnostics_outputs => 5,
        :case                 => "rtb",
        :lsource              => true,
        #---------------------------------------------------------------------------
        #Integration and quadrature properties
        #---------------------------------------------------------------------------
        :interpolation_nodes =>"lgl",   # Choice: lgl, cgl 
        :nop                 => 4,      # Polynomial order
        :luser_bc            => true,
        #---------------------------------------------------------------------------
        # Physical parameters/constants:
        #---------------------------------------------------------------------------
        #:lvisc                => true, #false by default
        #:visc_model           => "dsgs", #"none", "dsgs"
        :νx                   => 30.0, #kinematic viscosity constant
        :νy                   => 30.0, #kinematic viscosity constant
        #---------------------------------------------------------------------------
        # Mesh paramters and files:
        #---------------------------------------------------------------------------
        :lread_gmsh          => true, #If false, a 1D problem will be enforced
        :gmsh_filename       => "./meshes/gmsh_grids/hexa_TFI_RTB.msh",
        #---------------------------------------------------------------------------
        # Plotting parameters
        #---------------------------------------------------------------------------
        #:lwrite_output       => false, #true by default
        :outformat           => "vtk",
        :loutput_pert        => true,  #this is only implemented for VTK for now
        #---------------------------------------------------------------------------
    ) #Dict
    #---------------------------------------------------------------------------
    # END User define your inputs below: the order doesn't matter
    #---------------------------------------------------------------------------

    return inputs
    
end

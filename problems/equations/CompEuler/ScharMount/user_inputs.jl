function user_inputs()
    inputs = Dict(
        #---------------------------------------------------------------------------
        # User define your inputs below: the order doesn't matter
        #---------------------------------------------------------------------------
        :tend                 => 1000.0, #2π,
        :Δt                   => 0.1,#8.75e-4,
        :ode_solver           => SSPRK54(),
        :ndiagnostics_outputs => 10,
        :case                 => "rtb",
        #:CL                   => NCL(),
        :SOL_VARS_TYPE        => PERT(), #TOTAL() is default
        #---------------------------------------------------------------------------
        #Integration and quadrature properties
        #---------------------------------------------------------------------------
        :interpolation_nodes =>"lgl",   # Choice: lgl, cgl 
        :nop                 => 4,      # Polynomial order
        :nop_laguerre        => 24,     # Laguerre polynomial Order
        :luser_bc            => true,
        :lsource             => true,
        #---------------------------------------------------------------------------
        # Physical parameters/constants:
        #---------------------------------------------------------------------------
        :lvisc                => false, #false by default
        #:visc_model           => "dsgs", #"none", "dsgs"
        :νx                   => 0.000015, #kinematic viscosity constant
        :νy                   => 0.000015, #kinematic viscosity constant
        #---------------------------------------------------------------------------
        # Mesh paramters and files:
        #---------------------------------------------------------------------------
        :lread_gmsh          => true, #If false, a 1D problem will be enforced
        #:gmsh_filename       => "./meshes/gmsh_grids/agnesi240kmX30km_coarse.msh",
        #:gmsh_filename        => "./meshes/gmsh_grids/hexa_TFI_10x10_laguerre_top.msh",
        #:gmsh_filename       => "./meshes/gmsh_grids/agnesi-120kmx30km-hm5000.msh",
        #:gmsh_filename        => "./meshes/gmsh_grids/hexa_TFI_RTB.msh",
        :gmsh_filename         => "./meshes/gmsh_grids/hexa_TFI_schar.msh",
        #:gmsh_filename        => "./meshes/gmsh_grids/agnesi240kmX30km_coarse_laguerreTopLateral.msh",
        #---------------------------------------------------------------------------
        # grid modification parameters
        #--------------------------------------------------------------------------- 
        :xscale              => 50000.0,
        :yscale              => 21000.0,
        :xdisp               => 0.0,
        :ydisp               => 1.0,
        #---------------------------------------------------------------------------
        # Mountain parameters
        #---------------------------------------------------------------------------
        :lwarp               => true,
        :mount_type          => "schar",
        :a_mount             => 5000.0,
        :h_mount             => 250.0,
        :lambda_mount        => 4000.0,
        #---------------------------------------------------------------------------
        # Filter parameters
        #---------------------------------------------------------------------------
        :lfilter             => true,
        :mu_x                => 0.05,
        :mu_y                => 0.05,
        :filter_type         => "erf",  ##default is erf, use either "erf" for Boyd-Vandeven,"exp" for Warburton Exponential filter, or "quad" for Fischer quadratic filter
        #---------------------------------------------------------------------------
        # Plotting parameters
        #---------------------------------------------------------------------------
        :outformat           => "vtk",
        :loutput_pert        => true,  #this is only implemented for VTK for now
        #---------------------------------------------------------------------------
    ) #Dict
    #---------------------------------------------------------------------------
    # END User define your inputs below: the order doesn't matter
    #---------------------------------------------------------------------------

    return inputs
    
end

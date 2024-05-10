function params_setup(sem,
                      qp::St_SolutionVars,
                      inputs::Dict,
                      OUTPUT_DIR::String,
                      T)

    #
    # ODE: solvers come from DifferentialEquations.j;
    #
    # Initialize
    println(" # Build arrays and params ................................ ")
    @info " " inputs[:ode_solver] inputs[:tinit] inputs[:tend] inputs[:Δt]
    backend = inputs[:backend] 
    #-----------------------------------------------------------------
    # Initialize:
    # u     -> solution array
    # uaux  -> solution auxiliary array (Eventually to be removed)
    # vaux  -> solution auxiliary array (Eventually to be removed)
    # F,G,H -> physical flux arrays
    # S     -> source array
    # rhs* -> inviscid and viscous ELEMENT rhs
    # RHS* -> inviscid and viscous GLOBAL  rhs
    #-----------------------------------------------------------------
    u    = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.npoin)*Int64(qp.neqs))
    uaux = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.npoin), Int64(qp.neqs))
    vaux = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.npoin)) #generic auxiliary array for general use
    
    rhs        = allocate_rhs(sem.mesh.SD, sem.mesh.nelem, sem.mesh.npoin, sem.mesh.ngl, T, backend; neqs=qp.neqs)
    fluxes     = allocate_fluxes(sem.mesh.SD, sem.mesh.npoin, sem.mesh.ngl, T, backend; neqs=qp.neqs)
    gpuAux     = allocate_gpuAux(sem.mesh.SD, sem.mesh.nelem, sem.mesh.nedges_bdy, sem.mesh.ngl, T, backend; neqs=qp.neqs)
    flux_gpu   = gpuAux.flux_gpu
    source_gpu = gpuAux.source_gpu
    qbdy_gpu   = gpuAux.qbdy_gpu
   
    
    #    
    # The following are currently used by B.C.
    #
    gradu    = KernelAbstractions.zeros(backend, T, 2, 1, 1) #KernelAbstractions.zeros(2,Int64(sem.mesh.npoin),nvars)
    ubdy     = KernelAbstractions.zeros(backend, T, Int64(qp.neqs))
    bdy_flux = KernelAbstractions.zeros(backend, T, Int64(qp.neqs),1)    
    
    xmax = maximum(sem.mesh.x); xmin = minimum(sem.mesh.x)
    ymax = maximum(sem.mesh.y); ymin = minimum(sem.mesh.y)
    
    #
    # filter arrays
    #
    filter = allocate_filter(sem.mesh.SD, sem.mesh.nelem, sem.mesh.npoin, sem.mesh.ngl, T, backend; neqs=qp.neqs, lfilter=inputs[:lfilter])
    fy_t   = transpose(sem.fy)
    
    if ( "Laguerre" in sem.mesh.bdy_edge_type ||
        inputs[:llaguerre_1d_right] == true   ||
        inputs[:llaguerre_1d_left]  == true )
        
        rhs_lag = allocate_rhs_lag(sem.mesh.SD,
                                   sem.mesh.nelem_semi_inf,
                                   sem.mesh.npoin,
                                   sem.mesh.ngl,
                                   sem.mesh.ngr,
                                   T,
                                   backend;
                                   neqs = qp.neqs)

        fluxes_lag = allocate_fluxes_lag(sem.mesh.SD,
                                         sem.mesh.ngl,
                                         sem.mesh.ngr,
                                         T,
                                         backend;
                                         neqs = qp.neqs)

        filter_lag =  allocate_filter_lag(sem.mesh.SD,
                                          sem.mesh.nelem_semi_inf,
                                          sem.mesh.npoin,
                                          sem.mesh.ngl,
                                          sem.mesh.ngr,
                                          T,
                                          backend;
                                          neqs = qp.neqs,
                                          lfilter = inputs[:lfilter])
        fy_t_lag = transpose(sem.fy_lag)
    end
    
    
    #The following are only built and active if Laguerre boundaries are to be used
    #=if ( "Laguerre" in sem.mesh.bdy_edge_type)
        #
        # 2D & 3D dd if statement like aboe
        #
        if  sem.mesh.nsd == 2
            rhs_el_lag       = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            rhs_diff_el_lag  = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            rhs_diffξ_el_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            rhs_diffη_el_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            F_lag            = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            G_lag            = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            H_lag            = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            S_lag            = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            RHS_lag          = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.npoin), qp.neqs)
            RHS_visc_lag     = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.npoin), qp.neqs)
            uprimitive_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs+1)
            q_t_lag = KernelAbstractions.zeros(backend, T,qp.neqs,Int64(sem.mesh.ngl),Int64(sem.mesh.ngr))
            q_ti_lag = KernelAbstractions.zeros(backend, T,Int64(sem.mesh.ngl),Int64(sem.mesh.ngr))
            fqf_lag = KernelAbstractions.zeros(backend, T,qp.neqs,Int64(sem.mesh.ngl),Int64(sem.mesh.ngr))
            b_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            B_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.npoin), qp.neqs)
            flux_lag_gpu = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf),Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), 2*qp.neqs)
            source_lag_gpu = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf),Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
            qbdy_lag_gpu = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf),Int64(sem.mesh.ngl), Int64(sem.mesh.ngr), qp.neqs)
        elseif  sem.mesh.nsd == 3
          error(" src/kernel/infrastructore/params_setup.jl: 3D Laguerre arrays not coded yet!")
        end
    end
    if (inputs[:llaguerre_1d_right] || inputs[:llaguerre_1d_left])
        #
        # 1D
        #
        rhs_el_lag       = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngr), qp.neqs)
        rhs_diff_el_lag  = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngr), qp.neqs)
        rhs_diffξ_el_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngr), qp.neqs)
        rhs_diffη_el_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngr), qp.neqs)
        rhs_diffζ_el_lag = KernelAbstractions.zeros(backend, T, 0)
        F_lag            = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngr), qp.neqs)
        G_lag            = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngr), qp.neqs)
        H_lag            = KernelAbstractions.zeros(backend, T, 0)
        S_lag            = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngr), qp.neqs)
        uprimitive_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngr), qp.neqs+1)
        
        RHS_lag          = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.npoin), qp.neqs)
        RHS_visc_lag     = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.npoin), qp.neqs)
        q_t_lag = KernelAbstractions.zeros(backend, T, qp.neqs, Int64(sem.mesh.ngr))
        q_ti_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.ngr))
        fqf_lag = KernelAbstractions.zeros(backend, T, qp.neqs, Int64(sem.mesh.ngr))
        b_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngr), qp.neqs)
        B_lag = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.npoin), qp.neqs)
        flux_lag_gpu = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngr), 2*qp.neqs)
        source_lag_gpu = KernelAbstractions.zeros(backend, T, Int64(sem.mesh.nelem_semi_inf), Int64(sem.mesh.ngr), qp.neqs)
    end=#

    #-----------------------------------------------------------------
    for i=1:qp.neqs
        idx = (i-1)*sem.mesh.npoin
        u[idx+1:i*sem.mesh.npoin] = @view qp.qn[:,i]
        qp.qnm1[:,i] = @view(qp.qn[:,i])
        qp.qnm2[:,i] = @view(qp.qn[:,i])
        
    end
    
    deps  = KernelAbstractions.zeros(backend, T, 1,1)
    Δt    = inputs[:Δt]
    tspan = (T(inputs[:tinit]), T(inputs[:tend]))    
    if (backend == CPU())
        visc_coeff = inputs[:μ]
    else
        coeffs     = zeros(TFloat,qp.neqs)
        coeffs    .= inputs[:μ]
        visc_coeff = KernelAbstractions.allocate(backend,TFloat,qp.neqs)
        KernelAbstractions.copyto!(backend,visc_coeff,coeffs)
    end
    ivisc_equations = inputs[:ivisc_equations]   
    
    if ("Laguerre" in sem.mesh.bdy_edge_type || inputs[:llaguerre_1d_right] || inputs[:llaguerre_1d_left])
        
        params = (backend, T,
                  rhs, fluxes,
                  uaux, vaux,
                  ubdy, gradu, bdy_flux, #for B.C.
                  flux_gpu, source_gpu, qbdy_gpu,
                  q_t, q_ti, fqf, b, B,
                  q_t_lag, q_ti_lag, fqf_lag, b_lag, B_lag, flux_lag_gpu, source_lag_gpu,
                  qbdy_lag_gpu,
                  F_lag, G_lag, S_lag, 
                  rhs_el_lag,
                  rhs_diff_el_lag,
                  rhs_diffξ_el_lag, rhs_diffη_el_lag,
                  RHS_lag, RHS_visc_lag, uprimitive_lag, 
                  SD=sem.mesh.SD, sem.QT, sem.CL, sem.PT, sem.AD,
                  sem.SOL_VARS_TYPE,
                  neqs=qp.neqs,
		  basis=sem.basis[1], basis_lag = sem.basis[2], ω = sem.ω[1], ω_lag = sem.ω[2], sem.mesh, metrics = sem.metrics[1], metrics_lag = sem.metrics[2], 
                  inputs, visc_coeff, ivisc_equations,
                  sem.matrix.M, sem.matrix.Minv,tspan,
                  Δt, deps, xmax, xmin, ymax, ymin,
                  qp, sem.fx, sem.fy, fy_t, sem.fy_lag, fy_t_lag, laguerre=true)
    else
        params = (backend, T, inputs,
                  rhs, fluxes, 
                  uaux, vaux,
                  ubdy, gradu, bdy_flux,
                  flux_gpu, source_gpu, qbdy_gpu,
                  #q_t, q_ti, fqf, b, B,
                  SD=sem.mesh.SD, sem.QT, sem.CL, sem.PT, sem.AD, 
                  sem.SOL_VARS_TYPE, 
                  neqs=qp.neqs,
                  sem.basis, sem.ω, sem.mesh, sem.metrics,
                  visc_coeff, ivisc_equations,
                  sem.matrix.M, sem.matrix.Minv,tspan,
                  Δt, deps, xmax, xmin, ymax, ymin,
                  qp, sem.fx, sem.fy, fy_t,laguerre=false)
    end 


    println(" # Build arrays and params ................................ DONE")

    return params, u
    
end


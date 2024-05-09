#---------------------------------------------------------------------------
# Optimized (more coud possibly be done)
#---------------------------------------------------------------------------
function RHStoDU!(du, RHS, neqs, npoin)
    for i=1:neqs
        idx = (i-1)*npoin
        du[idx+1:i*npoin] = @view RHS[:,i]
    end  
end

function u2uaux!(uaux, u, neqs, npoin)

    for i=1:neqs
        idx = (i-1)*npoin
        uaux[:,i] = view(u, idx+1:i*npoin)
    end
    
end

function uaux2u!(u, uaux, neqs, npoin)

    for i=1:neqs
        idx = (i-1)*npoin
        for j=1:npoin
            u[idx+j] = uaux[j,i]
        end
    end
    
end

function resetRHSToZero_inviscid!(params)
    fill!(params.rhs.rhs_el, zero(params.T))   
    fill!(params.rhs.RHS,    zero(params.T))
end

function reset_filters!(params)
    fill!(params.filter.b,      zero(params.T))
    fill!(params.filter.B,      zero(params.T))
end

function reset_laguerre_filters!(params)
    fill!(params.filter.b_lag,      zero(params.T))
    fill!(params.filter.B_lag,      zero(params.T))
end

function resetRHSToZero_viscous!(params, SD::NSD_2D)
    fill!(params.rhs.rhs_diff_el,  zero(params.T))
    fill!(params.rhs.rhs_diffξ_el, zero(params.T))
    fill!(params.rhs.rhs_diffη_el, zero(params.T))
    fill!(params.rhs.RHS_visc,     zero(params.T))
end

function resetRHSToZero_viscous!(params, SD::NSD_3D)
    fill!(params.rhs.rhs_diff_el,  zero(params.T))
    fill!(params.rhs.rhs_diffξ_el, zero(params.T))
    fill!(params.rhs.rhs_diffη_el, zero(params.T))
    fill!(params.rhs.rhs_diffζ_el, zero(params.T))
    fill!(params.rhs.RHS_visc, zero(params.T))
end


function uToPrimitives!(neqs, uprimitive, u, uauxe, mesh, δtotal_energy, iel, PT, ::CL, ::AbstractPert, SD::NSD_1D)
    nothing
end

function uToPrimitives!(neqs, uprimitive, u, uauxe, connijk, ngl, npoin, δtotal_energy, iel, PT, ::CL, ::TOTAL, SD::NSD_2D)

    if typeof(PT) == CompEuler
        
        PhysConst = PhysicalConst{Float64}()
        
        for j=1:ngl, i=1:ngl
            
            m1 = connijk[iel,i,j]
            m2 = m1 + npoin
            m3 = m2 + npoin
            m4 = m3 + npoin
            
            uprimitive[i,j,1] = u[m1]
            uprimitive[i,j,2] = u[m2]/u[m1]
            uprimitive[i,j,3] = u[m3]/u[m1]
            uprimitive[i,j,4] = u[m4]/u[m1] - δtotal_energy*0.5*(uprimitive[i,j,2]^2 + uprimitive[i,j,3]^2)
            #Tracers
            if(neqs > 4)
                mieq = m4
                for ieq = 5:neqs
                    mieq = mieq + npoin
                    uprimitive[i,j,ieq] = u[mieq]
                end
            end
            #Pressure:
            uprimitive[i,j,end] = perfectGasLaw_ρθtoP(PhysConst, ρ=uprimitive[i,j,1], θ=uprimitive[i,j,4])
            
        end
        
    elseif typeof(PT) == AdvDiff
        
        for j=1:mesh.ngl, i=1:mesh.ngl
            
            mieq = mesh.connijk[iel,i,j]
            uprimitive[i,j,1] = u[mieq]
            
            for ieq = 2:neqs
                mieq = mieq + mesh.npoin
                uprimitive[i,j,ieq] = u[mieq]
            end
            
        end
    end
end


function uToPrimitives!(neqs, uprimitive, u, uauxe, connijk, ngl, npoin, δtotal_energy, iel, PT, ::CL, ::TOTAL, SD::NSD_3D)
    
    if typeof(PT) == CompEuler
        
        PhysConst = PhysicalConst{Float64}()
        
        for k=1:ngl, j=1:ngl, i=1:ngl
            
            m1 = connijk[iel,i,j,k]
            m2 = m1 + npoin
            m3 = m2 + npoin
            m4 = m3 + npoin
            m5 = m4 + npoin
            
            uprimitive[i,j,k,1] = u[m1]
            uprimitive[i,j,k,2] = u[m2]/u[m1]
            uprimitive[i,j,k,3] = u[m3]/u[m1]
            uprimitive[i,j,k,4] = u[m4]/u[m1]
            uprimitive[i,j,k,5] = u[m5]/u[m1] - δtotal_energy*0.5*(uprimitive[i,j,k,2]^2 + uprimitive[i,j,k,3]^2 + uprimitive[i,j,k,4]^2)
            #Tracers
            if(neqs > 5)
                mieq = m5
                for ieq = 6:neqs
                    mieq = mieq + npoin
                    uprimitive[i,j,k,ieq] = u[mieq]
                end
            end
            #Pressure:
            uprimitive[i,j,k,end] = perfectGasLaw_ρθtoP(PhysConst, ρ=uprimitive[i,j,k,1], θ=uprimitive[i,j,k,5])
        end
        
    elseif typeof(PT) == AdvDiff
        
        for k=1:ngl, j=1:ngl, i=1:ngl
            
            mieq = connijk[iel,i,j,k]
            uprimitive[i,j,k,1] = u[mieq]
            
            for ieq = 2:neqs
                mieq = mieq + npoin
                uprimitive[i,j,k,ieq] = u[mieq]
            end
            
        end
    end
end

function uToPrimitives!(neqs, uprimitive, u, uauxe, connijk, ngl, npoin, δtotal_energy, iel, PT, ::CL, ::PERT, SD::NSD_2D)
    
    if typeof(PT) == CompEuler
        PhysConst = PhysicalConst{Float64}()
        
        for j=1:ngl, i=1:ngl
            
            m1 = connijk[iel,i,j]
            m2 = m1 + npoin
            m3 = m2 + npoin
            m4 = m3 + npoin

            uprimitive[i,j,1] = u[m1] + uauxe[m1,1]
            uprimitive[i,j,2] = u[m2]/uprimitive[i,j,1]
            uprimitive[i,j,3] = u[m3]/uprimitive[i,j,1]
            uprimitive[i,j,4] = (u[m4] + uauxe[m1,4])/uprimitive[i,j,1] - uauxe[m1,4]/uauxe[m1,1]#(u[m4] + uauxe[m1,4])/uprimitive[i,j,1]

            #Tracers
            if(neqs > 4)
                mieq = m4
                for ieq = 5:neqs
                    mieq = mieq + npoin
                    uprimitive[i,j,ieq] = u[mieq] + uauxe[mieq,1]
                end
            end
            
            #Pressure:
            #uprimitive[i,j,end] = perfectGasLaw_ρθtoP(PhysConst, ρ=uprimitive[i,j,1], θ=uprimitive[i,j,4])
            
        end
        
    elseif typeof(PT) == AdvDiff
        
        for j=1:ngl, i=1:ngl
            
            mieq = connijk[iel,i,j]
            uprimitive[i,j,1] = u[mieq]
            
            for ieq = 2:neqs
                mieq = mieq + npoin
                uprimitive[i,j,ieq] = u[mieq]
            end
            
        end
    end
    
end


function uToPrimitives!(neqs, uprimitive, u, uprimitivee, mesh, δtotal_energy, iel, PT, ::NCL, ::AbstractPert, SD::NSD_2D)

    if typeof(PT) == CompEuler
        PhysConst = PhysicalConst{Float64}()
        
        for j=1:mesh.ngl, i=1:mesh.ngl
            
            m1 = mesh.connijk[iel,i,j]
            m2 = m1 + mesh.npoin
            m3 = m2 + mesh.npoin
            m4 = m3 + mesh.npoin

            uprimitive[i,j,1] = u[m1]
            uprimitive[i,j,2] = u[m2]
            uprimitive[i,j,3] = u[m3]
            uprimitive[i,j,4] = u[m4]

            #Tracers
            if(neqs > 4)
                mieq = 4
                for ieq = 5:neqs
                    mieq = mieq + mesh.npoin
                    uprimitive[i,j,ieq] = u[mieq]                
                end
            end
            
            #Pressure:
            uprimitive[i,j,end] = perfectGasLaw_ρθtoP(PhysConst, ρ=uprimitive[i,j,1], θ=uprimitive[i,j,4])
            
        end
        
    elseif typeof(PT) == AdvDiff
        
        for j=1:mesh.ngl, i=1:mesh.ngl
            
            mieq = mesh.connijk[iel,i,j]
            uprimitive[i,j,1] = u[mieq]
            
            for ieq = 2:neqs
                mieq = mieq + mesh.npoin
                uprimitive[i,j,ieq] = u[mieq]
            end
            
        end
    end
    
end

function rhs!(du, u, params, time)

    backend = params.inputs[:backend]
    
    if (backend == CPU())
        #
        # CPU 
        #
        _build_rhs!(@view(params.rhs.RHS[:,:]), u, params, time)
        if (params.laguerre) 
            _build_rhs_laguerre!(@view(params.rhs.RHS_lag[:,:]), u, params, time)
            params.rhs.RHS .= @views(params.rhs.RHS .+ params.rhs.RHS_lag)
        end
        RHStoDU!(du, @view(params.rhs.RHS[:,:]), params.neqs, params.mesh.npoin)
    else
        #
        # GPU 
        #
        if (params.SD == NSD_1D())
            k = _build_rhs_gpu_v0!(backend,(Int64(params.mesh.ngl)))
            k(params.rhs.RHS, u, params.mesh.connijk , params.basis.dψ, params.ω, params.M, params.mesh.ngl; ndrange = params.mesh.nelem*params.mesh.ngl,workgroupsize = params.mesh.ngl)
            RHStoDU!(du, @view(params.rhs.RHS[:,:]), params.neqs, params.mesh.npoin)
        elseif (params.SD == NSD_3D())
            
            params.rhs.RHS .= TFloat(0.0)
            PhysConst = PhysicalConst{TFloat}()
            
            k1 = utouaux_gpu!(backend)
            k1(u,params.uaux,params.mesh.npoin,TInt(params.neqs);ndrange = (params.mesh.npoin,params.neqs), workgroupsize = (params.neqs))
            
            k = apply_boundary_conditions_gpu_3D!(backend)
            k(@view(params.uaux[:,:]), @view(u[:]), params.mesh.x, params.mesh.y, params.mesh.z, TFloat(time),params.metrics.nx,params.metrics.ny, params.metrics.nz,
              params.mesh.poin_in_bdy_face,params.qbdy_gpu,params.mesh.ngl,TInt(params.neqs), params.mesh.npoin;
              ndrange = (params.mesh.nfaces_bdy*params.mesh.ngl,params.mesh.ngl), workgroupsize = (params.mesh.ngl,params.mesh.ngl))
            KernelAbstractions.synchronize(backend)
            
            k1(u,params.uaux,params.mesh.npoin,TInt(params.neqs);ndrange = (params.mesh.npoin,params.neqs), workgroupsize = (params.neqs))
            
            k = _build_rhs_gpu_3D_v0!(backend, (Int64(params.mesh.ngl),Int64(params.mesh.ngl),Int64(params.mesh.ngl)))
            k(params.rhs.RHS, params.uaux, params.mesh.x, params.mesh.y, params.mesh.z, params.mesh.connijk, params.metrics.dξdx, params.metrics.dξdy, params.metrics.dξdz, params.metrics.dηdx, 
              params.metrics.dηdy, params.metrics.dηdz, params.metrics.dζdx, params.metrics.dζdy, params.metrics.dζdz, params.metrics.Je,
              params.basis.dψ, params.ω, params.Minv, params.flux_gpu, params.source_gpu,
              params.mesh.ngl, TInt(params.neqs), PhysConst;
              ndrange = (params.mesh.nelem*params.mesh.ngl,params.mesh.ngl,params.mesh.ngl), workgroupsize = (params.mesh.ngl,params.mesh.ngl,params.mesh.ngl))
            KernelAbstractions.synchronize(backend)
            
            if (params.inputs[:lvisc])
                params.rhs.RHS_visc .= TFloat(0.0)
                params.rhs.rhs_diffξ_el .= TFloat(0.0)
                params.rhs.rhs_diffη_el .= TFloat(0.0)
                params.rhs.rhs_diffζ_el .= TFloat(0.0)
                params.source_gpu .= TFloat(0.0)
                
                k = _build_rhs_diff_gpu_3D_v0!(backend, (Int64(params.mesh.ngl),Int64(params.mesh.ngl),Int64(params.mesh.ngl)))
                k(params.rhs.RHS_visc, params.rhs.rhs_diffξ_el, params.rhs.rhs_diffη_el, params.rhs.rhs_diffζ_el, params.uaux, params.source_gpu, params.mesh.x, params.mesh.y, params.mesh.z, params.mesh.connijk, 
                  params.metrics.dξdx, params.metrics.dξdy, params.metrics.dξdz, params.metrics.dηdx, params.metrics.dηdy, params.metrics.dηdz, params.metrics.dζdx, params.metrics.dζdy, 
                  params.metrics.dζdz, params.metrics.Je, params.basis.dψ, params.ω, params.Minv, params.visc_coeff, params.mesh.ngl, TInt(params.neqs), PhysConst; 
                  ndrange = (params.mesh.nelem*params.mesh.ngl,params.mesh.ngl,params.mesh.ngl), workgroupsize = (params.mesh.ngl,params.mesh.ngl,params.mesh.ngl))
                KernelAbstractions.synchronize(backend)
                
                @inbounds params.rhs.RHS .+= params.rhs.RHS_visc
            end
            
            k1 = RHStodu_gpu!(backend)
            k1(params.rhs.RHS,du,params.mesh.npoin,TInt(params.neqs);ndrange = (params.mesh.npoin,params.neqs), workgroupsize = (params.mesh.ngl,params.neqs))
            
        elseif (params.SD == NSD_2D())
            params.rhs.RHS .= TFloat(0.0)
            PhysConst = PhysicalConst{TFloat}()
            
            k1 = utouaux_gpu!(backend)
            k1(u,params.uaux,params.mesh.npoin,TInt(params.neqs);ndrange = (params.mesh.npoin,params.neqs), workgroupsize = (params.mesh.ngl,params.neqs))
            
            k = apply_boundary_conditions_gpu!(backend)
            k(@view(params.uaux[:,:]), @view(u[:]), params.mesh.x,params.mesh.y,TFloat(time),params.metrics.nx,params.metrics.ny,
              params.mesh.poin_in_bdy_edge,params.qbdy_gpu,params.mesh.ngl,TInt(params.neqs), params.mesh.npoin;
              ndrange = (params.mesh.nedges_bdy*params.mesh.ngl), workgroupsize = (params.mesh.ngl))
            KernelAbstractions.synchronize(backend)
            
            if (params.laguerre)

                k = apply_boundary_conditions_lag_gpu!(backend)
                k(@view(params.uaux[:,:]), @view(u[:]), params.mesh.x,params.mesh.y,TFloat(time), params.mesh.connijk_lag,
                  params.qbdy_lag_gpu, params.mesh.ngl, params.mesh.ngr, TInt(params.neqs), params.mesh.npoin, params.mesh.nelem_semi_inf;
                  ndrange = (params.mesh.nelem_semi_inf*params.mesh.ngl,params.mesh.ngr), workgroupsize = (params.mesh.ngl,params.mesh.ngr))
                KernelAbstractions.synchronize(backend)
            end

            k1(u,params.uaux,params.mesh.npoin,TInt(params.neqs);ndrange = (params.mesh.npoin,params.neqs), workgroupsize = (params.mesh.ngl,params.neqs))
            
            k = _build_rhs_gpu_2D_v0!(backend, (Int64(params.mesh.ngl),Int64(params.mesh.ngl)))
            k(params.rhs.RHS, params.uaux, params.qp.qe, params.mesh.x, params.mesh.y, params.mesh.connijk, 
              params.metrics.dξdx, params.metrics.dξdy, params.metrics.dηdx, params.metrics.dηdy, params.metrics.Je,
              params.basis.dψ, params.ω, params.Minv, params.flux_gpu, params.source_gpu, params.mesh.ngl, TInt(params.neqs), PhysConst;
              ndrange = (params.mesh.nelem*params.mesh.ngl,params.mesh.ngl), workgroupsize = (params.mesh.ngl,params.mesh.ngl))
            KernelAbstractions.synchronize(backend)
            
            if (params.laguerre)
                params.rhs.RHS_lag .= TFloat(0.0)
                                
                k_lag = _build_rhs_lag_gpu_2D_v0!(backend, (Int64(params.mesh.ngl),Int64(params.mesh.ngr)))
                k_lag(params.rhs.RHS_lag, params.uaux, params.qp.qe, params.mesh.x, params.mesh.y, params.mesh.connijk_lag, params.metrics_lag.dξdx, params.metrics_lag.dξdy,
                      params.metrics_lag.dηdx, params.metrics_lag.dηdy, params.metrics_lag.Je, params.basis.dψ, params.basis_lag.dψ, params.ω,
                      params.ω_lag, params.Minv, params.flux_lag_gpu, params.source_lag_gpu, params.mesh.ngl, params.mesh.ngr, TInt(params.neqs), PhysConst;
                      ndrange = (params.mesh.nelem_semi_inf*params.mesh.ngl,params.mesh.ngr), workgroupsize = (params.mesh.ngl,params.mesh.ngr))
                KernelAbstractions.synchronize(backend)

                @inbounds params.rhs.RHS .+= params.rhs.RHS_lag

                if (params.inputs[:lvisc])
                    params.rhs.RHS_visc_lag .= TFloat(0.0)
                    params.rhs.rhs_diffξ_el_lag .= TFloat(0.0)
                    params.rhs.rhs_diffη_el_lag .= TFloat(0.0)
                    params.source_lag_gpu .= TFloat(0.0)

                    k_diff_lag = _build_rhs_visc_lag_gpu_2D_v0!(backend, (Int64(params.mesh.ngl),Int64(params.mesh.ngr)))
                    k_diff_lag(params.rhs.RHS_visc_lag, params.rhs.rhs_diffξ_el_lag, params.rhs.rhs_diffη_el_lag, params.uaux, params.qp.qe, params.source_lag_gpu, params.mesh.x,
                               params.mesh.y, params.mesh.connijk_lag, params.metrics_lag.dξdx, params.metrics_lag.dξdy, params.metrics_lag.dηdx, params.metrics_lag.dηdy,
                               params.metrics_lag.Je, params.basis.dψ, params.basis_lag.dψ, params.ω, params.ω_lag, params.Minv, params.visc_coeff,
                               params.mesh.ngl, params.mesh.ngr, TInt(params.neqs), PhysConst;
                               ndrange = (params.mesh.nelem_semi_inf*params.mesh.ngl,params.mesh.ngr), workgroupsize = (params.mesh.ngl,params.mesh.ngr))
                    
                    @inbounds params.rhs.RHS .+= params.rhs.RHS_visc_lag
                    
                end
                
            end

            if (params.inputs[:lvisc])
                params.rhs.RHS_visc .= TFloat(0.0)
                params.rhs.rhs_diffξ_el .= TFloat(0.0)
                params.rhs.rhs_diffη_el .= TFloat(0.0)
                params.source_gpu .= TFloat(0.0)
                
                k = _build_rhs_diff_gpu_2D_v0!(backend, (Int64(params.mesh.ngl),Int64(params.mesh.ngl)))
                k(params.rhs.RHS_visc, params.rhs.rhs_diffξ_el, params.rhs.rhs_diffη_el, params.uaux, params.qp.qe, params.source_gpu, params.mesh.x, params.mesh.y, params.mesh.connijk, 
                  params.metrics.dξdx, params.metrics.dξdy, params.metrics.dηdx, params.metrics.dηdy, params.metrics.Je, params.basis.dψ, params.ω, params.Minv, 
                  params.visc_coeff, params.mesh.ngl, TInt(params.neqs), PhysConst; ndrange = (params.mesh.nelem*params.mesh.ngl,params.mesh.ngl), workgroupsize = (params.mesh.ngl,params.mesh.ngl))
                KernelAbstractions.synchronize(backend)

                @inbounds params.rhs.RHS .+= params.rhs.RHS_visc
            end
            
            k1 = RHStodu_gpu!(backend)
            k1(params.rhs.RHS,du,params.mesh.npoin,TInt(params.neqs);ndrange = (params.mesh.npoin,params.neqs), workgroupsize = (params.mesh.ngl,params.neqs))
            
        end
    end
end

function _build_rhs!(RHS, u, params, time)

    T       = Float64
    SD      = params.SD
    QT      = params.QT
    CL      = params.CL
    AD      = params.AD
    neqs    = params.neqs
    ngl     = params.mesh.ngl
    nelem   = params.mesh.nelem
    npoin   = params.mesh.npoin
    lsource = params.inputs[:lsource]
    
    #-----------------------------------------------------------------------------------
    # Inviscid rhs:
    #-----------------------------------------------------------------------------------    
    resetRHSToZero_inviscid!(params) 
    
    if (params.inputs[:lfilter])
        reset_filters!(params)
        if (params.laguerre)
            reset_laguerre_filters!(params)
        end
        filter!(u, params, time, params.uaux, params.mesh.connijk, params.mesh.connijk_lag, params.metrics.Je, params.metrics_lag.Je, SD, params.SOL_VARS_TYPE)
    end
    
    u2uaux!(@view(params.uaux[:,:]), u, params.neqs, params.mesh.npoin)
    apply_boundary_conditions!(u, params.uaux, time, params.qp.qe,
                               params.mesh.x, params.mesh.y, params.mesh.z,
                               params.metrics.nx, params.metrics.ny, params.metrics.nz,
                               params.mesh.npoin, params.mesh.npoin_linear, 
                               params.mesh.poin_in_bdy_edge, params.mesh.nedges_bdy,
                               params.mesh.ngl, params.mesh.ngr,
                               params.mesh.nelem_semi_inf,
                               params.basis.ψ, params.basis.dψ,
                               params.mesh.xmax, params.mesh.ymax,
                               params.mesh.zmax, params.mesh.xmin,
                               params.mesh.ymin, params.mesh.zmin,
                               params.rhs.RHS,
                               params.rhs.rhs_el,
                               params.ubdy,
                               params.mesh.connijk_lag,
                               params.mesh.bdy_edge_in_elem, params.mesh.bdy_edge_type,
                               params.ω, neqs, params.inputs, AD, SD)
   
    inviscid_rhs_el!(u, params.fluxes.uprimitive, params,
                     params.mesh.connijk,
                     params.fluxes.F, params.fluxes.G, params.fluxes.H, params.fluxes.S,
                     params.qp.qe,
                     params.mesh.x, params.mesh.y,                     
                     lsource, SD;
                     xmin=params.mesh.xmin, xmax=params.mesh.xmax,
                     ymin=params.mesh.ymin, ymax=params.mesh.ymax)
    
    DSS_rhs!(params.rhs.RHS, params.rhs.rhs_el, params.mesh.connijk, nelem, ngl, neqs, SD, AD)
   
    #-----------------------------------------------------------------------------------
    # Viscous rhs:
    #-----------------------------------------------------------------------------------
    if (params.inputs[:lvisc] == true)
        
        resetRHSToZero_viscous!(params, SD)
        
        viscous_rhs_el!(u, params, SD)
        
        DSS_rhs!(params.rhs.RHS_visc, params.rhs.rhs_diff_el, params.mesh.connijk, nelem, ngl, neqs, SD, AD)
        
        params.rhs.RHS[:,:] .= @view(params.rhs.RHS[:,:]) .+ @view(params.rhs.RHS_visc[:,:])
    end
    for ieq=1:neqs
        divide_by_mass_matrix!(@view(params.rhs.RHS[:,ieq]), params.vaux, params.Minv, neqs, npoin, AD)
    end
    
end

function inviscid_rhs_el!(u, params, connijk, x, y, lsource, SD::NSD_1D)
    
    u2uaux!(@view(params.uaux[:,:]), u, params.neqs, params.mesh.npoin)
    xmax = params.xmax
    xmin = params.xmin
    ymax = params.ymax    

    for iel=1:params.mesh.nelem
        for i=1:params.mesh.ngl
            ip = connijk[iel,i,1]
            
            user_flux!(@view(params.F[i,:]), @view(params.G[i,:]), SD,
                       @view(params.uaux[ip,:]),
                       @view(params.qp.qe[ip,:]),         #pref
                       params.mesh,
                       params.CL, params.SOL_VARS_TYPE;
                       neqs=params.neqs, ip=ip)
            
            if lsource
                user_source!(@view(params.S[i,:]),
                             @view(params.uaux[ip,:]),
                             @view(params.qp.qe[ip,:]),          #ρref 
                             params.mesh.npoin, params.CL, params.SOL_VARS_TYPE;
                             neqs=params.neqs, x=x[ip],y=y[ip],
                             xmax=xmax,xmin=xmin,ymax=ymax)
            end
        end
        
        _expansion_inviscid!(u, params, iel, params.CL, params.QT, SD, params.AD)
        
    end
end

function inviscid_rhs_el!(u, uprimitive, params,
                          connijk,
                          F, G, H, S,
                          qe,
                          x, y,
                          lsource, SD::NSD_2D;
                          xmin=0, xmax=1,
                          ymin=0, ymax=1,
                          zmin=0, zmax=1)
    
    u2uaux!(@view(params.uaux[:,:]), u, params.neqs, params.mesh.npoin)
   
    for iel = 1:params.mesh.nelem
        for j = 1:params.mesh.ngl, i=1:params.mesh.ngl
            ip = connijk[iel,i,j]
            
            user_flux!(@view(F[i,j,:]), @view(G[i,j,:]), SD,
                       @view(params.uaux[ip,:]),
                       @view(qe[ip,:]),         #pref
                       params.mesh,
                       params.CL, params.SOL_VARS_TYPE;
                       neqs=params.neqs, ip=ip)
            
            if lsource
                user_source!(@view(S[i,j,:]),
                             @view(params.uaux[ip,:]),
                             @view(qe[ip,:]),          #ρref 
                             params.mesh.npoin,
                             params.CL,
                             params.SOL_VARS_TYPE;
                             neqs=params.neqs,
                             x=x[ip], y=y[ip],
                             xmin=xmin, xmax=xmax,
                             ymin=ymin, ymax=ymax)
            end
        end

        _expansion_inviscid!(u, uprimitive,
                             params.neqs, params.mesh.ngl,
                             params.basis.dψ, params.ω,
                             F, G, S,
                             params.metrics.Je,
                             params.metrics.dξdx,params.metrics.dξdy,
                             params.metrics.dηdx, params.metrics.dηdy,
                             params.rhs.rhs_el,
                             iel,
                             params.CL, params.QT, SD, params.AD)
        
    end
end


function inviscid_rhs_el!(u, uprimitive, params,
                          connijk,
                          F, G, H, S,
                          qe,
                          x, y,
                          lsource, SD::NSD_3D;
                          xmin=0, xmax=1,
                          ymin=0, ymax=1,
                          zmin=0, zmax=1)
    
    u2uaux!(@view(params.uaux[:,:]), u, params.neqs, params.mesh.npoin)
    
    for iel = 1:params.mesh.nelem
        
        for k = 1:params.mesh.ngl, j = 1:params.mesh.ngl, i=1:params.mesh.ngl
            ip = connijk[iel,i,j,k]
            
            user_flux!(@view(F[i,j,k,:]), @view(G[i,j,k,:]), @view(H[i,j,k,:]),
                       @view(params.uaux[ip,:]),
                       @view(qe[ip,:]),         #pref
                       params.mesh,
                       params.CL, params.SOL_VARS_TYPE;
                       neqs=params.neqs, ip=ip)
            
            if lsource
                user_source!(@view(S[i,j,k,:]),
                             @view(params.uaux[ip,:]),
                             @view(qe[ip,:]),          #ρref 
                             params.mesh.npoin,
                             params.CL,
                             params.SOL_VARS_TYPE;
                             neqs=params.neqs)
            end
        end

        _expansion_inviscid!(u, uprimitive,
                             params.neqs, params.mesh.ngl,
                             params.basis.dψ, params.ω,
                             F, G, H, S,
                             params.metrics.Je,
                             params.metrics.dξdx, params.metrics.dξdy, params.metrics.dξdz,
                             params.metrics.dηdx, params.metrics.dηdy, params.metrics.dηdz,
                             params.metrics.dζdx, params.metrics.dζdy, params.metrics.dζdz,
                             params.rhs.rhs_el, iel, params.CL, params.QT, SD, params.AD) 
    end
end


function viscous_rhs_el!(u, params, SD::NSD_2D)
    
    for iel=1:params.mesh.nelem
        
        uToPrimitives!(params.neqs, params.fluxes.uprimitive, u, params.qp.qe, params.mesh.connijk, params.mesh.ngl, params.mesh.npoin, params.inputs[:δtotal_energy], iel, params.PT, params.CL, params.SOL_VARS_TYPE, SD)

        for ieq in params.ivisc_equations
            _expansion_visc!(params.rhs.rhs_diffξ_el, params.rhs.rhs_diffη_el, params.fluxes.uprimitive, params.visc_coeff, params.ω, params.mesh.ngl, params.basis.dψ, params.metrics.Je, params.metrics.dξdx, params.metrics.dξdy, params.metrics.dηdx, params.metrics.dηdy, params.inputs, iel, ieq, params.QT, SD, params.AD)
        end
        
    end
    
    params.rhs.rhs_diff_el .= @views (params.rhs.rhs_diffξ_el .+ params.rhs.rhs_diffη_el)
    
end


function viscous_rhs_el!(u, params, SD::NSD_3D)
    
    for iel=1:params.mesh.nelem        
        uToPrimitives!(params.neqs, params.fluxes.uprimitive, u, params.qp.qe, params.mesh.connijk, params.mesh.ngl, params.mesh.npoin, params.inputs[:δtotal_energy], iel, params.PT, params.CL, params.SOL_VARS_TYPE, SD)
        for ieq in params.ivisc_equations
            _expansion_visc!(params.rhs.rhs_diffξ_el, params.rhs.rhs_diffη_el, params.rhs.rhs_diffζ_el, params.fluxes.uprimitive, 
                             params.visc_coeff, params.ω, params.mesh.ngl, params.basis.dψ, params.metrics.Je, params.metrics.dξdx, params.metrics.dξdy, params.metrics.dξdz, 
                             params.metrics.dηdx, params.metrics.dηdy, params.metrics.dηdz, params.metrics.dζdx,params.metrics.dζdy, params.metrics.dζdz, params.inputs, iel, ieq, params.QT, SD, params.AD)        
        end
    end
    
    params.rhs.rhs_diff_el .= @views (params.rhs.rhs_diffξ_el .+ params.rhs.rhs_diffη_el .+ params.rhs.rhs_diffζ_el)
    
end


function _expansion_inviscid!(u, params, iel, ::CL, QT::Inexact, SD::NSD_1D, AD::FD)
    
    for ieq = 1:params.neqs
        for i = 1:params.mesh.ngl
            ip = params.mesh.connijk[iel,i,1]
            if (ip < params.mesh.npoin)
                params.rhs.RHS[ip,ieq] = 0.5*(u[ip+1] - u[ip])/(params.mesh.Δx[ip])
            end
        end
    end
    nothing
end


function _expansion_inviscid!(u, params, iel, ::CL, QT::Inexact, SD::NSD_1D, AD::ContGal)
    
    for ieq = 1:params.neqs
        for i=1:params.mesh.ngl
            dFdξ = 0.0
            for k = 1:params.mesh.ngl
                dFdξ += params.basis.dψ[k,i]*params.F[k,ieq]
            end
            params.rhs.rhs_el[iel,i,ieq] -= params.ω[i]*dFdξ - params.ω[i]*params.S[i,ieq]
        end
    end
end


function _expansion_inviscid!(u, params, iel, ::CL, QT::Inexact, SD::NSD_2D, AD::FD) nothing end

function _expansion_inviscid!(u, uprimitive, neqs, ngl, dψ, ω, F, G, S, Je, dξdx, dξdy, dηdx, dηdy, rhs_el, iel, ::CL, QT::Inexact, SD::NSD_2D, AD::ContGal)
    
    for ieq=1:neqs
        for j=1:ngl
            for i=1:ngl
                ωJac = ω[i]*ω[j]*Je[iel,i,j]
                
                dFdξ = 0.0
                dFdη = 0.0
                dGdξ = 0.0
                dGdη = 0.0
                @turbo for k = 1:ngl
                    dFdξ += dψ[k,i]*F[k,j,ieq]
                    dFdη += dψ[k,j]*F[i,k,ieq]
                    
                    dGdξ += dψ[k,i]*G[k,j,ieq]
                    dGdη += dψ[k,j]*G[i,k,ieq]
                end
                dξdx_ij = dξdx[iel,i,j]
                dξdy_ij = dξdy[iel,i,j]
                dηdx_ij = dηdx[iel,i,j]
                dηdy_ij = dηdy[iel,i,j]
                
                dFdx = dFdξ*dξdx_ij + dFdη*dηdx_ij
                dGdx = dGdξ*dξdx_ij + dGdη*dηdx_ij

                dFdy = dFdξ*dξdy_ij + dFdη*dηdy_ij
                dGdy = dGdξ*dξdy_ij + dGdη*dηdy_ij
                
                auxi = ωJac*((dFdx + dGdy) - S[i,j,ieq])
                rhs_el[iel,i,j,ieq] -= auxi
            end
        end
    end
end


#function _expansion_inviscid!(u, params, iel, ::CL, QT::Inexact, SD::NSD_3D, AD::ContGal)
function _expansion_inviscid!(u, uprimitive, neqs, ngl, dψ, ω, F, G, H, S, Je, dξdx, dξdy, dξdz, dηdx, dηdy, dηdz, dζdx, dζdy, dζdz, rhs_el, iel, ::CL, QT::Inexact, SD::NSD_3D, AD::ContGal)
    for ieq=1:neqs
        for k=1:ngl
            for j=1:ngl
                for i=1:ngl
                    ωJac = ω[i]*ω[j]*ω[k]*Je[iel,i,j,k]
                    
                    dFdξ = 0.0
                    dFdη = 0.0
                    dFdζ = 0.0
                    
                    dGdξ = 0.0
                    dGdη = 0.0
                    dGdζ = 0.0

                    dHdξ = 0.0
                    dHdη = 0.0
                    dHdζ = 0.0
                    @turbo for m = 1:ngl
                        dFdξ += dψ[m,i]*F[m,j,k,ieq]
                        dFdη += dψ[m,j]*F[i,m,k,ieq]
                        dFdζ += dψ[m,k]*F[i,j,m,ieq]
                        
                        dGdξ += dψ[m,i]*G[m,j,k,ieq]
                        dGdη += dψ[m,j]*G[i,m,k,ieq]
                        dGdζ += dψ[m,k]*G[i,j,m,ieq]
                        
                        dHdξ += dψ[m,i]*H[m,j,k,ieq]
                        dHdη += dψ[m,j]*H[i,m,k,ieq]
                        dHdζ += dψ[m,k]*H[i,j,m,ieq]
                    end
                    dξdx_ij = dξdx[iel,i,j,k]
                    dξdy_ij = dξdy[iel,i,j,k]
                    dξdz_ij = dξdz[iel,i,j,k]
                    
                    dηdx_ij = dηdx[iel,i,j,k]
                    dηdy_ij = dηdy[iel,i,j,k]
                    dηdz_ij = dηdz[iel,i,j,k]

                    dζdx_ij = dζdx[iel,i,j,k]
                    dζdy_ij = dζdy[iel,i,j,k]
                    dζdz_ij = dζdz[iel,i,j,k]
                    
                    dFdx = dFdξ*dξdx_ij + dFdη*dηdx_ij + dFdζ*dζdx_ij
                    dGdx = dGdξ*dξdx_ij + dGdη*dηdx_ij + dGdζ*dζdx_ij
                    dHdx = dHdξ*dξdx_ij + dHdη*dηdx_ij + dHdζ*dζdx_ij

                    dFdy = dFdξ*dξdy_ij + dFdη*dηdy_ij + dFdζ*dζdy_ij
                    dGdy = dGdξ*dξdy_ij + dGdη*dηdy_ij + dGdζ*dζdy_ij
                    dHdy = dHdξ*dξdy_ij + dHdη*dηdy_ij + dHdζ*dζdy_ij
                    
                    dFdz = dFdξ*dξdz_ij + dFdη*dηdz_ij + dFdζ*dζdz_ij
                    dGdz = dGdξ*dξdz_ij + dGdη*dηdz_ij + dGdζ*dζdz_ij
                    dHdz = dHdξ*dξdz_ij + dHdη*dηdz_ij + dHdζ*dζdz_ij
                    
                    auxi = ωJac*((dFdx + dGdy + dHdz) - S[i,j,k,ieq])
                    rhs_el[iel,i,j,k,ieq] -= auxi
                end
            end
        end
    end
end

function _expansion_inviscid!(u, params, iel, ::NCL, QT::Inexact, SD::NSD_2D, AD::FD) nothing end

function _expansion_inviscid!(u, uprimitive, neqs, ngl, dψ, ω, F, G, S, Je, dξdx, dξdy, dηdx, dηdy, rhs_el, iel, ::NCL, QT::Inexact, SD::NSD_2D, AD::ContGal)
    
    for ieq=1:params.neqs
        for j=1:params.mesh.ngl
            for i=1:params.mesh.ngl
                ωJac = ω[i]*ω[j]*Je[iel,i,j]
                
                dFdξ = 0.0; dFdη = 0.0
                dGdξ = 0.0; dGdη = 0.0
                dpdξ = 0.0; dpdη = 0.0               
                for k = 1:params.mesh.ngl
                    dFdξ += dψ[k,i]*F[k,j,ieq]
                    dFdη += dψ[k,j]*F[i,k,ieq]
                    
                    dGdξ += dψ[k,i]*G[k,j,ieq]
                    dGdη += dψ[k,j]*G[i,k,ieq]
                    
                    dpdξ += dψ[k,i]*uprimitive[k,j,params.neqs+1]
                    dpdη += dψ[k,j]*uprimitive[i,k,params.neqs+1]
                end
                dξdx_ij = dξdx[iel,i,j]
                dξdy_ij = dξdy[iel,i,j]
                dηdx_ij = dηdx[iel,i,j]
                dηdy_ij = dηdy[iel,i,j]
                
                dFdx = dFdξ*dξdx_ij + dFdη*dηdx_ij            
                dFdy = dFdξ*dξdy_ij + dFdη*dηdy_ij

                dGdx = dGdξ*dξdx_ij + dGdη*dηdx_ij            
                dGdy = dGdξ*dξdy_ij + dGdη*dηdy_ij
                
                dpdx = dpdξ*dξdx_ij + dpdη*dηdx_ij            
                dpdy = dpdξ*dξdy_ij + dpdη*dηdy_ij

                ρij = uprimitive[i,j,1]
                uij = uprimitive[i,j,2]
                vij = uprimitive[i,j,3]
                
                if (ieq == 1)
                    auxi = ωJac*(dFdx + dGdy)
                elseif(ieq == 2)
                    auxi = ωJac*(uij*dFdx + vij*dGdy + dpdx/ρij)
                elseif(ieq == 3)
                    auxi = ωJac*(uij*dFdx + vij*dGdy + dpdy/ρij - S[i,j,ieq])
                elseif(ieq == 4)
                    auxi = ωJac*(uij*dFdx + vij*dGdy)
                end
                
                params.rhs.rhs_el[iel,i,j,ieq] -= auxi
            end
        end
    end        
end



function _expansion_visc!(rhs_diffξ_el, rhs_diffη_el, uprimitiveieq, visc_coeffieq, ω,
                          mesh, basis, metrics, inputs, iel, ieq, QT::Inexact, SD::NSD_2D, ::FD)
    nothing
end

function _expansion_visc!(rhs_diffξ_el, rhs_diffη_el, uprimitiveieq, visc_coeffieq, ω,
                          ngl, dψ, Je, dξdx, dξdy, dηdx, dηdy, inputs, iel, ieq, QT::Inexact, SD::NSD_2D, ::ContGal)
    
    for l = 1:ngl
        for k = 1:ngl
            ωJac = ω[k]*ω[l]*Je[iel,k,l]
            
            dqdξ = 0.0
            dqdη = 0.0
            @turbo for ii = 1:ngl
                dqdξ += dψ[ii,k]*uprimitiveieq[ii,l,ieq]
                dqdη += dψ[ii,l]*uprimitiveieq[k,ii,ieq]
            end
            dξdx_kl = dξdx[iel,k,l]
            dξdy_kl = dξdy[iel,k,l]
            dηdx_kl = dηdx[iel,k,l]
            dηdy_kl = dηdy[iel,k,l]
            
            auxi = dqdξ*dξdx_kl + dqdη*dηdx_kl
            dqdx = visc_coeffieq[ieq]*auxi
            
            auxi = dqdξ*dξdy_kl + dqdη*dηdy_kl
            dqdy = visc_coeffieq[ieq]*auxi
            
            ∇ξ∇u_kl = (dξdx_kl*dqdx + dξdy_kl*dqdy)*ωJac
            ∇η∇u_kl = (dηdx_kl*dqdx + dηdy_kl*dqdy)*ωJac     
            
            @turbo for i = 1:ngl
                dhdξ_ik = dψ[i,k]
                dhdη_il = dψ[i,l]
                
                rhs_diffξ_el[iel,i,l,ieq] -= dhdξ_ik * ∇ξ∇u_kl
                rhs_diffη_el[iel,k,i,ieq] -= dhdη_il * ∇η∇u_kl
            end
        end  
    end
end


function _expansion_visc!(rhs_diffξ_el, rhs_diffη_el, rhs_diffζ_el, uprimitiveieq, visc_coeffieq, ω, ngl, dψ, Je, dξdx, dξdy, dξdz, dηdx, dηdy, dηdz, dζdx, dζdy, dζdz, inputs, iel, ieq, QT::Inexact, SD::NSD_3D, ::ContGal)
   
    for m = 1:ngl
        for l = 1:ngl
            for k = 1:ngl
                ωJac = ω[k]*ω[l]*ω[m]*Je[iel,k,l,m]
                
                dqdξ = 0.0
                dqdη = 0.0
                dqdζ = 0.0
                @turbo for ii = 1:ngl
                    dqdξ += dψ[ii,k]*uprimitiveieq[ii,l,m,ieq]
                    dqdη += dψ[ii,l]*uprimitiveieq[k,ii,m,ieq]
                    dqdζ += dψ[ii,m]*uprimitiveieq[k,l,ii,ieq]
                end
                dξdx_klm = dξdx[iel,k,l,m]
                dξdy_klm = dξdy[iel,k,l,m]
                dξdz_klm = dξdz[iel,k,l,m]
                
                dηdx_klm = dηdx[iel,k,l,m]
                dηdy_klm = dηdy[iel,k,l,m]
                dηdz_klm = dηdz[iel,k,l,m]
                
                dζdx_klm = dζdx[iel,k,l,m]
                dζdy_klm = dζdy[iel,k,l,m]
                dζdz_klm = dζdz[iel,k,l,m]
                
                auxi = dqdξ*dξdx_klm + dqdη*dηdx_klm + dqdζ*dζdx_klm
                dqdx = visc_coeffieq[ieq]*auxi
                
                auxi = dqdξ*dξdy_klm + dqdη*dηdy_klm + dqdζ*dζdy_klm
                dqdy = visc_coeffieq[ieq]*auxi
                
                auxi = dqdξ*dξdz_klm + dqdη*dηdz_klm + dqdζ*dζdz_klm
                dqdz = visc_coeffieq[ieq]*auxi
                
                ∇ξ∇u_klm = (dξdx_klm*dqdx + dξdy_klm*dqdy + dξdz_klm*dqdz)*ωJac
                ∇η∇u_klm = (dηdx_klm*dqdx + dηdy_klm*dqdy + dηdz_klm*dqdz)*ωJac
                ∇ζ∇u_klm = (dζdx_klm*dqdx + dζdy_klm*dqdy + dζdz_klm*dqdz)*ωJac 
                
                @turbo for i = 1:ngl
                    dhdξ_ik = dψ[i,k]
                    dhdη_il = dψ[i,l]
                    dhdζ_im = dψ[i,m]
                    
                    rhs_diffξ_el[iel,i,l,m,ieq] -= dhdξ_ik * ∇ξ∇u_klm
                    rhs_diffη_el[iel,k,i,m,ieq] -= dhdη_il * ∇η∇u_klm
                    rhs_diffζ_el[iel,k,l,i,ieq] -= dhdζ_im * ∇ζ∇u_klm
                end
            end
        end
    end
end


function _expansion_visc!(rhs_diffξ_el, rhs_diffη_el, rhs_diffζ_el, uprimitiveieq, visc_coeffieq, ω,
                          mesh, basis, metrics, inputs, iel, ieq, QT::Inexact, SD::NSD_3D, ::ContGal)

    for m = 1:mesh.ngl
        for l = 1:mesh.ngl
            for k = 1:mesh.ngl
                ωJac = ω[k]*ω[l]*ω[m]*metrics.Je[iel,k,l,m]
                
                dqdξ = 0.0
                dqdη = 0.0
                dqdζ = 0.0
                @turbo for ii = 1:mesh.ngl
                    dqdξ += basis.dψ[ii,k]*uprimitiveieq[ii,l,m]
                    dqdη += basis.dψ[ii,l]*uprimitiveieq[k,ii,m]
                    dqdζ += basis.dψ[ii,m]*uprimitiveieq[k,l,ii]
                end
                dξdx_klm = metrics.dξdx[iel,k,l,m]
                dξdy_klm = metrics.dξdy[iel,k,l,m]
                dξdz_klm = metrics.dξdz[iel,k,l,m]
                
                dηdx_klm = metrics.dηdx[iel,k,l,m]
                dηdy_klm = metrics.dηdy[iel,k,l,m]
                dηdz_klm = metrics.dηdz[iel,k,l,m]
                
                dζdx_klm = metrics.dζdx[iel,k,l,m]
                dζdy_klm = metrics.dζdy[iel,k,l,m]
                dζdz_klm = metrics.dζdz[iel,k,l,m]
                
                auxi = dqdξ*dξdx_klm + dqdη*dηdx_klm + dqdζ*dζdx_klm
                dqdx = visc_coeffieq*auxi
                
                auxi = dqdξ*dξdy_klm + dqdη*dηdy_klm + dqdζ*dζdy_klm
                dqdy = visc_coeffieq*auxi
                
                auxi = dqdξ*dξdz_klm + dqdη*dηdz_klm + dqdζ*dζdz_klm
                dqdz = visc_coeffieq*auxi
                
                ∇ξ∇u_klm = (dξdx_klm*dqdx + dξdy_klm*dqdy + dξdz_klm*dqdz)*ωJac
                ∇η∇u_klm = (dηdx_klm*dqdx + dηdy_klm*dqdy + dηdz_klm*dqdz)*ωJac
                ∇ζ∇u_klm = (dζdx_klm*dqdx + dζdy_klm*dqdy + dζdz_klm*dqdz)*ωJac 
                
                @turbo for i = 1:mesh.ngl
                    dhdξ_ik = basis.dψ[i,k]
                    dhdη_il = basis.dψ[i,l]
                    dhdζ_im = basis.dψ[i,m]
                    
                    rhs_diffξ_el[i,l,m] -= dhdξ_ik * ∇ξ∇u_klm
                    rhs_diffη_el[k,i,m] -= dhdη_il * ∇η∇u_klm
                    rhs_diffζ_el[k,l,i] -= dhdζ_im * ∇ζ∇u_klm
                end
            end
        end
    end
end

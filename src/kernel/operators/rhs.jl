#---------------------------------------------------------------------------
# Optimized (more coud possibly be done)
#---------------------------------------------------------------------------
function build_rhs!(RHS, u, params, time)
    #
    # build_rhs()! is called by TimeIntegrators.jl -> time_loop!() via ODEProblem(rhs!, u, tspan, params)
    #
    _build_rhs!(RHS, u, params, time)
    
end

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
    fill!(params.rhs_el, zero(params.T))   
    fill!(params.RHS,    zero(params.T))
end

function resetRHSToZero_viscous!(params)
    fill!(params.rhs_diff_el,  zero(params.T))
    fill!(params.rhs_diffξ_el, zero(params.T))
    fill!(params.rhs_diffη_el, zero(params.T))
    fill!(params.RHS_visc,     zero(params.T))
end


function uToPrimitives!(uprimitive, u, mesh, δtotal_energy, iel)

    PhysConst = PhysicalConst{Float64}()

    for j=1:mesh.ngl, i=1:mesh.ngl
        
        m1 = mesh.connijk[iel,i,j]
        m2 = mesh.npoin + m1
        m3 = 2*mesh.npoin + m1
        m4 = 3*mesh.npoin + m1
        
        uprimitive[i,j,1] = u[m1]
        uprimitive[i,j,2] = u[m2]/u[m1]
        uprimitive[i,j,3] = u[m3]/u[m1]
        uprimitive[i,j,4] = u[m4]/u[m1] - δtotal_energy*0.5*(uprimitive[i,j,2]^2 + uprimitive[i,j,3]^2)

        #Pressure:
        uprimitive[i,j,end] = perfectGasLaw_ρθtoP(PhysConst, ρ=uprimitive[i,j,1], θ=uprimitive[i,j,4])
        
    end
    
end


function rhs!(du, u, params, time)
    
    build_rhs!(@view(params.RHS[:,:]), u, params, time)
    
    RHStoDU!(du, @view(params.RHS[:,:]), params.neqs, params.mesh.npoin)
end


function _build_rhs!(RHS, u, params, time)

    T       = Float64
    SD      = params.SD
    QT      = params.QT
    CL      = params.CL
    neqs    = params.neqs
    ngl     = params.mesh.ngl
    nelem   = params.mesh.nelem
    npoin   = params.mesh.npoin
    
    #-----------------------------------------------------------------------------------
    # Inviscid rhs:
    #-----------------------------------------------------------------------------------    
    resetRHSToZero_inviscid!(params) 
    
    inviscid_rhs_el!(u, params, true, SD)
    
    apply_boundary_conditions!(u, params.uaux, time,
                               params.mesh, params.metrics, params.basis,
                               params.rhs_el, params.ubdy,
                               params.ω, SD, neqs, params.inputs)
    
    DSS_rhs!(@view(params.RHS[:,:]), @view(params.rhs_el[:,:,:,:]), params.mesh, nelem, ngl, neqs, SD)
    
    #-----------------------------------------------------------------------------------
    # Viscous rhs:
    #-----------------------------------------------------------------------------------
    if (params.inputs[:lvisc] == true)

        resetRHSToZero_viscous!(params)
        
        viscous_rhs_el!(u, params, SD)
        
        DSS_rhs!(@view(params.RHS_visc[:,:]), @view(params.rhs_diff_el[:,:,:,:]), params.mesh, nelem, ngl, neqs, SD)
        
        params.RHS[:,:] .= @view(params.RHS[:,:]) .+ @view(params.RHS_visc[:,:])
    end
    
    divive_by_mass_matrix!(@view(params.RHS[:,:]), @view(params.M[:]), QT, neqs)
    
end


function inviscid_rhs_el!(u, params, lsource, SD::NSD_2D)
    
    u2uaux!(@view(params.uaux[:,:]), u, params.neqs, params.mesh.npoin)
    
    for iel=1:params.mesh.nelem
        
        uToPrimitives!(params.uprimitive, u, params.mesh, params.inputs[:δtotal_energy], iel)
        
        for j=1:params.mesh.ngl, i=1:params.mesh.ngl
            ip = params.mesh.connijk[iel,i,j]
            
            user_flux!(@view(params.F[i,j,:]), @view(params.G[i,j,:]), SD,
                       @view(params.uaux[ip,:]), 
                       params.qe[ip,end],         #pref
                       params.mesh; neqs=params.neqs)
            
            if lsource
                user_source!(@view(params.S[i,j,:]),
                             @view(params.uaux[ip,:]),
                             params.qe[ip,1],          #ρref 
                             params.mesh.npoin; neqs=params.neqs)
            end
        end
        
        for ieq = 1:params.neqs        
            _expansion_inviscid!(@view(params.rhs_el[iel,:,:,ieq]), params.uprimitive, params.mesh, params.metrics, params.basis,
                                 @view(params.F[:,:,ieq]), @view(params.G[:,:,ieq]), @view(params.S[:,:,ieq]),
                                 params.ω, params.mesh.ngl, params.mesh.npoin, params.neqs, ieq, iel,
                                 params.CL, params.QT, SD)
        end
    end
end

function viscous_rhs_el!(u, params, SD::NSD_2D)
    
    for iel=1:params.mesh.nelem
        
        uToPrimitives!(params.uprimitive, u, params.mesh, params.inputs[:δtotal_energy], iel)

        for ieq=2:params.neqs
            _expansion_visc!(@view(params.rhs_diffξ_el[iel,:,:,ieq]), @view(params.rhs_diffη_el[iel,:,:,ieq]), @view(params.uprimitive[:,:,ieq]), params.visc_coeff[ieq], params.ω, params.mesh, params.basis, params.metrics, params.inputs, iel, ieq, params.QT, SD)
        end
        
    end
    params.rhs_diff_el .= @views (params.rhs_diffξ_el .+ params.rhs_diffη_el)
end


function _expansion_inviscid!(rhs_el, uprimitive, mesh, metrics, basis, F, G, S, ω, ngl, npoin, neqs, ieq, iel, ::NCL, QT::Inexact, SD::NSD_2D)

    dpdxflg = 0.0
    dpdyflg = 0.0
    if (ieq == 2)       
        dpdxflg = 1
    elseif (ieq == 3)
        dpdyflg = 1
    end

    
    for j=1:ngl
        for i=1:ngl
            Fρ[i,j] = uprimitive[k,j,2]*uprimitive[k,j,1]
            Gρ[i,j] = uprimitive[k,j,3]*uprimitive[k,j,1]
        end
    end
    
    for j=1:ngl
        for i=1:ngl
            ωJac = ω[i]*ω[j]*metrics.Je[iel,i,j]

            dqdξ = 0.0
            dqdη = 0.0

            #= dρdξ = 0.0
            dρdη = 0.0
            dudξ = 0.0
            dudη = 0.0
            dvdξ = 0.0
            dvdη = 0.0
            dθdξ = 0.0
            dθdη = 0.0
            dpdξ = 0.0
            dpdη = 0.0=#
            @turbo for k = 1:ngl
                
                dFρdξ += basis.dψ[k,i]*Fρ[k,j]
                dFρdη += basis.dψ[k,j]*Fρ[i,k]
                
                dGρdξ += basis.dψ[k,i]*Gρ[k,j]
                dGρdη += basis.dψ[k,j]*Gρ[i,k]
                
                dqdξ += basis.dψ[k,i]*uprimitive[k,j,ieq]
                dqdη += basis.dψ[k,j]*uprimitive[i,k,ieq]
                
                #=
                dudξ += basis.dψ[k,i]*uprimitive[k,j,2]
                dudη += basis.dψ[k,j]*uprimitive[i,k,2]
                
                dvdξ += basis.dψ[k,i]*uprimitive[k,j,3]
                dvdη += basis.dψ[k,j]*uprimitive[i,k,3]

                dθdξ += basis.dψ[k,i]*uprimitive[k,j,4]
                dθdη += basis.dψ[k,j]*uprimitive[i,k,4]=#
                
                dpdξ += basis.dψ[k,i]*uprimitive[k,j,end]
                dpdη += basis.dψ[k,j]*uprimitive[i,k,end]
            end
            dξdx_ij = metrics.dξdx[iel,i,j]
            dξdy_ij = metrics.dξdy[iel,i,j]
            dηdx_ij = metrics.dηdx[iel,i,j]
            dηdy_ij = metrics.dηdy[iel,i,j]

            dqdx = dqdξ*dξdx_ij + dqdη*dηdx_ij            
            dqdy = dqdξ*dξdy_ij + dqdη*dηdy_ij
            
            #=dρdx = dρdξ*dξdx_ij + dρdη*dηdx_ij
            dudx = dudξ*dξdx_ij + dudη*dηdx_ij
            dvdx = dvdξ*dξdx_ij + dvdη*dηdx_ij
            dθdx = dθdξ*dξdx_ij + dθdη*dηdx_ij
            
            dρdy = dρdξ*dξdy_ij + dρdη*dηdy_ij
            dudy = dudξ*dξdy_ij + dudη*dηdy_ij
            dvdy = dvdξ*dξdy_ij + dvdη*dηdy_ij
            dθdy = dθdξ*dξdy_ij + dθdη*dηdy_ij=#
            
            ρij = uprimitives[i,j,1]
            uij = uprimitives[i,j,2]
            vij = uprimitives[i,j,3]
            if (ieq == 1)
                auxi = ωJac*((dFρdx + dGρdy))
            elseif(ieq == 2)
                auxi = ωJac*((uij*dFdx + vij*dGdy + dpdxflg*dpdx/ρij + dpdxflg*dpdy/ρij) - S[i,j])
            elseif(ieq == 3)

            elseif(ieq == 4)
                
            end
                
            rhs_el[i,j] -= auxi
        end
    end
    
end

function _expansion_inviscid!(rhs_el, uprimitiveieq, mesh, metrics, basis, F, G, S, ω, ngl, npoin, neqs, ieq, iel, ::CL, QT::Inexact, SD::NSD_2D)
    
    for j=1:ngl
        for i=1:ngl
            ωJac = ω[i]*ω[j]*metrics.Je[iel,i,j]
            
            dFdξ = 0.0
            dFdη = 0.0
            dGdξ = 0.0
            dGdη = 0.0
            @turbo for k = 1:ngl
                dFdξ += basis.dψ[k,i]*F[k,j]
                dFdη += basis.dψ[k,j]*F[i,k]
                
                dGdξ += basis.dψ[k,i]*G[k,j]
                dGdη += basis.dψ[k,j]*G[i,k]
            end
            dξdx_ij = metrics.dξdx[iel,i,j]
            dξdy_ij = metrics.dξdy[iel,i,j]
            dηdx_ij = metrics.dηdx[iel,i,j]
            dηdy_ij = metrics.dηdy[iel,i,j]
            
            dFdx = dFdξ*dξdx_ij + dFdη*dηdx_ij
            dGdx = dGdξ*dξdx_ij + dGdη*dηdx_ij

            dFdy = dFdξ*dξdy_ij + dFdη*dηdy_ij
            dGdy = dGdξ*dξdy_ij + dGdη*dηdy_ij
            
            auxi = ωJac*((dFdx + dGdy) - S[i,j])
            rhs_el[i,j] -= auxi
        end
    end    
end


function _expansion_inviscid!(rhs_el, uprimitiveieq, mesh, metrics, basis, F, G, S, ω, ngl, npoin, neqs, ieq, iel, ::CL, QT::Exact, SD::NSD_2D)
    
    N = ngl
    Q = N + 1
    for l=1:Q
        for k=1:Q
            ωJac = ω[k]*ω[l]*metrics.Je[iel,k,l]
            
            dFdξ = 0.0
            dFdη = 0.0
            dGdξ = 0.0
            dGdη = 0.0
            for n = 1:N
                for m = 1:N
                    dFdξ += basis.dψ[m,k]* basis.ψ[n,l]*F[m,n]
                    dFdη +=  basis.ψ[m,k]*basis.dψ[n,l]*F[m,n]
                    
                    dGdξ += basis.dψ[m,k]* basis.ψ[n,l]*G[m,n]
                    dGdη +=  basis.ψ[m,k]*basis.dψ[n,l]*G[m,n]
                end
            end
            
            dξdx_kl = metrics.dξdx[iel,k,l]
            dξdy_kl = metrics.dξdy[iel,k,l]
            dηdx_kl = metrics.dηdx[iel,k,l]
            dηdy_kl = metrics.dηdy[iel,k,l]
            for j = 1:N
                for i = 1:N
                    #I = mesh.connijk[iel,i,j]
                    
                    dFdx = dFdξ*dξdx_kl + dFdη*dηdx_kl
                    dGdx = dGdξ*dξdx_kl + dGdη*dηdx_kl

                    dFdy = dFdξ*dξdy_kl + dFdη*dηdy_kl
                    dGdy = dGdξ*dξdy_kl + dGdη*dηdy_kl
                    
                    #auxi = ωJac*((dFdx + dGdy) - S[i,j])
                    auxi = ωJac*basis.ψ[i,k]*basis.ψ[j,l]*((dFdx + dGdy) - S[i,j])
                    rhs_el[i,j] -= auxi
                    #RHS[I] -= auxi
                end
            end
        end
    end    
end


function _expansion_visc!(rhs_diffξ_el, rhs_diffη_el, uprimitiveieq, visc_coeffieq, ω, mesh, basis, metrics, inputs, iel, ieq, QT::Inexact, SD::NSD_2D)
  
    for l = 1:mesh.ngl
        for k = 1:mesh.ngl
            ωJac = ω[k]*ω[l]*metrics.Je[iel,k,l]
            
            dudξ = 0.0
            dudη = 0.0
            @turbo for ii = 1:mesh.ngl
                dudξ += basis.dψ[ii,k]*uprimitiveieq[ii,l]
                dudη += basis.dψ[ii,l]*uprimitiveieq[k,ii]
            end
            dξdx_kl = metrics.dξdx[iel,k,l]
            dξdy_kl = metrics.dξdy[iel,k,l]
            dηdx_kl = metrics.dηdx[iel,k,l]
            dηdy_kl = metrics.dηdy[iel,k,l]
            
            auxi = dudξ*dξdx_kl + dudη*dηdx_kl
            dudx = visc_coeffieq*auxi
            
            auxi = dudξ*dξdy_kl + dudη*dηdy_kl
            dudy = visc_coeffieq*auxi
            
            ∇ξ∇u_kl = (dξdx_kl*dudx + dξdy_kl*dudy)*ωJac
            ∇η∇u_kl = (dηdx_kl*dudx + dηdy_kl*dudy)*ωJac     
            
            @turbo for i = 1:mesh.ngl
                dhdξ_ik = basis.dψ[i,k]
                dhdη_il = basis.dψ[i,l]
                
                rhs_diffξ_el[i,l] -= dhdξ_ik * ∇ξ∇u_kl
                rhs_diffη_el[k,i] -= dhdη_il * ∇η∇u_kl
            end
        end
    end  
end

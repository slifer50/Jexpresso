function initialize(SD::NSD_1D, PT::CompEuler, mesh::St_mesh, inputs::Dict, OUTPUT_DIR::String, TFloat)
    """

    """
    @info " Initialize fields for 1D CompEuler equations ........................ "

    PhysConst = PhysicalConst{Float64}()
    
    q = define_q(SD, mesh.nelem, mesh.npoin, mesh.ngl, TFloat; neqs=3)
    
    case = "sod"
    if (case === "sod")
        @info " Sod tube"

        ρL, uL, pL = 1.000, 0.0, 1.0
        ρR, uR, pR = 0.125, 0.0, 0.1
        xshock_initial = 0.5
        
    	for iel_g = 1:mesh.nelem
            for i=1:mesh.ngl
                
                ip = mesh.connijk[i,iel_g]
                x  = mesh.x[ip]
                
                if (x < xshock_initial)
                    ρ = ρL
                    u = uL
                    p = pL
                else
                    ρ = ρR
                    u = uR
                    p = pR
                end
                q.qn[ip,1] = ρ                       #ρ
                q.qn[ip,2] = ρ*u                     #ρu
                q.qn[ip,3] = p/(PhysConst.γ - 1.0) + 0.5*ρ*u*u #ρE
                
            end
        end
    else
        error(" ERROR: CompEuler: initialize.jl: no initial conditions assigned")
    end
    

    @info "Initialize fields for system of 1D CompEuler equations ........................ DONE"

    return q
end

function initialize(SD::NSD_2D, PT::CompEuler, mesh::St_mesh, inputs::Dict, OUTPUT_DIR::String, TFloat)
    """

    """
    @info " Initialize fields for 1D CompEuler equations ........................ "
    
    PhysConst = PhysicalConst{Float64}()
    
    q = define_q(SD, mesh.nelem, mesh.npoin, mesh.ngl, TFloat; neqs=4)

    case = "sod"
    if (case === "sod")
        @info " Sod tube"
        
        ρL, uL, vL, pL = 1.000, 0.0, 0.0, 1.0
        ρR, uR, vR, pR = 0.125, 0.0, 0.0, 0.1
        xshock_initial = 0.5
        
    	for iel_g = 1:mesh.nelem
            for j=1:mesh.ngl               
                for i=1:mesh.ngl
                    
                    ip = mesh.connijk[i,j,iel_g]
                    x  = mesh.x[ip]
                    
                    if (x < xshock_initial)
                        ρ = ρL
                        u = uL
                        v = vL
                        p = pL
                    else
                        ρ = ρR
                        u = uR                        
                        v = vR
                        p = pR
                    end
                    
                    q.qn[ip,1] = ρ                               #ρ
                    q.qn[ip,2] = ρ*u                             #ρu
                    q.qn[ip,3] = ρ*v                             #ρv
                    q.qn[ip,4] = p/(PhysConst.γ - 1.0) + 0.5*ρ*(u*u + v*v) #ρE
                    
                end
            end
        end
    else
        error(" ERROR: CompEuler: initialize.jl: no initial conditions assigned")
    end
    

    @info "Initialize fields for system of 1D CompEuler equations ........................ DONE"

    return q
end

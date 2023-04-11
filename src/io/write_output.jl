using LinearSolve
using SnoopCompile
using WriteVTK
import SciMLBase

include("./plotting/jeplots.jl")

abstract type AbstractOutFormat end
struct PNG <: AbstractOutFormat end
struct ASCII <: AbstractOutFormat end 

#----------------------------------------------------------------------------------------------------------------------------------------------
# ∂q/∂t = RHS -> q(x,t)
#----------------------------------------------------------------------------------------------------------------------------------------------
# PNG
function write_output(sol::ODESolution, SD::NSD_3D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::PNG; nvar=1) nothing end
function write_output(sol::ODESolution, SD::NSD_2D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::PNG; nvar=1)
    println(string(" # Writing output to PNG file:", OUTPUT_DIR, "*.png ...  "))
    
    if inputs[:lplot_surf3d]
        for iout = 1:inputs[:ndiagnostics_outputs]
            title = @sprintf "Tracer: final solution at t=%6.4f" sol.t[iout]
            plot_surf3d(SD, mesh, sol.u[iout][:], title, OUTPUT_DIR; iout=iout, nvar=nvar, smoothing_factor=inputs[:smoothing_factor])
        end
    else
        for iout = 1:inputs[:ndiagnostics_outputs]
            title = @sprintf "Tracer: final solution at t=%6.4f" sol.t[iout]
            plot_triangulation(SD, mesh, sol.u[iout][:], title,  OUTPUT_DIR; iout=iout, nvar=nvar)
        end
    end
    println(string(" # Writing output to PNG file:", OUTPUT_DIR, "*.png ...  DONE"))
end
function write_output(sol::ODESolution, SD::NSD_1D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::PNG; nvar=1)
    
    println(string(" # Writing output to PNG file:", OUTPUT_DIR, "*.png ...  "))
    for iout = 1:inputs[:ndiagnostics_outputs]
        title = string("sol.u at time ", sol.t[iout])
        plot_results(SD, mesh, sol.u[iout][:], title, OUTPUT_DIR; iout=iout, nvar=nvar)
    end
    println(string(" # Writing output to PNG file:", OUTPUT_DIR, "*.png ...  DONE ") )
end

# ASCII
function write_output(sol::ODESolution, SD::NSD_1D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::ASCII; nvar=1)
    println(string(" # Writing output to ASCII file:", OUTPUT_DIR, "*.dat ...  ") )
    for iout = 1:inputs[:ndiagnostics_outputs]
        title = string("sol.u at time ", sol.t[iout])

        for ivar=1:nvar
            fout_name = string(OUTPUT_DIR, "/ivar", ivar, "-it", iout, ".dat")
            open(fout_name, "w") do f
                idx = (ivar - 1)*mesh.npoin
                for ip = (ivar-1)*mesh.npoin+1:ivar*mesh.npoin
                    @printf(f, " %f \n", sol.u[iout][ip])
                end
            end
        end
        #write_ascii(SD, mesh.x, sol.u[iout][:], title, OUTPUT_DIR; iout=iout, nvar=nvar)
    end
    println(string(" # Writing output to ASCII file:", OUTPUT_DIR, "*.dat ...  DONE ") )
end
function write_output(sol::ODESolution, SD::NSD_2D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::ASCII; nvar=1)
    
    println(string(" # Writing output to ASCII file:", OUTPUT_DIR, "*.dat ...  ") )
    for iout = 1: inputs[:ndiagnostics_outputs]
        #Write out data at final timestep
	fname = @sprintf "it-%d.dat" iout
    	open(string(OUTPUT_DIR, "/", fname), "w") do f
            for ip = 1:mesh.npoin
                @printf(f, " %d %.6f %.6f %.6f \n", ip, mesh.x[ip], mesh.y[ip], sol.u[iout][ip])
            end
        end #f
    end    
    println(string(" # Writing output to ASCII file:", OUTPUT_DIR, "*.dat ...  DONE ") ) 
end




#----------------------------------------------------------------------------------------------------------------------------------------------
# Aq = b -> q(x)
#----------------------------------------------------------------------------------------------------------------------------------------------
# PNG
function write_output(sol::SciMLBase.LinearSolution, SD::NSD_2D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::PNG; nvar=1)

    println(string(" # Writing output to PNG file:", OUTPUT_DIR, "*.png ...  ") )
    title = @sprintf "Solution to ∇⋅∇(q) = f"
    
    if inputs[:lplot_surf3d]
        plot_surf3d(SD, mesh, sol.u, title, OUTPUT_DIR; iout=1, nvar=1, smoothing_factor=inputs[:smoothing_factor])
    else
        plot_triangulation(SD, mesh, sol.u, title, OUTPUT_DIR;)
    end
    println(string(" # Writing output to PNG file:", OUTPUT_DIR, "*.png ...  DONE") )
end

# ASCII
function write_output(sol::SciMLBase.LinearSolution, SD::NSD_1D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::ASCII; nvar=1) nothing end
function write_output(sol::SciMLBase.LinearSolution, SD::NSD_3D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::ASCII; nvar=1) nothing end
function write_output(sol::SciMLBase.LinearSolution, SD::NSD_2D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::ASCII; nvar=1)   
    println(string(" # Writing output to ASCII file:", OUTPUT_DIR, "*.dat ...  ") )
    title = @sprintf "Solution to ∇⋅∇(q) = f"
    fname = @sprintf "Axb.dat"
    open(string(OUTPUT_DIR, "/", fname), "w") do f
        for ip = 1:length(sol.u)
            @printf(f, " %d %.6f %.6f %.6f \n", ip, mesh.x[ip], mesh.y[ip], sol.u[ip])
        end #f
    end
    println(string(" # Writing output to ASCII file:", OUTPUT_DIR, "*.dat ...  DONE") )
end

function write_output(sol::SciMLBase.LinearSolution, SD::NSD_2D, mesh::St_mesh, OUTPUT_DIR::String, inputs::Dict, outformat::VTK; nvar=1)

    println(string(" # Writing output to VTK file:", OUTPUT_DIR, "*.vtu ...  ") )
    for iout = 1:inputs[:ndiagnostics_outputs]
        title = @sprintf " ∇²q = f"
        write_vtk(SD, mesh, sol.u, title, OUTPUT_DIR, inputs;)
    end
    println(string(" # Writing output to VTK file:", OUTPUT_DIR, "*.vtu ... DONE") )
end


#VTK:
function write_vtk(SD::NSD_2D, mesh::St_mesh, q::Array, title::String, OUTPUT_DIR::String, inputs::Dict; iout=1, nvar=1)
    #nothing

    npoin = floor(Int64, size(q, 1)/nvar)
    for ivar=1:nvar
        idx = (ivar - 1)*npoin
        
        fout_name = string(OUTPUT_DIR, "/ivar", ivar, "-it", iout, ".vtu")
        
        cells = [MeshCell(VTKCellTypes.VTK_VERTEX, (i, )) for i = 1:mesh.npoin]
        vtk_grid(fout_name, mesh.x[1:npoin], mesh.y[1:npoin], mesh.y*0.0, cells) do vtk
            vtk[string("q", ivar), VTKPointData()] = q[idx+1:ivar*npoin]
        end
    end
    
end

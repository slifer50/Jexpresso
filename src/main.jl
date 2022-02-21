#--------------------------------------------------------
# external packages
#--------------------------------------------------------
using Crayons.Box
using DifferentialEquations
using Gridap
using GridapGmsh
using MPI
using Revise

#Plots
using Plots
plotlyjs()

#Constants
const TInt   = Int8
const TFloat = Float64

#--------------------------------------------------------
# jexpresso modules
#--------------------------------------------------------
include("./IO/mod_inputs.jl")
include("./mesh/mod_mesh.jl")
include("./solver/mod_solution.jl")
#--------------------------------------------------------

#MPI.Init()
#comm = MPI.COMM_WORLD

#if MPI.Comm_rank(comm) == 0
    print(BLUE_FG(" #--------------------------------------------------------------------------------\n"))
    print(BLUE_FG(" # Welcome to ", RED_FG("jexpresso\n")))
    print(BLUE_FG(" # A Julia code to solve turbulence problems in the atmosphere\n"))


    #--------------------------------------------------------
    #User inputs:
    #--------------------------------------------------------
    inputs, nvars = mod_inputs_user_inputs(TInt, TFloat)
    
    #--------------------------------------------------------
    #Print inputs to screen
    #--------------------------------------------------------
    #=
    NOTE: SM
    ADD HERE A FUNCTION TO CHECK IF SOME NECESSARY INPUTS WERE NOT DEFINED
    THINK OF A WAY TO CREATE A DYNAMIC INPUT SETUP to make the inputs list flexible.
    =#
    println( " #--------------------------------------------------------------------------------")
    print(GREEN_FG(" # User inputs:\n"))
    println( " # Equation set:  ", inputs[:equation_set])
    println( " # Problem:       ", inputs[:problem])
    println( " # N. variables:  ", nvars)
    println( " # N. space dims: ", inputs[:nsd])
    println( " # N. x-points:   ", inputs[:npx])
    println( " # [xmin, xmax]:  ", inputs[:xmin], " ", inputs[:xmax])
    if (inputs[:nsd] > 1)
        println( " # N. y-points:   ", inputs[:npy])
        println( " # [ymin, ymax]:  ", inputs[:ymin], " ", inputs[:ymax])
    end
    if (inputs[:nsd] == 3)
        println( " # N. z-points:   ", inputs[:npz])
        println( " # [zmin, zmax]:  ", inputs[:zmin], " ", inputs[:zmax])
    end

    #--------------------------------------------------------
    # Build mesh    
    #--------------------------------------------------------
    #
    # Initialize mesh struct
    mesh = St_mesh{TInt,TFloat}(zeros(inputs[:npx]), zeros(inputs[:npy]), zeros(inputs[:npz]),
                                 inputs[:xmin], inputs[:xmax],
                                 inputs[:ymin], inputs[:ymax],
                                 inputs[:zmin], inputs[:zmax],
                                 inputs[:npx], inputs[:npy], inputs[:npz])

    # Create mesh
    mod_mesh_build_mesh2d!(mesh)
    #--------------------------------------------------------
    # END Build mesh    
    #--------------------------------------------------------

    #--------------------------------------------------------
    # Initialize solution struct
    #--------------------------------------------------------
    #
    # Initlaize solution struct
   qs = St_solution{TInt,TFloat}(zeros(TFloat, nvars, inputs[:npx]*inputs[:npy]*inputs[:npz]),
                                   zeros(TFloat, nvars, inputs[:npx]*inputs[:npy]*inputs[:npz]),
                                   zeros(TFloat, nvars, inputs[:npx]*inputs[:npy]*inputs[:npz]),
                                   zeros(TFloat, nvars, inputs[:npx]*inputs[:npy]*inputs[:npz]),
                                   zeros(TFloat, nvars, inputs[:npx]*inputs[:npy]*inputs[:npz]),
                                   zeros(TFloat, inputs[:nsd]*inputs[:nsd]))


    # Build initial conditions
    mod_solution_initial_conditions!(mesh,
                                     qs,
                                     inputs[:nsd],
                                     inputs[:npx], inputs[:npy], inputs[:npz],
                                     inputs[:problem])


#end #main
#MPI.Barrier(comm)
#MPI.Finalize()

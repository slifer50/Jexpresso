var documenterSearchIndex = {"docs":
[{"location":"Expansion inviscid/#_expansion_inviscid!","page":"_expansion_inviscid!","title":"_expansion_inviscid!","text":"","category":"section"},{"location":"Expansion inviscid/","page":"_expansion_inviscid!","title":"_expansion_inviscid!","text":"Jexpresso._expansion_inviscid! - Method_expansion_inviscid!(u, params, iel, ::CL, QT::Exact, SD::NSD_2D, AD::ContGal)text for the documenter here [insert purpose or description].Parameters- `u`: [Description of u]\n- `params`: [Description of params]\n- `iel`: [Description of iel]\n- `::CL`: [Description of CL]\n- `QT::Exact`: [Description of QT::Exact]\n- `SD::NSD_2D`: [Description of SD::NSD_2D]\n- `AD::ContGal`: [Description of AD::ContGal]Usage# Example usage of `_expansion_inviscid!`\n_expansion_inviscid!(u, params, iel, ::CL, QT::Exact, SD::NSD_2D, AD::ContGal)\n\nadd text here of examples\n","category":"page"},{"location":"Build rhs/#_build_rhs!","page":"_build_rhs!","title":"_build_rhs!","text":"","category":"section"},{"location":"Build rhs/","page":"_build_rhs!","title":"_build_rhs!","text":"_build_rhs!(RHS, u, params, time)","category":"page"},{"location":"Build rhs/#Jexpresso._build_rhs!-NTuple{4, Any}","page":"_build_rhs!","title":"Jexpresso._build_rhs!","text":"_build_rhs!(RHS, u, params, time)\n\nAdd text here for the documenter.\n\nParameters\n\n- `RHS`: Description of `RHS`.\n- `u`: Description of `u`.\n- `params`: Description of `params`.\n- `time`: Description of `time`.\n\nUsage\n\n# Example usage of `_build_rhs!`\n_build_rhs!(RHS, u, params, time)\nadd here the text for examples\n\n\n\n\n\n","category":"method"},{"location":"Performance Comparison/#Performance-Comparison-of-Jexpresso-vs-legacy-Fortran-code","page":"Performance Comparison","title":"Performance Comparison of Jexpresso vs legacy Fortran code","text":"","category":"section"},{"location":"Performance Comparison/","page":"Performance Comparison","title":"Performance Comparison","text":"This document compares the performance of Jexpresso against a legacy Fortran code for numerical weather prediction, focusing on wall clock times for a rising-thermal-bubble test.","category":"page"},{"location":"Performance Comparison/","page":"Performance Comparison","title":"Performance Comparison","text":"","category":"page"},{"location":"Performance Comparison/#TABLES","page":"Performance Comparison","title":"TABLES","text":"","category":"section"},{"location":"Performance Comparison/#Wall-Clock-Time-Comparison-for-Simulated-100-Seconds","page":"Performance Comparison","title":"Wall Clock Time Comparison for Simulated 100 Seconds","text":"","category":"section"},{"location":"Performance Comparison/","page":"Performance Comparison","title":"Performance Comparison","text":"Time integrator max Δt (s) Effective resolution (m) Order Jexpresso (s) F90 (s)\nSSPRK33/RK33 0.2 125times 125 4 9.75 9.2028\nSSPRK53/RK35 0.3 125times 125 4 9.00 10.53\nSSPRK54 0.4 125times 125 4 10.47 -\nDP5 (Dormand-Prince RK54) 0.6 125times 125 4 19.80 -\nSSPRK73 0.4 125times 125 4 12.95 -\nSSPRK104 0.6 125times 125 4 12.50 -\nCarpenterKennedy2N54 0.4 125times 125 4 10.57 -\nTsit5 2.0 (adaptive) 125times 125 4 19.08 -","category":"page"},{"location":"Performance Comparison/","page":"Performance Comparison","title":"Performance Comparison","text":"Note: The wall clock times are to be taken with a ±0.2 due to a small variability from one simulation to the next one.","category":"page"},{"location":"Performance Comparison/#Comparison-for-t1000-Seconds-Without-Diagnostics-or-VTK-Writing","page":"Performance Comparison","title":"Comparison for t=1000 Seconds Without Diagnostics or VTK Writing","text":"","category":"section"},{"location":"Performance Comparison/","page":"Performance Comparison","title":"Performance Comparison","text":"Time integrator max Δt (s) Effective resolution (m) Order Jexpresso (s) F90 (s)\nSSPRK33/RK33 0.2 125times 125 4 57.36 57.00","category":"page"},{"location":"Performance Comparison/#Mass-Conservation-for-Advective-vs-Flux-Forms","page":"Performance Comparison","title":"Mass Conservation for Advective vs Flux Forms","text":"","category":"section"},{"location":"Performance Comparison/","page":"Performance Comparison","title":"Performance Comparison","text":"Time integrator Advection form Flux form\nSSPRK33 7622610626689869 times 10^-15 19545155453050947 times 10^-16\nSSPRK33 5081740417793246 times 10^-15 11727093271830568 times 10^-15\nMSRK5 7818062181220379 times 10^-16 39090310906101895 times 10^-16","category":"page"},{"location":"Performance Comparison/#Exact-vs-Inexact-Integration-for-Advection-and-Flux-Forms","page":"Performance Comparison","title":"Exact vs Inexact Integration for Advection and Flux Forms","text":"","category":"section"},{"location":"Performance Comparison/","page":"Performance Comparison","title":"Performance Comparison","text":"Time integrator Integration Type Advection form Flux form\nSSPRK33 Exact 4104482645140768 times 10^-15 4495385754201793 times 10^-15\nSSPRK33 Inexact 5081740417793246 times 10^-15 11727093271830568 times 10^-15","category":"page"},{"location":"Performance Comparison/","page":"Performance Comparison","title":"Performance Comparison","text":"","category":"page"},{"location":"#Documentation","page":"Index","title":"Documentation","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"CurrentModule = Jexpresso\nDocTestSetup = quote\n    using Jexpresso\nend","category":"page"},{"location":"","page":"Index","title":"Index","text":"     @missinginput","category":"page"},{"location":"#Jexpresso.@missinginput","page":"Index","title":"Jexpresso.@missinginput","text":"@missinginput \"Error message\"\n\nMacro used to raise an error, when something is not implemented.\n\n\n\n\n\n","category":"macro"},{"location":"#Jexpresso.jl","page":"Index","title":"Jexpresso.jl","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Documentation of Jexpresso.","category":"page"},{"location":"","page":"Index","title":"Index","text":"note: Note\nThis documentation is and will always be WIP!       A research software for the numerical solution of a system of an arbitrary number of conservation laws using continuous spectral elements. DISCLAIMER: this is WIP and only 2D is being maintained until parallelization is complete.","category":"page"},{"location":"#Equations:","page":"Index","title":"Equations:","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Jexpresso uses arbitrarily high-order (3rd and above) continuous spectral elements to solve","category":"page"},{"location":"","page":"Index","title":"Index","text":"fracpartial bf qpartial t + sum_i=1^ndnablacdotbf F_i(bf q) = munabla^2bf q + bf S(bf q) + rm bc","category":"page"},{"location":"","page":"Index","title":"Index","text":"where the vectors bf q, bf F, and bf S are problem-dependent as shown below, and are taken to be zero vectors of the appropriate size when not explicitly stated otherwise.","category":"page"},{"location":"","page":"Index","title":"Index","text":"The Julia package DifferentialEquations.jl is used for time discretization and stepping.","category":"page"},{"location":"","page":"Index","title":"Index","text":"In order, we provide tests and results for the following equations:","category":"page"},{"location":"","page":"Index","title":"Index","text":"1D wave equation:","category":"page"},{"location":"","page":"Index","title":"Index","text":"bf q=beginbmatrix\nu \nv\nendbmatrixquad bf F=beginbmatrix\nv\nu\nendbmatrix","category":"page"},{"location":"","page":"Index","title":"Index","text":"2: 1D shallow water:","category":"page"},{"location":"","page":"Index","title":"Index","text":"bf q=beginbmatrix\nh \nu\nendbmatrixquad bf F=beginbmatrix\nUh + Hu\ngh + Uu\nendbmatrix","category":"page"},{"location":"","page":"Index","title":"Index","text":"where H and U are a reference height and velocity, respectively.","category":"page"},{"location":"","page":"Index","title":"Index","text":"2D Helmholtz:","category":"page"},{"location":"","page":"Index","title":"Index","text":"bf S=beginbmatrix\nalpha^2 u + f(xz)\nendbmatrixquad munabla^2bf q=mubeginbmatrix\nu_xx + u_zz\nendbmatrix","category":"page"},{"location":"","page":"Index","title":"Index","text":"for a constant value of alpha and mu, which are case-dependent.","category":"page"},{"location":"","page":"Index","title":"Index","text":"2D scalar advection-diffusion:","category":"page"},{"location":"","page":"Index","title":"Index","text":"bf q=beginbmatrix\nq\nendbmatrixquad bf F=beginbmatrix\nqu\nendbmatrixquad bf F=beginbmatrix\nqv\nendbmatrixquad munabla^2bf q=mubeginbmatrix\nq_xx + q_zz\nendbmatrix","category":"page"},{"location":"","page":"Index","title":"Index","text":"2D Euler equations of compressible flows with gravity and N passive chemicals c_i forall i=1N ","category":"page"},{"location":"","page":"Index","title":"Index","text":"bf q=beginbmatrix\nrho \nrho u\nrho v\nrho theta\nrho c1\n\nrho cN\nendbmatrixquad bf F1=beginbmatrix\nrho u\nrho u^2 + p\nrho u v\nrho u theta\nrho u c1\n\nrho u cN\nendbmatrixquad bf F2=beginbmatrix\nrho v\nrho v u\nrho v^2 + p\nrho v theta\nrho v c1\n\nrho v cN\nendbmatrixquad bf S=beginbmatrix\n0\n0\n-rho g\n0\n0\n\n0\nendbmatrixquad munabla^2bf q=mubeginbmatrix\n0\nu_xx + u_zz\nv_xx + v_zz\ntheta_xx + theta_zz\nc1_xx + c1_zz\n\ncN_xx + cN_zz\nendbmatrix","category":"page"},{"location":"","page":"Index","title":"Index","text":"The equation of state for a perfect gas is used to close the system.","category":"page"},{"location":"","page":"Index","title":"Index","text":"If you are interested in contributing, please get in touch: Simone Marras, Yassine Tissaoui I WILL POINT YOU TO THE MOST EFFICIENT, but less general BRANCH OF THE CODE!","category":"page"},{"location":"#Some-notes-on-using-JEXPRESSO","page":"Index","title":"Some notes on using JEXPRESSO","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"To install and run the code assume Julia 1.9.3","category":"page"},{"location":"#Setup-with-CPUs","page":"Index","title":"Setup with CPUs","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":">> cd \\$JEXPRESSO_HOME\n>> julia --project=. -e \"using Pkg; Pkg.instantiate(); Pkg.API.precompile()\"","category":"page"},{"location":"","page":"Index","title":"Index","text":"followed by the following:","category":"page"},{"location":"","page":"Index","title":"Index","text":"Push problem name to ARGS You need to do this only when you run a new problem","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), EQUATIONS::String, EQUATIONS_CASE_NAME::String);\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"PROBLEMNAME is the name of your problem directory as $JEXPRESSO/problems/equations/problemname\nPROBLEMCASENAME is the name of the subdirectory containing the specific setup that you want to run: ","category":"page"},{"location":"","page":"Index","title":"Index","text":"The path would look like  \\$JEXPRESSO/problems/equations/PROBLEM_NAME/PROBLEM_CASE_NAME","category":"page"},{"location":"","page":"Index","title":"Index","text":"Example 1: to solve the 2D Euler equations with buyoancy and two passive tracers defined in problems/equations/CompEuler/thetaTracers you would do the following:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"thetaTracers\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/thetaTracersMesh.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 5px;\" />","category":"page"},{"location":"","page":"Index","title":"Index","text":"Example 2: to solve the 2D Euler equations leading to a density current defined in problems/equations/CompEuler/dc you would do the following:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"dc\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/dc.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Index","title":"Index","text":"Example 3: to solve the 1D wave equation  defined in problems/equations/CompEuler/wave1d you would do the following:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"wave1d\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/wave1d-v.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Index","title":"Index","text":"For ready to run tests, there are the currently available equations names:","category":"page"},{"location":"","page":"Index","title":"Index","text":"CompEuler (option with total energy and theta formulation)","category":"page"},{"location":"","page":"Index","title":"Index","text":"The code is designed to create any system of conservsation laws. See CompEuler/case1 to see an example of each file. Details will be given in the documentation (still WIP). Write us if you need help.","category":"page"},{"location":"","page":"Index","title":"Index","text":"More are already implemented but currently only in individual branches. They will be added to master after proper testing.","category":"page"},{"location":"#Laguerre-semi-infinite-element-test-suite","page":"Index","title":"Laguerre semi-infinite element test suite","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"This section contains instructions to run all of the test cases presented in","category":"page"},{"location":"","page":"Index","title":"Index","text":"@article{tissaoui2024,\n  doi = {},\n  url = {},\n  year = {2020},\n  volume = {},\n  number = {},\n  pages = {},\n  author = {Yassine Tissaoui and James F. Kelly and Simone Marras}\n  title = {Efficient Spectral Element Method for the Euler Equations on Unbounded Domains in Multiple Dimensions},\n  journal = {arXiv},\n}","category":"page"},{"location":"","page":"Index","title":"Index","text":"Test 1: 1D wave equation with Laguerre semi-infinite element absorbing layers","category":"page"},{"location":"","page":"Index","title":"Index","text":"The problem is defined in problems/CompEuler/wave1d_lag and by default output will be written to output/CompEuler/wave1d_lag. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"wave1d_lag\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/wavev4.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Index","title":"Index","text":"Test 2: 1D wave train for linearized shallow water equations","category":"page"},{"location":"","page":"Index","title":"Index","text":"The problem is defined in problems/equations/AdvDiff/Wave_Train and by default output will be written to output/AdvDiff/Wave_Train. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"AdvDiff\", \"Wave_Train\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/WaveTrainfinal.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Index","title":"Index","text":"A second version of this tests generate images with the solutions at different times overlapped.","category":"page"},{"location":"","page":"Index","title":"Index","text":"This version is defined in problems/equations/AdvDiff/Wave_Train_Overlapping_Plot and by default output will be written to output/AdvDiff/Wave_Train_Overlapping_Plot. To run this version of the problem execute the following from the Julia command line:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"AdvDiff\", \"Wave_Train_Overlapping_Plot\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/WaveTrainoverlap.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Index","title":"Index","text":"Test 3: 2D advection-diffusion equation","category":"page"},{"location":"","page":"Index","title":"Index","text":"The problem is defined in problems/equations/AdvDiff/2D_laguerre and by default output will be written to output/AdvDiff/2D_laguerre. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"AdvDiff\", \"2D_laguerre\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/ad2d-4s-line.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Index","title":"Index","text":"Test 4: 2D Helmholtz equation","category":"page"},{"location":"","page":"Index","title":"Index","text":"The problem is defined in problems/equations/Helmholtz/case1 and by default output will be written to output/Helmholtz/case1. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"Helmholtz\", \"case1\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/Helmholtzfromjexpresso-line.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Index","title":"Index","text":"Test 5: Rising thermal bubble","category":"page"},{"location":"","page":"Index","title":"Index","text":"The problem is defined in problems/equations/CompEuler/theta_laguerre and by default output will be written to output/CompEuler/theta_laguerre. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"theta_laguerre\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/48.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Index","title":"Index","text":"Test 6: Hydrostatic linear mountain waves","category":"page"},{"location":"","page":"Index","title":"Index","text":"The problem is defined in problems/equations/CompEuler/HSmount_Lag_working and by default output will be written to output/CompEuler/HSmount_Lag_working. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"HSmount_Lag_working\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Index","title":"Index","text":"<img src=\"assets/wvelo.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"#Plotting","page":"Index","title":"Plotting","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Files can be written to VTK (recommended) or png. For the png plots, we use Makie. If you want to use a different package, modify ./src/io/plotting/jplots.jl accordinly.","category":"page"},{"location":"","page":"Index","title":"Index","text":"For non-periodic 2D tests, the output can also be written to VTK files by setting the value \"vtk\" for the usier_input key :outformat","category":"page"},{"location":"#Contacts","page":"Index","title":"Contacts","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"[Simone Marras](mailto:smarras@njit.edu), [Yassine Tissaoui](mailto:yt277@njit.edu)","category":"page"},{"location":"#Manual","page":"Index","title":"Manual","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Pages = [\"Jexpresso.md\"]","category":"page"},{"location":"Jexpresso/#img-src\"https://github.com/smarras79/Jexpresso/blob/un/ci/assets/logo-ext2.png\"-width\"250\"-title\"JEXPRESSO-logo\"","page":"Jexpresso","title":"<img src=\"https://github.com/smarras79/Jexpresso/blob/un/ci/assets/logo-ext2.png\" width=\"250\" title=\"JEXPRESSO logo\">","text":"","category":"section"},{"location":"Jexpresso/","page":"Jexpresso","title":"Jexpresso","text":"the logo settings should be changed once it get pushed to the master","category":"page"},{"location":"Jexpresso/#Jexpresso","page":"Jexpresso","title":"Jexpresso","text":"","category":"section"},{"location":"Jexpresso/","page":"Jexpresso","title":"Jexpresso","text":"Jexpresso","category":"page"},{"location":"Jexpresso/#Jexpresso","page":"Jexpresso","title":"Jexpresso","text":"A research software for the numerical solution of a system of arbitrary conservation laws using continuous spectral elements.\n\nSuggested Julia version: 1.10\n\nIf you are interested in contributing, please get in touch. Simone Marras, Yassine Tissaoui\n\n\n\n\n\n","category":"module"},{"location":"Jexpresso/#Tables","page":"Jexpresso","title":"Tables","text":"","category":"section"},{"location":"Jexpresso/","page":"Jexpresso","title":"Jexpresso","text":"TABLES","category":"page"}]
}

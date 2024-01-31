var documenterSearchIndex = {"docs":
[{"location":"#Documentation","page":"Home","title":"Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = Jexpresso\nDocTestSetup = quote\n    using Jexpresso\nend","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Jexpresso]","category":"page"},{"location":"#Jexpresso.Jexpresso","page":"Home","title":"Jexpresso.Jexpresso","text":"A research software for the numerical solution of a system of an arbitrary number of conservation laws using continuous spectral elements. DISCLAIMER: this is WIP and only 2D is being maintained until parallelization is complete.\n\nIf you are interested in contributing, please get in touch. Simone Marras, Yassine Tissaoui\n\n\n\n\n\n","category":"module"},{"location":"#Jexpresso.@missinginput","page":"Home","title":"Jexpresso.@missinginput","text":"@missinginput \"Error message\"\n\nMacro used to raise an error, when something is not implemented.\n\n\n\n\n\n","category":"macro"},{"location":"#Jexpresso.jl","page":"Home","title":"Jexpresso.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation of Jexpresso.jl.","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: Note\nThis documentation is and will always be WIP!       A research software for the numerical solution of a system of an arbitrary number of conservation laws using continuous spectral elements. DISCLAIMER: this is WIP and only 2D is being maintained until parallelization is complete.","category":"page"},{"location":"#Equations:","page":"Home","title":"Equations:","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Jexpresso uses arbitrarily high-order (3rd and above) continuous spectral elements to solve","category":"page"},{"location":"","page":"Home","title":"Home","text":"fracpartial bf qpartial t + sum_i=1^ndnablacdotbf F_i(bf q) = munabla^2bf q + bf S(bf q) + rm bc","category":"page"},{"location":"","page":"Home","title":"Home","text":"where the vectors bf q, bf F, and bf S are problem-dependent as shown below, and are taken to be zero vectors of the appropriate size when not explicitly stated otherwise.","category":"page"},{"location":"","page":"Home","title":"Home","text":"The Julia package DifferentialEquations.jl is used for time discretization and stepping.","category":"page"},{"location":"","page":"Home","title":"Home","text":"In order, we provide tests and results for the following equations:","category":"page"},{"location":"","page":"Home","title":"Home","text":"1D wave equation:","category":"page"},{"location":"","page":"Home","title":"Home","text":"bf q=beginbmatrix\nu \nv\nendbmatrixquad bf F=beginbmatrix\nv\nu\nendbmatrix","category":"page"},{"location":"","page":"Home","title":"Home","text":"2: 1D shallow water:","category":"page"},{"location":"","page":"Home","title":"Home","text":"bf q=beginbmatrix\nh \nu\nendbmatrixquad bf F=beginbmatrix\nUh + Hu\ngh + Uu\nendbmatrix","category":"page"},{"location":"","page":"Home","title":"Home","text":"where H and U are a reference height and velocity, respectively.","category":"page"},{"location":"","page":"Home","title":"Home","text":"2D Helmholtz:","category":"page"},{"location":"","page":"Home","title":"Home","text":"bf S=beginbmatrix\nalpha^2 u + f(xz)\nendbmatrixquad munabla^2bf q=mubeginbmatrix\nu_xx + u_zz\nendbmatrix","category":"page"},{"location":"","page":"Home","title":"Home","text":"for a constant value of alpha and mu, which are case-dependent.","category":"page"},{"location":"","page":"Home","title":"Home","text":"2D scalar advection-diffusion:","category":"page"},{"location":"","page":"Home","title":"Home","text":"bf q=beginbmatrix\nq\nendbmatrixquad bf F=beginbmatrix\nqu\nendbmatrixquad bf F=beginbmatrix\nqv\nendbmatrixquad munabla^2bf q=mubeginbmatrix\nq_xx + q_zz\nendbmatrix","category":"page"},{"location":"","page":"Home","title":"Home","text":"2D Euler equations of compressible flows with gravity and N passive chemicals c_i forall i=1N ","category":"page"},{"location":"","page":"Home","title":"Home","text":"bf q=beginbmatrix\nrho \nrho u\nrho v\nrho theta\nrho c1\n\nrho cN\nendbmatrixquad bf F1=beginbmatrix\nrho u\nrho u^2 + p\nrho u v\nrho u theta\nrho u c1\n\nrho u cN\nendbmatrixquad bf F2=beginbmatrix\nrho v\nrho v u\nrho v^2 + p\nrho v theta\nrho v c1\n\nrho v cN\nendbmatrixquad bf S=beginbmatrix\n0\n0\n-rho g\n0\n0\n\n0\nendbmatrixquad munabla^2bf q=mubeginbmatrix\n0\nu_xx + u_zz\nv_xx + v_zz\ntheta_xx + theta_zz\nc1_xx + c1_zz\n\ncN_xx + cN_zz\nendbmatrix","category":"page"},{"location":"","page":"Home","title":"Home","text":"If you are interested in contributing, please get in touch: Simone Marras, Yassine Tissaoui I WILL POINT YOU TO THE MOST EFFICIENT, but less general BRANCH OF THE CODE!","category":"page"},{"location":"#Some-notes-on-using-JEXPRESSO","page":"Home","title":"Some notes on using JEXPRESSO","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"To install and run the code assume Julia 1.9.3","category":"page"},{"location":"#Setup-with-CPUs","page":"Home","title":"Setup with CPUs","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":">> cd $JEXPRESSO_HOME\n>> julia --project=. -e \"using Pkg; Pkg.instantiate(); Pkg.API.precompile()\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"followed by the following:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Push problem name to ARGS You need to do this only when you run a new problem","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), EQUATIONS::String, EQUATIONS_CASE_NAME::String);\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"PROBLEMNAME is the name of your problem directory as JEXPRESSO/problems/equations/problemname\nPROBLEMCASENAME is the name of the subdirectory containing the specific setup that you want to run: ","category":"page"},{"location":"","page":"Home","title":"Home","text":"The path would look like  $JEXPRESSO/problems/equations/PROBLEM_NAME/PROBLEM_CASE_NAME","category":"page"},{"location":"","page":"Home","title":"Home","text":"Example 1: to solve the 2D Euler equations with buyoancy and two passive tracers defined in problems/equations/CompEuler/thetaTracers you would do the following:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"thetaTracers\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/thetaTracersMesh.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 5px;\" />","category":"page"},{"location":"","page":"Home","title":"Home","text":"Example 2: to solve the 2D Euler equations leading to a density current defined in problems/equations/CompEuler/dc you would do the following:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"dc\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/dc.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Home","title":"Home","text":"Example 3: to solve the 1D wave equation  defined in problems/equations/CompEuler/wave1d you would do the following:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"wave1d\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/wave1d-v.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Home","title":"Home","text":"For ready to run tests, there are the currently available equations names:","category":"page"},{"location":"","page":"Home","title":"Home","text":"CompEuler (option with total energy and theta formulation)","category":"page"},{"location":"","page":"Home","title":"Home","text":"The code is designed to create any system of conservsation laws. See CompEuler/case1 to see an example of each file. Details will be given in the documentation (still WIP). Write us if you need help.","category":"page"},{"location":"","page":"Home","title":"Home","text":"More are already implemented but currently only in individual branches. They will be added to master after proper testing.","category":"page"},{"location":"#Laguerre-semi-infinite-element-test-suite","page":"Home","title":"Laguerre semi-infinite element test suite","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This section contains instructions to run all of the test cases presented in","category":"page"},{"location":"","page":"Home","title":"Home","text":"@article{tissaoui2024,\n  doi = {},\n  url = {},\n  year = {2020},\n  volume = {},\n  number = {},\n  pages = {},\n  author = {Yassine Tissaoui and James F. Kelly and Simone Marras}\n  title = {Efficient Spectral Element Method for the Euler Equations on Unbounded Domains in Multiple Dimensions},\n  journal = {arXiv},\n}","category":"page"},{"location":"","page":"Home","title":"Home","text":"Test 1: 1D wave equation with Laguerre semi-infinite element absorbing layers","category":"page"},{"location":"","page":"Home","title":"Home","text":"The problem is defined in problems/CompEuler/wave1d_lag and by default output will be written to output/CompEuler/wave1d_lag. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"wave1d_lag\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/wavev4.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Home","title":"Home","text":"Test 2: 1D wave train for linearized shallow water equations","category":"page"},{"location":"","page":"Home","title":"Home","text":"The problem is defined in problems/equations/AdvDiff/Wave_Train and by default output will be written to output/AdvDiff/Wave_Train. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"AdvDiff\", \"Wave_Train\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/WaveTrainfinal.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Home","title":"Home","text":"A second version of this tests generate images with the solutions at different times overlapped.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This version is defined in problems/equations/AdvDiff/Wave_Train_Overlapping_Plot and by default output will be written to output/AdvDiff/Wave_Train_Overlapping_Plot. To run this version of the problem execute the following from the Julia command line:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"AdvDiff\", \"Wave_Train_Overlapping_Plot\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/WaveTrainoverlap.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Home","title":"Home","text":"Test 3: 2D advection-diffusion equation","category":"page"},{"location":"","page":"Home","title":"Home","text":"The problem is defined in problems/equations/AdvDiff/2D_laguerre and by default output will be written to output/AdvDiff/2D_laguerre. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"AdvDiff\", \"2D_laguerre\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/ad2d-4s-line.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Home","title":"Home","text":"Test 4: 2D Helmholtz equation","category":"page"},{"location":"","page":"Home","title":"Home","text":"The problem is defined in problems/equations/Helmholtz/case1 and by default output will be written to output/Helmholtz/case1. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"Helmholtz\", \"case1\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/Helmholtzfromjexpresso-line.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Home","title":"Home","text":"Test 5: Rising thermal bubble","category":"page"},{"location":"","page":"Home","title":"Home","text":"The problem is defined in problems/equations/CompEuler/theta_laguerre and by default output will be written to output/CompEuler/theta_laguerre. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"theta_laguerre\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/48.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"","page":"Home","title":"Home","text":"Test 6: Hydrostatic linear mountain waves","category":"page"},{"location":"","page":"Home","title":"Home","text":"The problem is defined in problems/equations/CompEuler/HSmount_Lag_working and by default output will be written to output/CompEuler/HSmount_Lag_working. To solve this problem run the following commands from the Julia command line:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"HSmount_Lag_working\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/wvelo.png\"      alt=\"Markdown icon\"      style=\"float: left; margin-right: 7px;\" />","category":"page"},{"location":"#Plotting","page":"Home","title":"Plotting","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Files can be written to VTK (recommended) or png. For the png plots, we use Makie. If you want to use a different package, modify ./src/io/plotting/jplots.jl accordinly.","category":"page"},{"location":"","page":"Home","title":"Home","text":"For non-periodic 2D tests, the output can also be written to VTK files by setting the value \"vtk\" for the usier_input key :outformat","category":"page"},{"location":"#Contacts","page":"Home","title":"Contacts","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Simone Marras, Yassine Tissaoui","category":"page"},{"location":"#Manual","page":"Home","title":"Manual","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"Jexpresso.md\"]","category":"page"},{"location":"Jexpresso/#Jexpresso","page":"Jexpresso","title":"Jexpresso","text":"","category":"section"},{"location":"Jexpresso/","page":"Jexpresso","title":"Jexpresso","text":"Jexpresso","category":"page"},{"location":"Jexpresso/#Jexpresso","page":"Jexpresso","title":"Jexpresso","text":"A research software for the numerical solution of a system of an arbitrary number of conservation laws using continuous spectral elements. DISCLAIMER: this is WIP and only 2D is being maintained until parallelization is complete.\n\nIf you are interested in contributing, please get in touch. Simone Marras, Yassine Tissaoui\n\n\n\n\n\n","category":"module"}]
}

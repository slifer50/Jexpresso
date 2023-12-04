var documenterSearchIndex = {"docs":
[{"location":"#Documentation","page":"Home","title":"Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = Jexpresso\nDocTestSetup = quote\n    using Jexpresso\nend","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Jexpresso]","category":"page"},{"location":"#Jexpresso.Jexpresso","page":"Home","title":"Jexpresso.Jexpresso","text":"A research software for the numerical solution of a system of an arbitrary number of conservation laws using continuous spectral elements. DISCLAIMER: this is WIP and only 2D is being maintained until parallelization is complete.\n\nIf you are interested in contributing, please get in touch.\n\n\n\n\n\n","category":"module"},{"location":"#Jexpresso.@missinginput","page":"Home","title":"Jexpresso.@missinginput","text":"@missinginput \"Error message\"\n\nMacro used to raise an error, when something is not implemented.\n\n\n\n\n\n","category":"macro"},{"location":"#Jexpresso.jl","page":"Home","title":"Jexpresso.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation of Jexpresso.jl.","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: Note\nThis documentation is and will always be WIP!A research software for the numerical solution of a system of an arbitrary number of conservation laws using continuous spectral elements. DISCLAIMER: this is WIP and only 2D is being maintained until parallelization is complete.","category":"page"},{"location":"","page":"Home","title":"Home","text":"If you are interested in contributing, please get in touch: Simone Marras, Yassine Tissaoui","category":"page"},{"location":"#Some-notes-on-using-JEXPRESSO","page":"Home","title":"Some notes on using JEXPRESSO","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"To install and run the code assume Julia 1.9.3","category":"page"},{"location":"#Setup-with-CPUs","page":"Home","title":"Setup with CPUs","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":">> cd $JEXPRESSO_HOME\n>> julia --project=. -e \"using Pkg; Pkg.instantiate(); Pkg.API.precompile()\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"followed by the following:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Push equations name to ARGS You need to do this only when you run a new equations","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), EQUATIONS::String, EQUATIONS_CASE_NAME::String);\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"EQUATIONS is the name of your equations directory as JEXPRESSO/src/equations/equations\nEQUATIONSCASENAME is the name of the subdirectory containing the specific setup that you want to run: ","category":"page"},{"location":"","page":"Home","title":"Home","text":"The path would look like  $JEXPRESSO/src/equations/EQUATIONS/EQUATIONS_CASE_NAME","category":"page"},{"location":"","page":"Home","title":"Home","text":"For example, if you wanted to run CompEuler with the setup defined inside the case directory theta, then you would do the following:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> push!(empty!(ARGS), \"CompEuler\", \"theta\");\njulia> include(\"./src/Jexpresso.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"For ready to run tests, there are the currently available equations names:","category":"page"},{"location":"","page":"Home","title":"Home","text":"CompEuler (option with total energy and theta formulation)","category":"page"},{"location":"","page":"Home","title":"Home","text":"The code is designed to create any system of conservsation laws. See CompEuler/case1 to see an example of each file. Details will be given in the documentation (still WIP). Write us if you need help.","category":"page"},{"location":"","page":"Home","title":"Home","text":"More are already implemented but currently only in individual branches. They will be added to master after proper testing.","category":"page"},{"location":"#Plotting","page":"Home","title":"Plotting","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"For plotting we rely on Makie. If you want to use a different package, modify ./src/io/plotting/jplots.jl accordinly.","category":"page"},{"location":"","page":"Home","title":"Home","text":"For non-periodic 2D tests, the output can also be written to VTK files by setting the value \"vtk\" for the usier_input key :outformat","category":"page"},{"location":"#Manual","page":"Home","title":"Manual","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"Jexpresso.md\"]","category":"page"},{"location":"Jexpresso/#Jexpresso","page":"Jexpresso","title":"Jexpresso","text":"","category":"section"},{"location":"Jexpresso/","page":"Jexpresso","title":"Jexpresso","text":"Jexpresso","category":"page"},{"location":"Jexpresso/#Jexpresso","page":"Jexpresso","title":"Jexpresso","text":"A research software for the numerical solution of a system of an arbitrary number of conservation laws using continuous spectral elements. DISCLAIMER: this is WIP and only 2D is being maintained until parallelization is complete.\n\nIf you are interested in contributing, please get in touch.\n\n\n\n\n\n","category":"module"}]
}

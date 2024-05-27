using LinearSolve
using LinearSolve: solve
using SnoopCompile

function solveAx(L, RHS, backend, linear_solver...)
    
    @info linear_solver
    if !(backend == CPU())
        linear_solver = SimpleGMRES()
    end
    prob = LinearProblem(L, RHS);    
    sol = solve(prob, linear_solver)
    return sol
end

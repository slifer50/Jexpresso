using LinearSolve
using LinearSolve: solve
using SnoopCompile

function solveAx(L, RHS, linear_solver...)

    @info linear_solver
    
    prob = LinearProblem(L, RHS);    
    @time sol = solve(prob, linear_solver)

    return sol
end

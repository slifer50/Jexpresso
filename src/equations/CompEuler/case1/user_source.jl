function user_source!(S::SubArray{Float64}, q::SubArray{Float64}, npoin::Int64; neqs=1)

    S = zeros(T, npoin)
    
    #
    # S(q(x)) = βsin(γx)
    #
    β, γ = 10000, π;

    S = β*sin.(γ*x)
    
    return  S
    
end

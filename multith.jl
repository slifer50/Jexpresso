using Test
using ThreadsX
using Base.Threads
using DelimitedFiles
using JLD

function sum_single(a)
    s = 0
    for i in a
        s += i
    end
    s
end
sum_single(1:1_000_000)

function sum_multi_bad(a)
    s = 0
    Threads.@threads for i in a
        s += i
    end
    s
end
sum_multi_bad(1:1_000_000)

function sum_multi_good(a)
    chunks = Iterators.partition(a, length(a) ÷ Threads.nthreads())
    tasks = map(chunks) do chunk
        Threads.@spawn sum_single(chunk)
    end
    chunk_sums = fetch.(tasks)
    return sum_single(chunk_sums)
end
#sum_multi_good(1:1_000_000)

function main()

    ngl = 5
    nel = 1
        
    Me   = ones(Float64, ngl*ngl, ngl*ngl, nel)
    rhse = 2*ones(Float64, ngl, ngl, nel)
    np   = (nel*(ngl - 1) + 1)^2
    M    = zeros(np)
    RHS  = zeros(np)

    #conn = rand(range(1, np), nel, ngl, ngl)
    #save("conn.jld", "data", conn)
    conn = load("conn.jld")["data"]
    
    DSS_mass!(M, Me, nel, np, ngl, conn)
    DSS_rhs!(RHS, rhse, nel, ngl, conn)

    RHS
    
end


function DSS_rhs!(RHS, rhs_el, nelem, ngl, conn)
    
    for iel = 1:nelem
        for j = 1:ngl
            for i = 1:ngl
                I = conn[iel,i,j]
                RHS[I] += rhs_el[i,j,iel]
            end
        end
    end
end

function DSS_mass!(M, Mel::AbstractArray, nelem, npoin, ngl, conn)

    
    for iel=1:nelem
        for j = 1:ngl
            for i = 1:ngl
                J = i + (j - 1)*ngl
                JP = conn[iel,i,j]
                for n = 1:ngl
                    for m = 1:ngl
                        I = m + (n - 1)*ngl
                        IP = conn[iel,m,n]
                        M[IP] = M[IP] + Mel[I,J,iel]
                    end
                end
            end
        end    
    end
    
end

main()

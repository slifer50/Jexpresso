using Test
using Base.Threads
using Base.Threads: @spawn
using DelimitedFiles
using BenchmarkTools
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
        
    Me     = ones(Float64, ngl*ngl, ngl*ngl, nel)
    rhs_el = 2*ones(Float64, ngl, ngl, nel)
    np     = (nel*(ngl - 1) + 1)^2
    M      = zeros(np)
    RHS    = zeros(np)
    p = zeros(nthreads(), np)
    #conn = rand(range(1, np), nel, ngl, ngl);
    #save("conn.jld", "data", conn);
    conn = load("conn.jld")["data"];
    
    #@btime DSS_rhs!($RHS, $rhs_el, $nel, $ngl, $conn)
    #@info RHS
    println("--------------")
    #A = rand(10_000_000);
    #@btime sum($A)
    #@btime sum_thread_split($A)
    #@btime static_scheduling($A)
    #RHS    = zeros(np)
    @btime rhs_static_scheduling!($p, $RHS, $rhs_el, $nel, $ngl, $conn)
    @info RHS
    #@info p    
end

function static_scheduling(a)
    p = zeros(nthreads())  # Allocate a partial sum for each thread
    # Threads macro splits the iterations of array `a` evenly among threads
    @threads for x in a
        p[threadid()] += x  # Compute partial sums for each thread
    end
    s = sum(p)  # Compute the total sum
    return s
end


function rhs_static_scheduling!(pp, RHS, rhs_el, nel, ngl, conn)    
    
    # Threads macro splits the iterations of array `a` evenly among threads
    for iel = 1:nel
        for j = 1:ngl
            for i = 1:ngl
                I = conn[iel,i,j]
                RHS[I] += rhs_el[i,j,iel]
                #p[1, I] += rhs_el[i,j,iel]  # Compute partial sums for each thread
                #RHS[I] = p[threadid(), I]
            end
        end
    end
    #s = sum(p)  # Compute the total sum
    #RHS[:] = p[1, :]
    #return s
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

function aDSS_rhs!(RHS, rhs_el, nelem, ngl, conn)

    r = Atomic{eltype(rhs_el)}(zero(eltype(rhs_el)))
    len, rem = divrem(length(rhs_el[1,1,:]), nthreads())
    
    @threads for t in 1:nthreads()

        r[] = zero(eltype(rhs_el))
        #for iel = 1:nelem
        @simd for iel in (1:len) .+ (t-1)*len
            for j = 1:ngl
                for i = 1:ngl
                    I = conn[iel,i,j]
                    #RHS[I] += rhs_el[i,j,iel]
                    r[] += rhs_el[i,j,iel]
                end
            end
        end
        atomic_add!(r, r[])
    end
    RHS .= r[]
    @simd for iel in length(rhs_el[1,1,:])-rem+1:length(rhs_el[1,1,:])
        for j = 1:ngl
            for i = 1:ngl
                I = conn[iel,i,j]
                @inbounds RHS[I] += rhs_el[i,j,iel]
            end
        end
    end 
end


function sum_thread_split(A)

    r = Atomic{eltype(A)}(zero(eltype(A)))
    len, rem = divrem(length(A), nthreads())
    
    @threads for t in 1:nthreads()

        r[] = zero(eltype(A))
       
        @simd for iel in (1:len) .+ (t-1)*len
          #  for j = 1:ngl
          #      for i = 1:ngl
          #          I = conn[iel,i,j]
                    #RHS[I] += A[i,j,iel]
                   @inbounds r[] += A[iel]
          #      end
          #  end
        end
        atomic_add!(r, r[])
    end

    result = r[]    
    @simd for iel in length(A)-rem+1:length(A)
        #for j = 1:ngl
        #    for i = 1:ngl
        #        I = conn[iel,i,j]
                @inbounds result += A[iel]
        #    end
        #end
    end
   return result 
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

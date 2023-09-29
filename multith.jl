using ThreadsX

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
sum_multi_good(1:1_000_000)

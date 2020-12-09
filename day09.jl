using Combinatorics

numbers = open("xmas_cypher.txt") do f
    parse.(Int, readlines(f))
end

function find_weak(numbers::Array{Int64, 1}, preamble::Int64)::Int64
    for i in (preamble+1):length(numbers)
        found = false
        n = numbers[i]
 
        for pair in combinations(numbers[(i-preamble):(i-1)], 2)
            if sum(pair) == n
                found = true
                break
            end
        end
 
        if !found
            return n
        end
    end

    return 0
end

function find_contiguous_set(numbers::Array{Int64,1}, sum_to::Int64)::Array{Int64, 1}
   
    for i in 1:(length(numbers)-1)
        for j in (i+1):length(numbers)
            if sum(numbers[i:j]) == sum_to
                return numbers[i:j]
            end
        end
    end

    return []
end

weak = find_weak(numbers, 25)
println(weak)
set = find_contiguous_set(numbers, weak)
println(minimum(set) + maximum(set))

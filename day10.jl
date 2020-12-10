adapters = open("adapters.txt") do f
    sort(parse.(Int, readlines(f)))
end

function find_contiguous_sets(numbers::Array{Int64,1}, n::Int64)::Array{Int64, 1}
    sets = []
    i = 1

    while i < length(numbers)
        if numbers[i] != n
            i += 1
            continue
        end

        j = i
        while j < length(numbers)
            if numbers[j+1] != n
                break
            end
            j += 1
        end

        if j > i
            push!(sets, length(numbers[i:j]))
        end

        i = j + 1
    end

    return sets
end

function permutations(x::Int64)::Int64
    sum = 0

    for i in (x ÷ 3):-1:0
        y = x - 3*i

        for j in (y ÷ 2):-1:0
            z = y - 2*j
            p = factorial(z+j+i) ÷ (factorial(z)*factorial(j)*factorial(i))
            sum += p
            # println("$(x): [$(z), $(j), $(i)]: $(p)")
        end
    end

    return sum
end

pushfirst!(adapters, 0)
diffs = push!(map(i -> adapters[i]-adapters[i-1], 2:length(adapters)), 3)
println(count(i -> i == 1, diffs) * count(i -> i == 3, diffs))
println(prod(map(x -> permutations(x), find_contiguous_sets(diffs, 1))))

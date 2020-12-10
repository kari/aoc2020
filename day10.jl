adapters = open("adapters.txt") do f
    sort(parse.(Int, readlines(f)))
end

function find_contiguous_sets(numbers::Array{Int64,1})::Array{Int64, 1}
    sets = []
    i = 1

    while i < length(numbers)
        if numbers[i] != 1
            i += 1
            continue
        end

        j = i
        while j < length(numbers)
            if numbers[j+1] != 1
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
    if x == 2
        return 2 # [1,1], [2]
    elseif x == 3
        return 4 # [1,1,1], [2,1], [1,2], [3]
    elseif x == 4
        return 7 # [1,1,1,1], [2,1,1], [1,2,1], [1,1,2], [2,2] [1,3], [3,1]
    else
        throw(DomainError(x, "Unhandled length"))
    end
end

pushfirst!(adapters, 0)
diffs = push!(map(i -> adapters[i]-adapters[i-1], 2:length(adapters)), 3)
println(count(i -> i == 1, diffs) * count(i -> i == 3, diffs))
println(prod(map(x -> permutations(x), find_contiguous_sets(diffs))))

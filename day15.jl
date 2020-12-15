starting_numbers = open("starting_numbers.txt") do f
    parse.(Int, split(readline(f), ","))
end

function play_game(starting::Vector{Int64}, upto::Int64)::Int64
    last_seen = Dict{Int64, Tuple{Int64, Int64}}()
    prev = starting[end]
    
    for (i, v) = enumerate(starting)
        last_seen[v] = (i, 0)
        # println("Turn $(i): $(v)")
    end

    for i in (length(starting)+1):upto
        if last_seen[prev][2] == 0
            x = 0
        else
            x = i - 1 - last_seen[prev][2]
            # println("$(prev): $(i-1) - $(recent)")
        end
        # println("Turn $(i): $(x)")
        if haskey(last_seen, x)
            last_seen[x] = (i, last_seen[x][1])
        else
            last_seen[x] = (i, 0)
        end
        prev = x
    end

    return prev
end

# println(play_game([0,3,6], 10) == 0)
# println(play_game([0,3,6], 2020) == 436)
# println(play_game([1,3,2], 2020) == 1)
# println(play_game([2,1,3], 2020) == 10)
# println(play_game([1,2,3], 2020) == 27)
# println(play_game([2,3,1], 2020) == 78)
# println(play_game([3,2,1], 2020) == 438)
# println(play_game([3,1,2], 2020) == 1836)

@time println(play_game(starting_numbers, 2020))
@time println(play_game(starting_numbers, 30000000))

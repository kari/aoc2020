starting_numbers = open("starting_numbers.txt") do f
    parse.(Int, split(readline(f), ","))
end

function play_game(starting::Vector{Int64}, upto::Int64)::Int64
    counts = Dict{Int64, Int64}()
    last_seen = Dict{Int64, Tuple{Int64, Int64}}()
    prev = starting[end]
    
    for (i, v) = enumerate(starting)
        counts[v] = 1
        last_seen[v] = (i, i)
        # println("Turn $(i): $(v)")
    end

    for i in (length(starting)+1):upto
        # if i % 1000000 == 0
        #     println(i)
        # end
        if counts[prev] == 1
            x = 0
        else
            recent = last_seen[prev][2]
            x = i-1-recent
            # println("$(prev): $(i-1) - $(recent)")
        end
        # println("Turn $(i): $(x)")
        if haskey(counts, x)
            counts[x] += 1
            last_seen[x] = (i, last_seen[x][1])
        else
            counts[x] = 1
            last_seen[x] = (i, i)
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

println(play_game(starting_numbers, 2020))
println(play_game(starting_numbers, 30000000))

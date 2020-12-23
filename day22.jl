original_decks = open("cards.txt") do f
    map(m -> parse.(Int, split(strip(m.captures[1]), "\n")), eachmatch(r"Player .:\n((?:\d+\n?)+)", read(f, String)))
end

function play_combat(decks::Array{Array{Int64,1},1})::Int
    while minimum(map(d -> length(d), decks)) > 0
        topcards = map(d -> popfirst!(d), decks)
        winner = argmax(topcards)
        decks[winner] = append!(decks[winner], winner == 1 ? topcards : reverse(topcards))
    end

    return argmax(map(d -> length(d), decks))
end

function return_first(x::Array{Int64,1}, y::Int64)::Array{Int64,1}
    return deepcopy(x[1:y])
end

function play_recursive_combat(decks::Array{Array{Int64,1},1})::Int
    # println("Starting a game")

    history = Array{Array{Array{Int64,1},1},1}()
    while minimum(map(d -> length(d), decks)) > 0
        # for i in 1:2
        #     println("Player $(i)'s deck: $(join(decks[i], ", "))")
        # end
        if decks in history 
            # println("We've already seen these decks, player 1 wins the game")
            return 1
        end

        push!(history, deepcopy(decks))
        topcards = map(d -> popfirst!(d), decks)
        # for i in 1:2
        #     println("Player $(i) plays: $(topcards[i])")
        # end

        if all(map(d -> length(d), decks) .>= topcards)
            new_decks = map(return_first, decks, topcards)
            winner = play_recursive_combat(new_decks)
        else
            winner = argmax(topcards)
            # println("Player $(winner) wins the round")
        end

        decks[winner] = append!(decks[winner], winner == 1 ? topcards : reverse(topcards))
    end

    # println("Player $(argmax(map(d -> length(d), decks))) wins the game")
    return argmax(map(d -> length(d), decks))

end

decks = deepcopy(original_decks)
winner = play_combat(decks)
println(sum(decks[winner] .* collect(length(decks[winner]):-1:1)))

decks = deepcopy(original_decks)
winner = play_recursive_combat(decks)
println(sum(decks[winner] .* collect(length(decks[winner]):-1:1)))

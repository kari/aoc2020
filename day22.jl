decks = open("cards.txt") do f
    map(m -> parse.(Int, split(strip(m.captures[1]), "\n")), eachmatch(r"Player .:\n((?:\d+\n?)+)", read(f, String)))
end

while minimum(map(d -> length(d), decks)) > 0
    p1 = popfirst!(decks[1])
    p2 = popfirst!(decks[2])
    if p1 > p2
        decks[1] = push!(decks[1], p1, p2)
    else
        decks[2] = push!(decks[2], p2, p1)       
    end
#    println(decks)
end

winner = argmax(map(d -> length(d), decks))
println(sum(decks[winner] .* collect(length(decks[winner]):-1:1)))
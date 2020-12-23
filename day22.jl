decks = open("cards.txt") do f
    map(m -> parse.(Int, split(strip(m.captures[1]), "\n")), eachmatch(r"Player .:\n((?:\d+\n?)+)", read(f, String)))
end

while minimum(map(d -> length(d), decks)) > 0
    local winner
    topcards = map(d -> popfirst!(d), decks)
    winner = argmax(topcards)
    decks[winner] = append!(decks[winner], winner == 1 ? topcards : reverse(topcards))
end

winner = argmax(map(d -> length(d), decks))
println(sum(decks[winner] .* collect(length(decks[winner]):-1:1)))
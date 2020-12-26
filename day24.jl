pat = r"(?:n(?:w|e)|e|w|s(?:w|e))"
tiles = open("tiles.txt") do f
    map(tile -> map(x -> x.match, tile), eachmatch.(pat, readlines(f)))
end

flipped = Dict()
for tile in tiles
    coord = (q = 0, r = 0)
    for d in tile
        q = 0
        r = 0
        if d == "nw"
            r = -1
        elseif d == "ne"
            q = 1
            r = -1
        elseif d == "e"
            q = 1
        elseif d == "se"
            r = 1
        elseif d == "sw"
            r = 1
            q = -1
        elseif d == "w"
            q = -1
        end
        coord = (q = coord.q + q, r = coord.r + r)
    end
    if haskey(flipped, coord)
        delete!(flipped, coord)
    else
        flipped[coord] = 1
    end
end

println(sum(values(flipped)))
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

function draw_map(flipped)
    min_q = 0
    max_q = 0
    min_r = 0
    max_r = 0
    for (q,r) in keys(flipped)
        if q > max_q
            max_q = q
        elseif q < min_q
            min_q = q
        end
        if r > max_r
            max_r = r
        elseif r < min_r
            min_r = r
        end
    end
    for r in min_r:max_r
        print(repeat(" ", r-min_r))
        for q in min_q:max_q
            if haskey(flipped, (q = q, r = r))
                print("$(flipped[(q = q, r = r)]) ")
            else
                print("o ")
            end
        end
        println()
    end
end

for i in 1:100
    global flipped
    # draw_map(flipped)
    # add adjacent white tiles
    for (coord, tile) in flipped
        if tile == 0
            continue
        end
        adj = [(0, -1), (+1, -1), (+1, 0), (0, +1), (-1, +1), (-1, 0)]
        for (q, r) in adj
            if !haskey(flipped, (q = coord.q + q, r = coord.r + r))
                flipped[(q = coord.q + q, r = coord.r + r)] = 0
            end
        end
    end
    
    # draw_map(flipped)
    result = deepcopy(flipped)
    for (coord, tile) in flipped
        blacks = 0
        adj = [(0, -1), (+1, -1), (+1, 0), (0, +1), (-1, +1), (-1, 0)]
        for (q, r) in adj
            if haskey(flipped, (q = coord.q + q, r = coord.r + r)) && flipped[(q = coord.q + q, r = coord.r + r)] == 1
                blacks += 1
            end
        end
        if tile == 1 && (blacks == 0 || blacks > 2)
            result[coord] = 0
        elseif tile == 0 && blacks == 2
            result[coord] = 1
        end
        # println("$(coord): $(tile) => $(result[coord]) ($blacks)")
    end
    
    flipped = result

    # remove empty
    for (coord, tile) in flipped
        if tile == 0
            delete!(flipped, coord)
        end
    end
    
    # if i < 10 || i % 10 == 0
    #     println(i,": ",sum(values(flipped)))
    # end
end

println(sum(values(flipped)))
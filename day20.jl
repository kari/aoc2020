tiles = open("image_tiles.txt") do f
    map(m -> (parse(Int, m.captures[1]), hcat(map(r -> map(x -> x == '#' ? 1 : 0, collect(r)), split(strip(m.captures[2]), "\n"))...)), eachmatch(r"Tile (\d+):\n((?:[#\.]+\n)+)", read(f, String)))
end

function parse_sides(arr)
    s1 = map(side -> parse(Int, join(side), base = 2), [arr[:, 1], arr[:, end], arr[1, :], arr[end, :]])
    s2 = map(side -> parse(Int, join(reverse(side)), base = 2), [arr[:, 1], arr[:, end], arr[1, :], arr[end, :]])

    return s1, s2
end

# tile_dimensions = size(tiles[1][2]) # 10x10
tiles = map(x -> (x[1], parse_sides(x[2])...), tiles)

function find_corners(tiles)
    sides = []
    for t in tiles
        append!(sides, t[2])
        append!(sides, t[3])
    end
    counter = Dict()
    for s in sides
        if haskey(counter, s)
            counter[s] += 1
        else
            counter[s] = 1
        end
    end

    corners = filter(tile -> count(s -> counter[s] == 1, tile[2])
    == 2, tiles)
    
    return corners
end

prod(map(x -> x[1], find_corners(tiles)))
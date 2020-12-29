mutable struct Tile
    id::Int64
    data::Array{Int64,2}
end
Base.show(io::IO, z::Tile) = print(io, z.id)

function rotate(tile::Tile)
    new_tile = Tile(tile.id, rotl90(tile.data))
    return new_tile
end

function rotate!(tile::Tile)
    tile.data = rotl90(tile.data)
    return tile
end

function flip_y(tile::Tile)
    new_tile = Tile(tile.id, reverse(tile.data, dims=2))
    return new_tile
end

function flip_y!(tile::Tile)
    tile.data = reverse(tile.data, dims=2)
    return tile
end

function flip_x(tile::Tile)
    new_tile = Tile(tile.id, reverse(tile.data, dims=1))
    return new_tile
end

function flip_x!(tile::Tile)
    tile.data = reverse(tile.data, dims=1)
    return tile
end

function flip_xy(tile::Tile)
    new_tile = Tile(tile.id, reverse(reverse(tile.data, dims=2), dims=1))
    return new_tile
end

function flip_xy!(tile::Tile)
    tile.data = reverse(reverse(tile.data, dims=2), dims=1)
    return tile
end

function sides(tile::Tile)::Array{Array{Int64,1}}
    arr = tile.data
    return [arr[:, 1], arr[end, :], arr[:, end], arr[1, :]] # t, r, b, l
end

function side(tile::Tile, n::Int64)::Array{Int64,1}
    return sides(tile)[n]
end

function parse_side(side::Union{Array{Int64,1},Nothing})::Int64
    if side === nothing
        return -1
    end
    return parse(Int, join(side), base = 2)
end

function find_sides(tiles::Array{Tile,1})
    all_sides = []
    for t in tiles
        append!(all_sides, sides(t))
        append!(all_sides, reverse.(sides(t)))
    end
    return all_sides
end

function find_corners(tiles::Array{Tile,1})::Array{Tile,1}
    all_sides = find_sides(tiles)

    counter = Dict()
    for s in all_sides
        if haskey(counter, s)
            counter[s] += 1
        else
            counter[s] = 1
        end
    end

    corners = filter(tile -> count(s -> counter[s] == 1, sides(tile))
    == 2, tiles)

    return corners
end

function draw(tile::Tile)
    for i in 1:size(tile.data, 2)
        println(join(map(x -> x == 1 ? "#" : ".", tile.data[i, :])))
    end
end

function draw(image_map::Array{Tile,2})
    for i in 1:size(image_map, 2)
        for r in 1:size(image_map[1,1].data, 2)
            for t in image_map[:, i]
                print(join(map(x -> x == 1 ? "#" : ".", t.data[r, :])), " ")
            end
            println()
        end
        println()
    end
end

tiles = open("image_tiles.txt") do f
    map(m -> Tile(parse(Int, m.captures[1]), hcat(map(r -> map(x -> x == '#' ? 1 : 0, collect(r)), split(strip(m.captures[2]), "\n"))...)), eachmatch(r"Tile (\d+):\n((?:[#\.]+\n)+)", read(f, String)))
end

println(prod(map(x -> x.id, find_corners(tiles))))

dim = Int(sqrt(length(tiles)))
image = Array{Tile}(undef, dim, dim)
# pick first corners
# start to assemble from top to bottom, left to right
# orient tiles to match

function find_tile(s::Array{Int64,1}, tiles::Array{Tile,1}, n::Int64)
    tile = nothing
    for t in tiles
        # println("looking at $(t)")
        if s in find_sides([t])
            # println("Tile $(t) matches side $(parse_side(s))")
            tile = t
            break
        end
    end
    if tile === nothing
        error("no matching tile for $(parse_side(s)) found")
    end

    # rotate tile to match side n
    while side(tile, n) != s
        # println("rotating")
        rotate!(tile)
        # println(parse_side.(sides(tile)))
        if side(tile, n) == s
            break
        end
        for op in [:flip_x, :flip_y, :flip_xy]
            # println("flipping $(op)")
            if side(eval(op)(tile), n) == s
                eval(Symbol(op, "!"))(tile)
                break
            end
        end
    end

    return tile
end

function rotate_corner!(tile::Tile, tiles::Array{Tile,1})::Tile
    bag = filter(t -> t != tile, tiles)
    all_sides = find_sides(bag)

    while !(side(tile, 2) in all_sides && side(tile, 3) in all_sides)
        rotate!(tile)
    end

    return tile
end

function find_monsters(tile::Tile)::Int64
    monsters = 0
    monster = [
        "^..................#.",
        "^#....##....##....###",
        "^.#..#..#..#..#..#..."]
    for r in 1:(size(tile.data, 1)-length(monster)+1)
        for c in 1:(size(tile.data, 2)-length(monster[1]))
            # println("($(r),$(c))")
            if occursin(Regex(monster[1]), join(map(x -> x == 1 ? "#" : ".",tile.data[r,c:end])))
                # println("head found")
                if occursin(Regex(monster[2]), join(map(x -> x == 1 ? "#" : ".",tile.data[r+1,c:end])))
                    # println("body found")
                    if occursin(Regex(monster[3]), join(map(x -> x == 1 ? "#" : ".",tile.data[r+2,c:end])))
                        # println("legs found")
                        monsters += 1
                    end
                end
            end
        end
    end

    return monsters
end

left = nothing
for x in 1:dim
    top = nothing
    for y in 1:dim
        global left
        # println("($(x),$(y)): top: $(parse_side(top)), left: $(parse_side(left))")
        if y == 1 && x == 1 # set corner tile
            tile = find_corners(tiles)[1]
            # println("($(x),$(y)): setting corner tile $(tile)")
            image[1,1] = tile
            rotate_corner!(tile, tiles)
            top = side(tile, 3) # bottom
            left = side(tile, 2) # right
        elseif y == 1 # new column, match left
            tile = find_tile(left, tiles, 4)
            # println("($(x),$(y)): found tile $(tile) matching left $(parse_side(left))")
            image[y,x] = tile
            top = side(tile, 3)
            left = side(tile, 2)
        else # match top
            tile = find_tile(top, tiles, 1)
            # println("($(x),$(y)): found tile $(tile) matching top $(parse_side(top)) == $(parse_side(side(tile,1)))")
            image[y,x] = tile
            # no rotaton necessary
            top = side(tile, 3)
        end
        filter!(x -> x.id != tile.id, tiles)
        # println("$(length(tiles)) tiles left")
    end
end
# println(image)
# draw(image)

# remove borders (strip sides)
for i in eachindex(image)
    image[i].data = image[i].data[2:end-1, 2:end-1]
end
# draw(image)
# remove gaps (make one huge tile?)
arr = []
for i in 1:size(image, 2)
    global arr
    local row
    for r in 1:size(image[1,1].data, 2)
        row = []
        for t in image[i, :]
            row = vcat(row, t.data[:, r])
        end
        push!(arr, row)
    end
end
image = Tile(0, hcat(arr...))

monsters = 0
for i in 1:4
    global monsters, image
    rotate!(image)
    monsters = [find_monsters(image), find_monsters(flip_x(image)), find_monsters(flip_y(image)), find_monsters(flip_xy(image))]
    if maximum(monsters) > 0
        break
    end    
end

println(sum(image.data) - 15*maximum(monsters))
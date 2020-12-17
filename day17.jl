initial = open("conway_cubes.txt") do f
    BitArray(permutedims(hcat(map(r -> map(x ->  x == '#' ? true : false, collect(r)), readlines(f))...), (2,1)))
end

function expand(m)
    if sum(m[1, :, :]) > 0 # roof
        # println("stretching roof")
        m = vcat(falses(1, size(m, 2), size(m, 3)), m)
    end
    if sum(m[end, :, :]) > 0 # floor
        # println("stretching floor")
        m = vcat(m, falses(1, size(m, 2), size(m, 3)))
    end
    if sum(m[:, 1, :]) > 0 # left
        # println("stretching left")
        m = hcat(falses(size(m, 1), 1, size(m, 3)), m)
    end
    if sum(m[:, end, :]) > 0 # right
        # println("stretching right")
        m = hcat(m, falses(size(m, 1), 1, size(m, 3)))
    end
    if sum(m[:, :, 1]) > 0 # back
        # println("stretching back")
        m = cat(falses(size(m, 1), size(m, 2), 1), m, dims = 3)
    end
    if sum(m[:, :, end]) > 0 # front
        # println("stretching front")
        m = cat(m, falses(size(m, 1), size(m, 2), 1), dims = 3)    
    end
    return m
end

function index2coord(i, s)
    z = (i - 1) ÷ (s[1] * s[2])
    x = (i - 1 - z * s[1] * s[2]) ÷ s[1]
    y = i - 1 - z * s[1] * s[2] - x * s[1]
    return (x+1, y+1, z+1)
end

function coord2index(x, y, z, s)
    i = s[1]*s[2]*(z-1) + s[1]*(x-1) + y - 1
    return i + 1
end

function create_range(x, max)
    xmin = x <= 1 ? 1 : x - 1
    xmax = x >= max ? max : x + 1
    return xmin:xmax
end

function print_map(x)
    for i in 1:size(x, 3)
        println("z = $(i)")
        for j in 1:size(x, 1)
            println(join(map(x -> x ? "#" : ".", x[j, :, i])))
        end
    end
end

n = reshape(initial, (size(initial)..., 1))
# print_map(n)

for j in 1:6
    global n
    n = expand(n)
    nc = deepcopy(n)

    for i in eachindex(n)
        x, y, z = index2coord(i, size(n))
        xr = create_range(x, size(n, 2))
        yr = create_range(y, size(n, 1))
        zr = create_range(z, size(n, 3))
        s = sum(view(n, yr, xr, zr)) - Int(n[i])
        # println("$(i): $(index2coord(i, size(n))): $(n[i]): $(s)")
        if n[i] && s ∉ 2:3
            nc[i] = false
        end
        if !n[i] && s == 3
            nc[i] = true
        end
    end
    n = nc
    # println("i = $(j)")
    # print_map(n)
    # println()
end

println(sum(n))

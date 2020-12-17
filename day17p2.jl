initial = open("conway_cubes.txt") do f
    BitArray(permutedims(hcat(map(r -> map(x ->  x == '#' ? true : false, collect(r)), readlines(f))...), (2,1)))
end

function expand(m)
    if sum(m[1, :, :, :]) > 0 # roof
        # println("stretching roof")
        m = vcat(falses(1, size(m, 2), size(m, 3), size(m, 4)), m)
    end
    if sum(m[end, :, :, :]) > 0 # floor
        # println("stretching floor")
        m = vcat(m, falses(1, size(m, 2), size(m, 3), size(m, 4)))
    end
    if sum(m[:, 1, :, :]) > 0 # left
        # println("stretching left")
        m = hcat(falses(size(m, 1), 1, size(m, 3), size(m, 4)), m)
    end
    if sum(m[:, end, :, :]) > 0 # right
        # println("stretching right")
        m = hcat(m, falses(size(m, 1), 1, size(m, 3), size(m, 4)))
    end
    if sum(m[:, :, 1, :]) > 0 # back
        # println("stretching back")
        m = cat(falses(size(m, 1), size(m, 2), 1, size(m, 4)), m, dims = 3)
    end
    if sum(m[:, :, end, :]) > 0 # front
        # println("stretching front")
        m = cat(m, falses(size(m, 1), size(m, 2), 1, size(m, 4)), dims = 3)
    end
    if sum(m[:, :, :, 1]) > 0 # hyperback
        # println("stretching hyperback")
        m = cat(falses(size(m, 1), size(m, 2), size(m, 3), 1), m, dims = 4)
    end
    if sum(m[:, :, :, end]) > 0 # front
        # println("stretching hyperfront")
        m = cat(m, falses(size(m, 1), size(m, 2), size(m, 3), 1), dims = 4)
    end
    return m
end

function index2coord(i, s)
    w = (i - 1) ÷ (s[1] * s[2] * s[3])
    z = (i - 1 - w * s[1] * s[2] * s[3]) ÷ (s[1] * s[2])
    x = (i - 1 - z * s[1] * s[2] - w * s[1] * s[2] * s[3]) ÷ s[1]
    y = i - 1 - x * s[1] - z * s[1] * s[2] - w * s[1] * s[2] * s[3]
    return (x+1, y+1, z+1, w+1)
end

function create_range(x, max)
    xmin = x <= 1 ? 1 : x - 1
    xmax = x >= max ? max : x + 1
    return xmin:xmax
end

function print_map(x)
    for w in 1:size(x, 4)
        for i in 1:size(x, 3)
            println("w = $(w), z = $(i)")
            for j in 1:size(x, 1)
                println(join(map(x -> x ? "#" : ".", x[j, :, i, w])))
            end
        end
    end
end

n = reshape(initial, (size(initial)..., 1, 1))
# print_map(n)

for j in 1:6
    global n
    n = expand(n)
    nc = deepcopy(n)

    for i in eachindex(n)
        x, y, z, w = index2coord(i, size(n))
        xr = create_range(x, size(n, 2))
        yr = create_range(y, size(n, 1))
        zr = create_range(z, size(n, 3))
        wr = create_range(w, size(n, 4))
        s = sum(view(n, yr, xr, zr, wr)) - Int(n[i])
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

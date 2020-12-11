seating = open("seating.txt") do f
    collect.(readlines(f))
end

function print_map(arr)
    for r in arr
        println(join(r))
    end
    println()
end

function count_neighborhood(arr, x::Int64, y::Int64, c::Char)::Int64
    n = 0

    if y > 1
        if arr[y-1][x] == c
            n += 1
        end
        if x > 1 && arr[y-1][x-1] == c
            n += 1
        end
        if x < length(arr[1]) && arr[y-1][x+1] == c
            n += 1
        end
    end

    if y < length(arr)
        if arr[y+1][x] == c
            n += 1
        end
        if x > 1 && arr[y+1][x-1] == c
            n += 1
        end
        if x < length(arr[1]) && arr[y+1][x+1] == c
            n += 1
        end
    end

    if x > 1 && arr[y][x-1] == c
        n += 1
    end

    if x < length(arr[1]) && arr[y][x+1] == c
        n += 1
    end

    return n
end

function count_visible(arr, x::Int64, y::Int64, c::Char)::Int64
    n = 0
    unit_vectors = map(x -> [round(Int,sin(x)),round(Int,cos(x))], pi*(-1:1/4:0.9))
    for uv in unit_vectors
        l = 1
        while true
            ox, oy = l * uv
            if y+oy < 1 || y+oy > length(arr) || x+ox < 1 || x+ox > length(arr[1])
                break
            end
            if arr[y+oy][x+ox] == c
                n += 1
            end
            if arr[y+oy][x+ox] != '.'
                break
            end
            l += 1
        end
    end
    return n
end

function simulate(arr, fn, n)
    step = deepcopy(arr)

    for y in 1:length(arr)
        for x in 1:length(arr[1])
            # print("at $(y),$(x): $(arr[y][x]): ")
            if arr[y][x] == '.'
                # println("do nothing")
            elseif arr[y][x] == 'L'
                occupied = fn(arr, x, y, '#')
                if occupied == 0
                    step[y][x] = '#'
                end
            elseif arr[y][x] == '#'
                occupied = fn(arr, x, y, '#')
                if occupied >= n
                    step[y][x] = 'L'
                end
            end
        end
    end

    return step
end

function run(state, fn, n)
    i = 0
    while true
        i += 1
        next_state = simulate(state, fn, n)
        if state == next_state
            break
        end
        state = deepcopy(next_state)
    end

    return state    
end

println(sum(map(r -> count(x -> x == '#', r), run(seating, count_neighborhood, 4))))
println(sum(map(r -> count(x -> x == '#', r), run(seating, count_visible, 5))))

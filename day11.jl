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

function simulate(arr)
    step = deepcopy(arr)

    for y in 1:length(arr)
        for x in 1:length(arr[1])
            # print("at $(y),$(x): $(arr[y][x]): ")
            if arr[y][x] == '.'
                # println("do nothing")
            elseif arr[y][x] == 'L'
                occupied = count_neighborhood(arr, x, y, '#')
                if occupied == 0
                    step[y][x] = '#'
                end
            elseif arr[y][x] == '#'
                occupied = count_neighborhood(arr, x, y, '#')
                if occupied >= 4
                    step[y][x] = 'L'
                end
            end
        end
    end

    return step
end

state = seating
i = 0
while true
    global i, state
    i += 1
    if state == simulate(state)
        break
    end
    state = simulate(state)
end

println(sum(map(r -> count(x -> x == '#', r), state)))

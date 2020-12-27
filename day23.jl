using Profile

input = "318946572"
# input = "389125467" # test pattern
orig_cups = parse.(Int, collect(input))

function play(cups, n)
    cup_idx = 1
    min_cup, max_cup = extrema(cups)
    picked = Array{Int64, 1}(undef, 3)

    for i in 1:n
        if (i % 100_000 == 0)
            println(i)
        end
        # println("-- move $(i) --")
        # println("cups: $(join(cups, " "))")
        cup = cups[1]
        # println("current cup: $(cup)")
        pick_idxs = 2:4
        picked = cups[pick_idxs]
        # remove picks from cups
#        filter!(c -> c ∉ picked, cups)
        # println("pick up: $(join(picked, " ")) ($(join(pick_idxs, " ")))")
        destination = cup - 1
        if destination < min_cup
            destination = max_cup
        end
        while destination in picked
            destination -= 1
            if destination < min_cup
                destination = max_cup
            end
        end
        dst_idx = findfirst(x -> x == destination, cups)
        # println("destination cup: $(destination) ($(dst_idx))")
        # insert cups
        cups[2:dst_idx-3] = cups[5:dst_idx]
        # println(cups)
        cups[(dst_idx-2):(dst_idx)] = picked
        # println(cups)
        cups[1:end-1] = cups[2:end]
        cups[end] = cup
    end

    return first_idx = findfirst(x -> x == 1, cups)
end

function play2(cups, n)
    list = Array{Int64, 1}(undef, length(cups))
    for i in 1:(length(cups)-1)
        list[cups[i]] = cups[i+1]
    end
    list[cups[end]] = cups[1]
    # println(list)
    cup = cups[1]
    min_cup, max_cup = extrema(cups)
    for i in 1:n
        # println("-- move $(i) --")
        # println("cup: ", cup)
        picked = [list[cup], list[list[cup]], list[list[list[cup]]]]
        # println("pick up: ", join(picked, ", "))
        destination = cup - 1
        if destination < min_cup
            destination = max_cup
        end
        while destination in picked
            destination -= 1
            if destination < min_cup
                destination = max_cup
            end
        end
        # println("destination: ", destination)
        list[cup] = list[picked[end]]
        list[picked[end]] = list[destination]
        list[destination] = picked[1]
        cup = list[cup]
    end

    idx = 1
    for i in 1:(length(cups))
        cups[i] = list[idx]
        idx = list[idx]
    end

    return cups
end

cups = copy(orig_cups)
i = play(cups, 100)
println(join(vcat(cups[(i+1):end], cups[1:(i-1)])))

cups = vcat(copy(orig_cups), collect((maximum(orig_cups)+1):1_000_000))
play2(cups, 10_000_000)
println(cups[1]*cups[2])

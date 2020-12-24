input = "318946572"
input = "389125467" # test pattern
orig_cups = parse.(Int, collect(input))

function play(cups, n)
    cup_idx = 1
    min_cup, max_cup = extrema(cups)

    for i in 1:n
        if (i % 100_000 == 0)
            println(i)
        end
        # println("-- move $(i) --")
        # println("cups: $(join(cups, " "))")
        cup = cups[cup_idx]
        # println("current cup: $(cup)")
        picked = []
        for j in 1:3
            p = cups[(j+cup_idx-1) % length(cups) + 1]
            push!(picked, p)
        end
        # remove picks from cups
        filter!(c -> c ∉ picked, cups)
        # println("pick up: $(join(picked, " "))")
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
        # println("destination cup: $(destination)")
        idx = findfirst(x -> x == destination, cups)
        # insert cups
        for j in 1:3
            insert!(cups, idx+j, picked[j])
        end
        cup_idx = findfirst(x -> x == cup, cups) % length(cups) + 1
    end

    return first_idx = findfirst(x -> x == 1, cups)

end

cups = copy(orig_cups)
i = play(cups, 100)
println(join(vcat(cups[(i+1):end], cups[1:(i-1)])))

cups = vcat(copy(orig_cups), collect((maximum(orig_cups)+1):1000000))
i = play(cups, 10000000)
println(cups[i+1])
println(cups[i+2])
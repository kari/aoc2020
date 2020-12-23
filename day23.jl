input = "318946572"
#input = "389125467"
cups = parse.(Int, collect(input))
min_cup, max_cup = extrema(cups)

cup_idx = 1
for i in 1:100
    global cup_idx, cups, min_cup, max_cup
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

first_idx = findfirst(x -> x == 1, cups)
println(join(vcat(cups[(first_idx+1):end], cups[1:(first_idx-1)])))
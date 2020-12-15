starting_numbers = open("starting_numbers.txt") do f
    parse.(Int, split(readline(f), ","))
end

# starting_numbers = [0,3,6]

for i in (length(starting_numbers)+1):2020
    global D, starting_numbers
    prev = starting_numbers[end]
    if count(x -> x == prev, starting_numbers) == 1
        x = 0
    else
        recent = findprev(x -> x == prev, starting_numbers, length(starting_numbers)-1)
        x = length(starting_numbers)-recent
    end
    # println("Turn $(i): $(x)")
    push!(starting_numbers, x)
end

println(spoken[2020])
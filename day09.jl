using Combinatorics

numbers = open("xmas_cypher.txt") do f
    parse.(Int, readlines(f))
end

preamble = 25
for i in (preamble+1):length(numbers)
    found = false
    n = numbers[i]
    prev = numbers[(i-preamble):(i-1)]
    for pair in combinations(prev, 2)
        if sum(pair) == n
            # println(pair, n)
            found = true
            break
        end
    end
    if !found
        println(n)
        break
    end
end
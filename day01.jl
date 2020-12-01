using Combinatorics

numbers = open("expense_report.txt") do f
    parse.(Int, readlines(f))
end

for pair in combinations(numbers, 2)
    if sum(pair) == 2020
        println(prod(pair))
    end
end

for pair in combinations(numbers, 3)
    if sum(pair) == 2020
        println(prod(pair))
    end
end

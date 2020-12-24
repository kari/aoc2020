function row2data(row)
    i, a = match(r"(.+) \(contains (.+)\)", row).captures
    return split(i, " "), split(a, ", ")
end

data = open("allergen.txt") do f
    map(r -> row2data(r), readlines(f))
end

allergens = reduce(vcat, map(r -> r[2], data))
ingredients = reduce(vcat, map(r -> r[1], data))
# d = Dict([(i, count(x -> x == i, allergens)) for i in unique(allergens)])
d = []
for a in unique(allergens) # sort(unique(allergens); by=x->d[x], rev=true)
    i = intersect(map(r -> r[1], filter(r -> a in r[2], data))...)
    # println(a => i)
    # d[a] = i
    push!(d, a => i)
end
# println(d)
# while !all(x -> length(x[2]) == 1, d)
#     u = collect(Iterators.flatten(map(x -> x[2], filter(x -> length(x[2]) == 1, d))))
# end
d2 = Dict([(i, count(x -> x == i, ingredients)) for i in unique(ingredients)])
for i in unique(Iterators.flatten(map(x -> x[2], d)))
    delete!(d2, i)
end
println(sum(values(d2)))
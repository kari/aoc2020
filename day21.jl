function row2data(row)
    i, a = match(r"(.+) \(contains (.+)\)", row).captures
    return split(i, " "), split(a, ", ")
end

data = open("allergen.txt") do f
    map(r -> row2data(r), readlines(f))
end

allergens = reduce(vcat, map(r -> r[2], data))
ingredients = reduce(vcat, map(r -> r[1], data))

ingredient_candidates = []
for a in unique(allergens)
    i = intersect(map(r -> r[1], filter(r -> a in r[2], data))...)
    push!(ingredient_candidates, a => i)
end

ingredient_counts = Dict([(i, count(x -> x == i, ingredients)) for i in unique(ingredients)])

for i in unique(Iterators.flatten(map(x -> x[2], ingredient_candidates)))
    delete!(ingredient_counts, i)
end
println(sum(values(ingredient_counts)))

while !all(x -> length(x[2]) == 1, ingredient_candidates)
    solved = collect(Iterators.flatten(map(x -> x[2], filter(x -> length(x[2]) == 1, ingredient_candidates))))
    for (idx, i) in enumerate(ingredient_candidates)
        if length(i[2]) == 1 
            continue
        end
        ingredient_candidates[idx] = i[1] => filter(x -> x ∉ solved, i[2])
    end
end

println(join(map(x -> x[2][1], sort(ingredient_candidates, by=x -> x[1])),","))
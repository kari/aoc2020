adapters = open("adapters.txt") do f
    sort(parse.(Int, readlines(f)))
end

pushfirst!(adapters, 0)
diffs = push!(map(i -> adapters[i]-adapters[i-1], 2:length(adapters)), 3)
println(count(i -> i == 1, diffs) * count(i -> i == 3, diffs))

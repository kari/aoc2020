timestamp, bus_data = open("bus_data.txt") do f
    parse(Int, readline(f)), parse.(Int, split(replace(readline(f), "x" => "-1"), ","))
end

buses = filter(x -> x != -1, bus_data)
rem = map(x -> timestamp % x, buses)

println(buses[argmin(buses - rem)] * minimum(buses - rem))

# https://rosettacode.org/wiki/Chinese_remainder_theorem#Julia with fix
function crt(n::Vector{Int64}, a::Vector{Int64})::Int64
    N = prod(n)
    return sum(a_i * invmod(N ÷ n_i, n_i) * (N ÷ n_i) for (n_i, a_i) in zip(n, a)) % N
end

offsets = map(x -> findfirst(y -> y == x, bus_data)-1, buses)
println(crt(buses, buses - offsets))

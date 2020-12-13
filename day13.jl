using Mods

timestamp, bus_data = open("bus_data.txt") do f
    parse(Int, readline(f)), parse.(Int, split(replace(readline(f), "x" => "-1"), ","))
end

buses = filter(x -> x != -1, bus_data)
rem = map(x -> timestamp % x, buses)

println(buses[argmin(buses - rem)] * minimum(buses - rem))

# https://rosettacode.org/wiki/Chinese_remainder_theorem#Julia
function chineseremainder(n::Vector{Int64}, a::Vector{Int64})::Int64
    n̂ = prod(n)
    return mod(sum(ai * invmod(n̂ ÷ ni, ni) * n̂ ÷ ni for (ni, ai) in zip(n, a)), n̂)
end

offsets = map(x -> findfirst(y -> y == x, bus_data)-1, buses)
# println(chineseremainder(buses, buses - offsets))
# println(chineseremainder(buses, 2*buses - offsets))
# println(chineseremainder(buses, 3*buses - offsets))
# println(chineseremainder(buses, 4*buses - offsets))
mods = map(t -> Mod{t[1]}(t[2]), zip(buses, buses - offsets)) 
println(value(CRT(mods...)))
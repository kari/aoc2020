timestamp, buses = open("bus_data.txt") do f
    parse(Int, readline(f)), split(readline(f), ",")
end

# timestamp = 939
# buses = split("7,13,x,x,59,x,31,19", ",")

buses = parse.(Int, filter(x -> x != "x", buses))
rem = map(x -> timestamp % x, buses)

println(buses[argmin(buses - rem)] * minimum(buses - rem))
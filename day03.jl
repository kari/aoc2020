map = open("local_geology.txt") do f
    readlines(f)
end

println(count(tuple -> (tuple[2][((tuple[1]-1)*3) % length(tuple[2]) + 1] == '#'), enumerate(map)))

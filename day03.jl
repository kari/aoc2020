map = open("local_geology.txt") do f
    readlines(f)
end

slopes = [(1,1), (3,1), (5,1), (7,1), (1,2)]
println(prod([count(tuple -> (((tuple[1] + 1) % slope[2] == 0) && (tuple[2][Int((tuple[1] - 1) * slope[1]/slope[2]) % length(tuple[2]) + 1] == '#')), enumerate(map)) for slope in slopes]))

# slope = (1,2)
# for (y, row) in enumerate(map)
#     if (y+1)  % slope[2] != 0
#         println(row)
#         continue
#     end 
#     x = Int(((y-1)*slope[1]/slope[2]) % length(map) + 1)
#     if row[x] == '#'
#         rep = "X"
#     elseif row[x] == '.'
#         rep = "O"
#     end
#     println(row[begin:x-1], rep, row[x+1:end])
# end
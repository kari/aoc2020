pattern = r"(\d+)-(\d+) (\w): (\w+)"
rows = open("password_list.txt") do f
    match.(pattern, readlines(f))
end

println(count(row -> (parse(Int, row[1]) <= count(row[3], row[4]) <= parse(Int, row[2])), rows))

println(count(row -> ((row[4][parse(Int, row[1])] == row[3][1]) ⊻ (row[4][parse(Int, row[2])] == row[3][1])), rows))
answers = open("customs_answers.txt") do f
    map(row -> split(row, "\n"), split(read(f, String), "\n\n"))
end

println(sum(map(answer -> length(union(Set.(answer)...)), answers)))

println(sum(map(answer -> length(intersect(Set.(answer)...)), answers)))

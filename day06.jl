answers = open("customs_answers.txt") do f
    map(r -> split(rstrip(r.match), "\n"), eachmatch(r"(?:[^\n]+\n?)+(?:\n|$)", read(f, String)))
end

println(sum(map(answer -> length(reduce(union, Set.(answer))), answers)))

println(sum(map(answer -> length(reduce(intersect, Set.(answer))), answers)))

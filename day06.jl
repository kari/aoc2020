answer_pattern = r"(?:(?:[a-z])+\n?)+(?:\n\n|$)"ms

answers = open("customs_answers.txt") do f
    map(r -> r.match, eachmatch(answer_pattern, read(f, String)))
end

println(sum(map(answer -> length(unique(replace(answer, "\n" => ""))), answers)))
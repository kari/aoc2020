rules, messages = open("rules.txt") do f
    r, m = match(r"((?:\d+: .+\n)+)\n((?:[ab]+\n?)+)", read(f, String)).captures
    r = map(function(r)
         n, s = match(r"(\d+): (.+)", r).captures
         parse(Int, n) => s
        end, split(strip(r), "\n"))
    Dict(r), split(m, "\n")
end

function compose(rule)
    global rules

    for m in reverse(collect(eachmatch(r"\b\d+\b", rule)))
        rule = replace(rule, Regex("\\b" * m.match * "\\b") => "(" * compose(rules[parse(Int,m.match)]) * ")")
    end

    rule = replace(rule, "\"" => "")
    rule = replace(rule, r"\((\w)\)" => s"\1")
    rule = replace(rule, " " => "")

    return rule
end

pattern = Regex("^" * compose(rules[0]) * "\$")
println(count(x -> match(pattern, x) !== nothing, messages))

rules[8] = "42+"
rules[11] = "(?<n> 42 (?:(?&n))* 31)" 

pattern = Regex("^" * compose(rules[0]) * "\$")
println(count(x -> match(pattern, x) !== nothing, messages))

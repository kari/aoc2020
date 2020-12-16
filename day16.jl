notes_pattern = r"((?:[^:]+: \d+-\d+ or \d+-\d+\n)+)\nyour ticket:\n((?:\d+,?)+)\n\nnearby tickets:\n((?:(?:\d+,?)+\n?)+)"
fields, my_ticket, tickets = open("ticket_notes.txt") do f
    fields, my_ticket, tickets = match(notes_pattern, read(f, String)).captures
    my_ticket = parse.(Int, split(my_ticket, ","))
    tickets = map(ticket -> parse.(Int, split(ticket, ",")), split(tickets, "\n"))
    fields = map(r -> (r.captures[1], [parse(Int, r.captures[2]):parse(Int, r.captures[3]); parse(Int, r.captures[4]):parse(Int, r.captures[5])]), match.(r"([^:]+): (\d+)-(\d+) or (\d+)-(\d+)", split(strip(fields), "\n")))
    fields, my_ticket, tickets
end

function valid_ticket(ticket, ranges)::Bool
    for val in ticket
        if !any(r -> val in r, ranges)
            return false
        end
    end
    return true
end

ranges = Iterators.flatten(map(x -> (x[2]), fields))
invalid = Vector{Int64}()
for ticket in tickets
    for val in ticket
        if !any(r -> val in r, ranges)
            # println("$(ticket) is invalid ticket ($(val))")
            push!(invalid, val)
        end
    end
end

println(sum(invalid))

candidates = map(r -> map(f -> f[1], r), map(r -> filter(f -> all(x -> x in f[2], r), fields), eachrow(hcat(filter(t -> valid_ticket(t, ranges), tickets)...))))

while any(x -> length(x) > 1, candidates)
    solved = Iterators.flatten(filter(x -> length(x) == 1, candidates))
    for i in 1:length(candidates)
        if length(candidates[i]) == 1 
            continue
        end
        candidates[i] = filter(c -> c ∉ solved, candidates[i])
    end
end

println(prod([my_ticket[i] for i in findall(x -> startswith(x, "departure"), collect(Iterators.flatten(candidates)))]))

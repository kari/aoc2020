notes_pattern = r"((?:[^:]+: \d+-\d+ or \d+-\d+\n)+)\nyour ticket:\n((?:\d+,?)+)\n\nnearby tickets:\n((?:(?:\d+,?)+\n?)+)"
fields, my_ticket, tickets = open("ticket_notes.txt") do f
    fields, my_ticket, tickets = match(notes_pattern, read(f, String)).captures
    my_ticket = parse.(Int, split(my_ticket, ","))
    tickets = map(ticket -> parse.(Int, split(ticket, ",")), split(tickets, "\n"))
    fields = map(r -> (r.captures[1], parse(Int, r.captures[2]):parse(Int, r.captures[3]), parse(Int, r.captures[4]):parse(Int, r.captures[5])), match.(r"([^:]+): (\d+)-(\d+) or (\d+)-(\d+)", split(strip(fields), "\n")))
    fields, my_ticket, tickets
end

ranges = collect(Iterators.flatten(map(x -> (x[2], x[3]), fields)))
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

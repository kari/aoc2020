ops = open("boot_code.txt") do f
    map(m -> (m[1], parse(Int, m[2])), (match.(r"(\w{3}) ([+-]\d+)", readlines(f))))
end

acc = 0
i = 1
visited = []

while length(visited) == length(unique(visited))
    global acc, i, visited

    op, val = ops[i]

    println(length(visited)+1, " ", op, " ", val)

    if op == "acc"
        acc += val
        i += 1
    elseif op == "jmp"
        i += val
    elseif op == "nop"
        i += 1
    end

    push!(visited, i)
end

println(acc)
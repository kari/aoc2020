ops = open("boot_code.txt") do f
    map(m -> (m[1], parse(Int, m[2])), (match.(r"(\w{3}) ([+-]\d+)", readlines(f))))
end

function mutate(ops)
    mutations = []

    for (i, op) in enumerate(ops)
        ins, val = op
        if ins == "nop"
            mut = copy(ops)
            mut[i] = ("jmp", val)
            push!(mutations, mut)
        elseif ins == "jmp"
            mut = copy(ops)
            mut[i] = ("nop", val)
            push!(mutations, mut)
        end
    end

    return mutations
end

function run(ops)
    acc = 0
    i = 1
    visited = []

    while length(visited) == length(unique(visited))
        op, val = ops[i]

    #    println(length(visited)+1, " ", op, " ", val)
        if op == "acc"
            acc += val
            i += 1
        elseif op == "jmp"
            i += val
        elseif op == "nop"
            i += 1
        end

        if i > length(ops)
            break
        end

        push!(visited, i)
    end

    if i >= length(ops)
        eof = true
    else
        eof = false
    end

    return (acc, eof)
end

println(run(ops)[1])

for m in mutate(ops)
    acc, eof = run(m)
    if eof 
        println(acc)
        break
    end
end
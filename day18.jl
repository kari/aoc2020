equations = open("math.txt") do f
    readlines(f)
end

function eval(eq::AbstractString)
    # println(eq)
    paren = r"\((?:[^)(]+|(?R))*+\)"
    math = r"\d+|\+|\*"
    for m in reverse(collect(eachmatch(paren, eq)))
        neq = m.match[2:end-1]
        eq = replace(eq, m.match => eval(neq))
    end
    op = nothing
    acc = 0
    for x in eachmatch(math, eq)
        x = x.match
        if x in ("+", "*")
            op = x
        else
            x = parse(Int, x)
            if op == "+"
                acc += x
            elseif op == "*"
                acc *= x
            elseif op === nothing
                acc = x
            end
        end
    end
    return acc
end

function eval2(eq::AbstractString)
    # println(eq)
    paren = r"\((?:[^)(]+|(?R))*+\)"
    for m in reverse(collect(eachmatch(paren, eq)))
        neq = m.match[2:end-1]
        eq = replace(eq, m.match => eval2(neq))
    end
    while occursin("+", eq)
        m = last(collect(eachmatch(r"(\d+) \+ (\d+)", eq)))
        o1, o2 = parse.(Int, m.captures)
        eq = replace(eq, m.match => o1 + o2)
        # println("$(o1) + $(o2) => $(o1 + o2)")
    end
    # println(eq)
    while occursin("*", eq)
        m = last(collect(eachmatch(r"(\d+) \* (\d+)", eq)))
        o1, o2 = parse.(Int, m.captures)
        eq = replace(eq, m.match => o1 * o2)
        # println("$(o1) * $(o2) => $(o1 * o2)")
    end
    return parse(Int, eq)
end

println(sum(map(eq -> eval(eq), equations)))

println(sum(map(eq -> eval2(eq), equations)))

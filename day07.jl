mutable struct Node
    name::String
    parents::Array{Node,1}
    children::Dict{Node,Int64}
end
Base.show(io::IO, z::Node) = print(io, z.name)

rule_pattern = r"(\S+ \S+) bags contain ((?:(?:no other|\d+ \S+ \S+) bags?(?:, |\.))+)"

rules = open("baggage_rules.txt") do f
    map(rule -> match(rule_pattern, rule).captures, readlines(f))
end

function find_or_create(name::AbstractString)::Node
    i = findfirst(b -> b.name == name, bags)
    if i === nothing
        n = Node(name, [], Dict())
        push!(bags, n)
        return n
    else
        return bags[i]
    end
end

function climb(node::Node, parents = Node[])::Array{Node,1}
    if isempty(node.parents)
        return parents
    else
        visited = Node[]
        for parent in node.parents
            path = climb(parent, push!(copy(parents), parent))
            visited = union(visited, path)
        end
        return visited
    end
end

function count(node::Node)::Int64
    if isempty(node.children)
        return 0
    else
        child_sum = 0
        for (child, cnt) in node.children
            child_sum += cnt + cnt * count(child)
        end
        return child_sum
    end
end

bags = Node[]
for r in rules
    parent = find_or_create(r[1])
    for i in eachmatch(r"(\d+) (\S+ \S+)", r[2])
        child = find_or_create(i.captures[2])
        child_count = parse(Int, i.captures[1])
        parent.children[child] = child_count
        push!(child.parents, parent)
    end
end

shiny_gold = first(filter(bag -> bag.name == "shiny gold", bags))

println(length(climb(shiny_gold)))

println(count(shiny_gold))
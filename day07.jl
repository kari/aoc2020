mutable struct Node
    name::String
    parents::Array{Node,1}
    children::Dict{Node,Int64}
end
Base.show(io::IO, z::Node) = print(io, z.name)
Base.isless(a::Node, b::Node) = a.name < b.name

rule_pattern = r"(\S+ \S+) bags contain ((?:(?:no other|\d+ \S+ \S+) bags?(?:, |\.))+)"

rules = open("baggage_rules.txt") do f
    map(rule -> match(rule_pattern, rule).captures, readlines(f))
end

function find_or_create(name::AbstractString)::Node
    i = findfirst(x -> x.name == name, bags)
    if i === nothing
        n = Node(name, [], Dict())
        push!(bags, n)
        return n
    else
        return bags[i]
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

function climb(node, parents = Node[])::Array{Node,1}
#    println("entering $(node) with parents $(node.parents)")
    if isempty(node.parents)
    #    println("no parents for $(node), returning with path $(parents)")
        return parents
    else
        visited = Node[]
        for parent in node.parents
            path = climb(parent, push!(copy(parents), parent))
        #    println(path)
            visited = union(visited, path)
        end
    #    println("done with $(node)'s parents")
        return visited
    end
end

println(length(climb(shiny_gold)))
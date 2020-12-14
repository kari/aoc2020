lines = open("bitmasks.txt") do f
    readlines(f)
end

memory = zeros(Int64, 100000)
zeromask = nothing
onemask = nothing
for l in lines
    global memory, zeromask, onemask
    if startswith(l, "mask = ")
        mask = match(r"[10X]+", l).match
        onemask = parse(Int, replace(mask, "X" => "0"); base = 2)
        zeromask = parse(Int, replace(mask, "X" => "1"); base = 2)
    else
        addr, val = parse.(Int, match(r"mem\[(\d+)\] = (\d+)", l).captures)
        memory[addr] = val & zeromask | onemask
    end
end

println(sum(memory))

memory = Dict{Int64, Int64}()
onemask = nothing
xmask = nothing
for l in lines
    global memory, xmask, onemask
    if startswith(l, "mask = ")
        mask = match(r"[10X]+", l).match
        onemask = parse(Int, replace(mask, "X" => "0"); base = 2)
        xmask = findall(x -> x == 'X', mask)
    else
        addr, val = parse.(Int, match(r"mem\[(\d+)\] = (\d+)", l).captures)
        res = collect(bitstring(addr | onemask)[end-35:end])
        for i in 0:(2^length(xmask)-1)
            floating = bitstring(i)[end-(length(xmask)-1):end]
            float = collect(res)
            for i in 1:length(xmask)
                float[xmask[i]] = floating[i]
            end
            memory[parse(Int, join(float); base = 2)] = val
        end
    end
end

println(sum(values(memory)))

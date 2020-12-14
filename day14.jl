lines = open("bitmasks.txt") do f
    readlines(f)
end

memory = zeros(Int64, 100000)
zeromask = ""
onemask = ""
mask = ""
for l in lines
    global memory, zeromask, onemask, mask
    if startswith(l, "mask = ")    
        mask = match(r"[10X]+", l).match
        onemask = parse(Int, replace(mask, "X" => "0"); base = 2) # OR
        zeromask = parse(Int, replace(mask, "X" => "1"); base = 2) # AND
    else
        addr, val = parse.(Int, match(r"mem\[(\d+)\] = (\d+)", l).captures)
        res = val & zeromask | onemask
        # println("value:  $(bitstring(val)[end-35:end]) (decimal $(val))")
        # println("mask:   $(mask)")
        # println("result: $(bitstring(res)[end-35:end])")
        memory[addr] = res
    end
end

println(sum(memory))

memory = Dict{Int64, Int64}()
onemask = ""
xmask = []
mask = ""
for l in lines
    global memory, xmask, onemask, mask
    if startswith(l, "mask = ")    
        mask = match(r"[10X]+", l).match
        onemask = parse(Int, replace(mask, "X" => "0"); base = 2) # OR
        xmask = findall(x -> x == 'X', mask)
    else
        addr, val = parse.(Int, match(r"mem\[(\d+)\] = (\d+)", l).captures)
        res = addr | onemask
        res = collect(bitstring(res)[end-35:end])
        for i in xmask
            res[i] = 'X'
        end
        res = join(res)
        # println("address: $(bitstring(addr)[end-35:end]) (decimal $(addr))")
        # println("mask:    $(mask)")
        # println("result:  $(res)")
        for i in 0:(2^length(xmask)-1)
            floating = collect(bitstring(i)[end-(length(xmask)-1):end])
            float = collect(res)
            for i in 1:length(xmask)
                float[xmask[i]] = floating[i]
            end
            float = join(float)
            n = parse(Int, float; base = 2)
            # println("float:   $(float) (decimal $(n))")
            memory[n] = val
        end
        # println()
    end
end

println(sum(values(memory)))

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
        # println("value:  $(bitstring(val)[end-35:end])")
        # println("mask:   $(mask)")
        # println("result: $(bitstring(res)[end-35:end])")
        memory[addr] = res
    end
end

println(sum(memory))

keys = open("public_keys.txt") do f
    parse.(Int, readlines(f))
end

function transform(subject_number::Int64, loop_size::Int64)::Int64
    val = 1
    for i in 1:loop_size
        val = (val * subject_number) % 20201227
    end

    return val
end

function crack(public_keys::Array{Int64, 1}, sn::Int64, ls_range::UnitRange{Int64})::Tuple{Int64, Int64}
    val = 1
    for ls in ls_range
        val = (val * sn) % 20201227
        if val == public_keys[1]
            # println("sn $(sn), ls $(ls) match first")
            val2 = 1
            for ls2 in ls_range
                val2 = (val2 * sn) % 20201227
                if val2 == public_keys[2] && ls != ls2
                    # println("sn $(sn), ls $(ls2) match second")

                    return ls, ls2
                end
            end
            # println("no matching ls2 found")
        end
    end

    return nothing, nothing
end

ls1, ls2 = crack(keys, 7, 1:100_000_000)

println(transform(keys[1], ls2))
# println(transform(keys[2], ls1))

passes = open("boarding_passes.txt") do f
    readlines(f)
end

seatids = sort(map(bits -> parse(Int, bits[1:7], base = 2) * 8 + parse(Int, bits[8:10], base = 2), map(pass -> replace(replace(pass, r"B|R" => "1"), r"F|L" => "0"), passes)))

println(maximum(seatids))

println(argmin(map(i -> seatids[i+1]-seatids[i] == 1, 1:(length(seatids)-1))) + minimum(seatids))

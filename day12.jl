instructions = open("navigation_data.txt") do f
    map(r -> (r[1], parse(Int, r[2:end])), readlines(f))
end

function rotate(v::Vector{Int64}, a::Int64)::Vector{Int64}
    b = deg2rad(a)
    x1, y1 = v
    x2 = cos(b)*x1 - sin(b)*y1
    y2 = sin(b)*x1 + cos(b)*y1

    return round.(Int, [x2, y2])
end

ship = [0, 0]
direction = 0
for (cmd, val) in instructions
    global ship, direction

    if cmd == 'N'
        ship += [0, val]
    elseif cmd == 'E'
        ship += [val, 0]
    elseif cmd == 'S'
        ship += [0, -val]
    elseif cmd == 'W'
        ship += [-val, 0]
    elseif cmd == 'F'
        ship += val * round.(Int, [cos(deg2rad(direction)), sin(deg2rad(direction))])
    elseif cmd == 'L'
        direction = (direction + val) % 360
    elseif cmd == 'R'
        direction = (direction - val) % 360
    end
end

println(sum(abs.(ship)))

waypoint = [10, 1] # relative to ship
ship = [0, 0]
for (cmd, val) in instructions
    global ship, waypoint

    if cmd == 'N'
        waypoint += [0, val]
    elseif cmd == 'E'
        waypoint += [val, 0]
    elseif cmd == 'S'
        waypoint += [0, -val]
    elseif cmd == 'W'
        waypoint += [-val, 0]
    elseif cmd == 'F'
        ship += waypoint * val
    elseif cmd == 'L'
        waypoint = rotate(waypoint, val)
    elseif cmd == 'R'
        waypoint = rotate(waypoint, -val)
    end
    # println("$(i): ship: $(ship), wp: $(waypoint)")
end

println(sum(abs.(ship)))

mutable struct Ship
    direction::Int64
    position::Vector{Int64}
end

instructions = open("navigation_data.txt") do f
    readlines(f)
end

ship = Ship(0, [0, 0])
for i in instructions
    cmd, val = i[1], parse(Int, i[2:end])
    if cmd == 'N'
        ship.position = ship.position + [0, val]
    elseif cmd == 'E'
        ship.position = ship.position + [val, 0]
    elseif cmd == 'S'
        ship.position = ship.position + [0, -val]
    elseif cmd == 'W'
        ship.position = ship.position + [-val, 0]
    elseif cmd == 'F'
        ship.position = ship.position + [val*round(Int, cos(deg2rad(ship.direction))), val*round(Int, sin(deg2rad(ship.direction)))]
    elseif cmd == 'L'
        ship.direction = (ship.direction + val) % 360
    elseif cmd == 'R'
        ship.direction = (ship.direction - val) % 360
    end
end

println(sum(abs.(ship.position)))

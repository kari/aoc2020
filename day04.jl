fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
required_fields = fields[begin:end-1]
record_pattern = r"(?:(?:byr|iyr|eyr|hgt|hcl|ecl|pid|cid):\S+(?:\s|$))+"ms
field_pattern = r"(byr|iyr|eyr|hgt|hcl|ecl|pid|cid):(\S+)\s?"

passports = open("passport_data.txt") do f
    map(x -> x.match, eachmatch(record_pattern, read(f, String)))
end

passports = map(passport -> Dict(f.captures[1] => f.captures[2] for f in eachmatch(field_pattern, passport)), passports)

function validate_byr(field)::Bool
    if length(field) != 4 
        return false
    end
    byr = parse(Int, field)
    if 1920 <= byr <= 2002 
        return true
    end
    return false
end

function validate_iyr(field)::Bool
    if length(field) != 4 
        return false
    end
    iyr = parse(Int, field)
    if 2010 <= iyr <= 2020
        return true
    end
    return false
end

function validate_eyr(field)::Bool
    if length(field) != 4 
        return false
    end
    eyr = parse(Int, field)
    if 2020 <= eyr <= 2030
        return true
    end
    return false
end

function validate_hgt(field)::Bool
    if length(field) < 4 || length(field) > 5
        return false
    end
    unit = field[end-1:end]
    if !(unit in ["cm", "in"])
        return false
    end
    hgt = parse(Int, field[begin:end-2])
    if unit == "cm"
        if 150 <= hgt <= 193
            return true
        end
    elseif unit == "in"
        if 59 <= hgt <= 76
            return true
        end
    end
    return false
end

function validate_hcl(field)::Bool
    return occursin(r"^#[0-9a-f]{6}$", field)
end

function validate_ecl(field)::Bool
    return field in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
end

function validate_pid(field)::Bool
    return occursin(r"^\d{9}$", field)
end

function validate_passport(passport)::Bool
    validation_functions = Dict(f => getfield(Main, Symbol("validate_$(f)")) for f in required_fields)

    if !all(f -> haskey(passport, f), required_fields) 
        return false
    end
    
    for field in required_fields
        if !validation_functions[field](passport[field])
            return false
        end
    end

    return true
end

println(sum(p -> validate_passport(p), passports))

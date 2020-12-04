const fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
const required_fields = fields[begin:end-1]
const record_pattern = Regex("(?:(?:" * join(fields, "|") * raw"):\S+(?:\s|$))+", "ms")
const field_pattern = Regex("(" * join(fields, "|") * raw"):(\S+)\s?")

function validate_range(str::AbstractString, len::Int, low::Int, high::Int)::Bool
    if length(str) != len
        return false
    end
    val = parse(Int, str)
    if low <= val <= high
        return true
    end
    return false
end

function validate_byr(field::AbstractString)::Bool
    return validate_range(field, 4, 1920, 2002)
end

function validate_iyr(field::AbstractString)::Bool
    return validate_range(field, 4, 2010, 2020)
end

function validate_eyr(field::AbstractString)::Bool
    return validate_range(field, 4, 2020, 2030)
end

function validate_hgt(field::AbstractString)::Bool
    if length(field) < 3
        return false
    end
    unit = field[end-1:end]
    val = chop(field, tail = 2)
    if unit == "cm"
        return validate_range(val, 3, 150, 193)
    elseif unit == "in"
        return validate_range(val, 2, 59, 76)
    end
    return false
end

function validate_hcl(field::AbstractString)::Bool
    return occursin(r"^#[0-9a-f]{6}$", field)
end

function validate_ecl(field::AbstractString)::Bool
    return field in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
end

function validate_pid(field::AbstractString)::Bool
    return occursin(r"^\d{9}$", field)
end

function validate_required_fields(record)::Bool
    return all(f -> haskey(record, f), required_fields)
end

const validation_functions = Dict(f => getfield(Main, Symbol("validate_$(f)")) for f in required_fields)

function validate_passport(passport)::Bool
    if !validate_required_fields(passport)
        return false
    end
    
    for field in required_fields
        if !validation_functions[field](passport[field])
            return false
        end
    end

    return true
end

passports = open("passport_data.txt") do f
    map(passport -> Dict(f.captures[1] => f.captures[2] for f in eachmatch(field_pattern, passport)), map(r -> r.match, eachmatch(record_pattern, read(f, String))))
end

println(sum(p -> validate_required_fields(p), passports))
println(sum(p -> validate_passport(p), passports))

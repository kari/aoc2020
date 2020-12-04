fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
required_fields = fields[begin:end-1]
record_pattern = r"(?:(?:byr|iyr|eyr|hgt|hcl|ecl|pid|cid):\S+(?:\s|$))+"ms
field_pattern = r"(byr|iyr|eyr|hgt|hcl|ecl|pid|cid):(\S+)\s?"

passports = open("passport_data.txt") do f
    map(x -> x.match, eachmatch(record_pattern, read(f, String)))
end

passports = map(passport -> Dict(f.captures[1] => f.captures[2] for f in eachmatch(field_pattern, passport)), passports)

println(sum(p -> all(x -> haskey(p, x), required_fields), passports))
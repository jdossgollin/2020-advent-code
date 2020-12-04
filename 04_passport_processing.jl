# https://adventofcode.com/2020/day/4
"""Get all the entries"""
function parse_file(fname::String)
    read_line(line) = line == "" ? "\n" : line
    parse_entry(entry) = Dict(i => j for (i, j) in [split(field, ":") for field in split(entry, " ")])
    lines = open(fname, "r") do datafile
        lines = [read_line(line) for line in eachline(datafile)]
    end
    entries = lstrip.(rstrip.(split(join(lines, " "), "\n")))
    return [parse_entry(entry) for entry in entries]
end

"""Is a particular entry valid?"""
function required_fields_present(entry::Dict)
    entry_keys = keys(entry)
    return all([in(field, entry_keys) for field in ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]])
end
function solve1(fname::String)
    input = parse_file(fname)
    return sum([required_fields_present(entry) for entry in input])
end

function is_valid_height(hgt)
    height_parsed = match(r"(\d+)(\w+)", hgt).captures
    try
        if height_parsed[2] == "cm"
            height_cm = parse(Float64, height_parsed[1])
            return 150 <= height_cm <= 193
        elseif height_parsed[2] == "in"
            height_in = parse(Float64, height_parsed[1])
            return 59 <= height_in <= 76
        else
            return false
        end
    catch e
        return false
    end
end
function is_valid_hair_color(hcl)
    try
        color = match(r"#([0-9a-f]+)", hcl).captures[1]
        return length(color) == 6
    catch e
        return false
    end
end
function is_valid_passport_id(pid)
    try
        pid_num = parse(Int, pid)
        return length(pid) == 9
    catch e
        return 0
    end
end
is_valid_birth_year(byr) = (length(byr) == 4) & (1920 <= parse(Int, byr) <= 2002)
is_valid_issue_year(iyr) = (length(iyr) == 4) & (2010 <= parse(Int, iyr) <= 2020)
is_valid_expiration_year(eyr) = (length(eyr) == 4) & (2020 <= parse(Int, eyr) <= 2030)
is_valid_eye_color(ecl) = in(ecl, ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

"""More specific checks"""
function fields_valid(entry::Dict)
    if required_fields_present(entry)    
       return (
            is_valid_birth_year(entry["byr"]) &
            is_valid_issue_year(entry["iyr"]) &
            is_valid_expiration_year(entry["eyr"]) &
            is_valid_height(entry["hgt"]) &
            is_valid_hair_color(entry["hcl"]) &
            is_valid_eye_color(entry["ecl"]) &
            is_valid_passport_id(entry["pid"])
       )
    else
        return 0
    end
end
function solve2(fname::String)
    input = parse_file(fname)
    return sum([fields_valid(entry) for entry in input])
end

function main()
    # first part tests
    @assert solve1("demo/04.txt") == 2

    # solve first part
    solve1("inputs/04.txt") |> println
    
    # second part tests
    @assert is_valid_birth_year("2002")
    @assert !is_valid_birth_year("2003")
    @assert is_valid_height("60in")
    @assert is_valid_height("190cm")
    @assert !is_valid_height("190in")
    @assert !is_valid_height("190")
    @assert is_valid_hair_color("#123abc")
    @assert !is_valid_hair_color("#123abz")
    @assert !is_valid_hair_color("123abc")
    @assert is_valid_eye_color("brn")
    @assert !is_valid_eye_color("wat")
    @assert is_valid_passport_id("000000001")
    @assert !is_valid_passport_id("0123456789")

    # solve second part
    solve2("inputs/04.txt") |> println

end

main()
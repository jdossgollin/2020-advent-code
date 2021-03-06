# https://adventofcode.com/2020/day/2

# we want to see if each password contains between lb and ub instances of character
struct PasswordEntry
    lb::Int
    ub::Int
    character::String
    password::String
end

# parse the input file into PasswordEntry types using regex
function parse_line(line::String)
    expr = r"(\d+)-(\d+) (.): (.+)"
    m = match(expr, line)
    return PasswordEntry(parse(Int, m[1]), parse(Int, m[2]), m[3], m[4])
end

function parse_file(fname)
    return open(fname, "r") do datafile
        [parse_line(line) for line in eachline(datafile)]
    end
end

demo_input = parse_file("demo/02.txt")
input = parse_file("inputs/02.txt")

# check if a password is valid
function is_valid(entry::PasswordEntry)
    instances = findall(entry.character, entry.password)
    return entry.lb <= length(instances) <= entry.ub
end

# this is tricky -- let's check the function on the demo input (should have done this for day 1)
@assert is_valid.(demo_input) == [1; 0; 1]

# count all and get the solution for part 1
solution_01 = sum(is_valid.(input))
println("Part 01:\tThere are $solution_01 valid passwords")

# oh no, the password policy was wrong!
function revised_is_valid(entry::PasswordEntry)
    sum_entries = sum([entry.password[bound:bound] == entry.character for bound in [entry.lb, entry.ub]])
    return sum_entries == 1
end

# check function on demo input
@assert revised_is_valid.(demo_input) == [1; 0; 0]

# count all and get the solution for part 2
solution_02 = sum(revised_is_valid.(input))
println("Part 02:\tThere are $solution_02 valid passwords")

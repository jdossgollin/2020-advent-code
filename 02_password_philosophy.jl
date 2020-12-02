# https://adventofcode.com/2020/day/2

# we want to see if each password contains between lb and ub instances of letter
struct LineEntry
    lb::Int
    ub::Int
    letter::String
    password::String
end

# parse the input file into LineEntry types
function parse_line(line::String)
    segments = split(line, " ")
    lb, ub = parse.(Int, split(segments[1], "-")[1:2])
    letter = split(segments[2], ":")[1]
    password = segments[3]
    return LineEntry(lb, ub, letter, password)
end

function parse_file(fname)
    return open(fname, "r") do datafile
        [parse_line(line) for line in eachline(datafile)]
    end
end

demo_input = parse_file("demo/02.txt")
input = parse_file("inputs/02.txt")

# check if a password is valid
function is_valid_password(entry::LineEntry)
    instances = findall(entry.letter, entry.password)
    return entry.lb <= length(instances) <= entry.ub
end

# this is tricky -- let's check the function on the demo input (should have done this for day 1)
@assert is_valid_password.(demo_input) == [1; 0; 1]

# count all and get the solution for part 1
solution_01 = sum(is_valid_password.(input))
println("There are $solution_01 valid passwords")

# oh no, the password policy was wrong!
function revised_is_valid_password(entry::LineEntry)
    sum_entries = sum([entry.password[bound:bound] == entry.letter for bound in [entry.lb, entry.ub]])
    return sum_entries == 1
end

# check function on demo input
@assert revised_is_valid_password.(demo_input) == [1; 0; 0]

# count all and get the solution for part 2
solution_02 = sum(revised_is_valid_password.(input))
println("There are $solution_02 valid passwords")
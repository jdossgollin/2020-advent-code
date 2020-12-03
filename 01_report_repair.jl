# https://adventofcode.com/2020/day/1

# Read in the input file
input = open("inputs/01.txt", "r") do datafile
    [parse.(Int, line) for line in eachline(datafile)]
end

# which two entries sum to 2020?
function solve_01(input)
    N = length(input)
    for i = 1:N
        for j = 1:N
            if input[i] + input[j] == 2020
                prod_2 = input[i] * input[j]
                return prod_2
            end
        end
    end
end
solution_01 = solve_01(input)
println("The answer to part 1 for day 01 is\n\t$solution_01")

# on to part three! which _three_ entries sum to 2020?
function solve_02(input)
    N = length(input)
    for i = 1:N
        for j = 1:N
            for k = 1:N
                if input[i] + input[j] + input[k] == 2020
                    prod_3 = input[i] * input[j] * input[k]
                    return prod_3
                end
            end
        end
    end
end
solution_02 = solve_02(input)
println("The answer to part 1 for day 01 is\n\t$solution_02")
# https://adventofcode.com/2020/day/9

Input = Vector{Int}

"""The data structure for our running cross-sums will keep track of the last
n values and the values of their cross sums
"""
mutable struct RunningCrossSum
    n::Int
    s::Vector{Int}
    cross_sums::Matrix{Int}
end

"""Define a RunningCrossSum from a Vector of initial values"""
function RunningCrossSum(inits::Vector{Int})
    n = length(inits)
    cross_sums = zeros(Int, n, n)
    for i in 1:n
        for j in 1:i
            cross_sums[i, j] = inits[i] + inits[j]
        end
    end
    return RunningCrossSum(n, inits, cross_sums)
end

"""Update the RunningCrossSum"""
function add_next_value!(rcs::RunningCrossSum, x::Int)
    rcs.s = push!(rcs.s[2:rcs.n], x)
    for i in 1:(rcs.n - 1)
        for j in 1:i
            rcs.cross_sums[i, j] = rcs.cross_sums[i + 1, j + 1]
        end
    end
    for j in 1:rcs.n
        rcs.cross_sums[rcs.n, j] = rcs.s[rcs.n] + rcs.s[j]
    end
end

function parse_input(fname::String)::Input
    open(fname, "r") do datafile
        [parse(Int, line) for line in eachline(datafile)]
    end
end

function solve1(input::Input, n::Int)::Int
    rcs = RunningCrossSum(input[1:n])
    for i in (n + 1):length(input)
        if !in(input[i], rcs.cross_sums) 
            return input[i]
        end
        add_next_value!(rcs, input[i])
    end
    return -1
end

function solve2(input::Input, target::Int)::Int
    N = length(input)
    for i_start in 1:N
        running_sum = 0
        i_stop = i_start
        while running_sum < target
            running_sum += input[i_stop]
            if running_sum == target
                return minimum(input[i_start:i_stop]) + maximum(input[i_start:i_stop])
            end
            i_stop += 1
        end
    end
    return -1
end

function main()
    demo_input = parse_input("demo/09.txt")
    @assert solve1(demo_input, 5) == 127
    @assert solve2(demo_input, 127) == 62

    input = parse_input("inputs/09.txt")
    sol1 = solve1(input, 25)
    sol2 = solve2(input, sol1)
    @show sol1, sol2

end

main();
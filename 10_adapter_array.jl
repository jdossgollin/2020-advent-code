# https://adventofcode.com/2020/day/10

using Memoize, BenchmarkTools

parse_file(fname::String) = parse.(Int, readlines(fname))

get_diffs(input::Vector{Int}) = input |> x -> push!(x, 0, maximum(x) + 3) |> unique |> sort |> diff

function solve1(input::Vector{Int})
    diffs = get_diffs(input)
    return sum(diffs .== 1) * sum(diffs .== 3)
end

count_continuous_ones(Δ::Vector{Int}) = string.(Δ) |> join |> x -> split(x, "3") |> x -> filter(y -> length(y) > 0, x) .|> length

"""This algorithm maps out how many possible ways there are to get through a sequence of continuous ones"""
@memoize function n_possible_steps(n::Int)::Int
    n == 1 && return 1 # just 1
    n == 2 && return 2 # 1,1 or 2
    n == 3 && return 4 # 1,1,1 or 1,2 or 2,1 or 3
    return n_possible_steps(n - 1) + n_possible_steps(n - 2) + n_possible_steps(n - 3)
end

function solve2(input::Vector{Int})
    continuous_ones = get_diffs(input) |> count_continuous_ones
    return mapreduce(n_possible_steps, *, continuous_ones)
end

function main()
    demo_input = parse_file("demo/10.txt")
    @assert solve1(demo_input) == 220
    @assert solve2(demo_input) == 19208

    input = parse_file("inputs/10.txt")
    sol1 = solve1(input)
    sol2 = solve2(input)

    @btime solve2($input)
    @show sol1, sol2
end
main();
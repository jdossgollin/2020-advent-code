# https://adventofcode.com/2020/day/10

parse_file(fname) = parse.(Int, readlines(fname))

function solve1(input::Vector{Int})
    push!(input, 0, maximum(input) + 3)
    input = sort(unique(input))
    diffs = diff(input)
    return sum(diffs .== 1) * sum(diffs .== 3)
end

function count_continuous_ones(Δ::Vector{Int})
    counts = Vector{Int}[]
    return string.(Δ) |> join |> x -> split(x, "3") |> x -> filter(y -> length(y) > 0, x) .|> length
end

function n_possible_steps(n::Int)
    if n == 1
        return 1
    elseif n == 2
        return 2
    elseif n == 3
        return 4
    else
        return n_possible_steps(n - 1) + n_possible_steps(n - 2) + n_possible_steps(n - 3)
    end
end

function solve2(input::Vector{Int})
    push!(input, 0, maximum(input) + 3)
    input = sort(unique(input))
    diffs = diff(input)
    return mapreduce(n_possible_steps, *, count_continuous_ones(diffs))
end

function main()
    demo_input = parse_file("demo/10.txt")
    @assert solve1(demo_input) == 220
    @assert solve2(demo_input) == 19208

    input = parse_file("inputs/10.txt")
    sol1 = solve1(input)
    sol2 = solve2(input)
    @show sol1, sol2
end
main();
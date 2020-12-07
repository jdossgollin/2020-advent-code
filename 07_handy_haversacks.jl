# https://adventofcode.com/2020/day/7

using DataStructures: Stack

"""This function bakes in the assumption that all colors have two words!"""
function parse_line(line::String)
    bag_color, content_str = split(line, " bags contain ")
    if content_str == "no other bags."
        contents = Dict()
    else
        expr = r"(\d+) (\w+) (\w+) bag"
        content_list = content_str |> x -> split(x, ".")[1] |> x -> split(x, ",") .|> lstrip .|> x -> match(expr, x).captures |> x -> (parse(Int, x[1]), x[2] * " " * x[3])
        contents = Dict(color => quantity for (quantity, color) in content_list)
    end
    return Dict(bag_color => contents)
end

"""A data structure"""
struct BaggageRule
    colors::Vector{String}
    allowed::Matrix{Int}
    N::Int
end
function BaggageRule(fname::String)
    
    # read in the data as dictis
    contents = open(fname, "r") do datafile
        merge([parse_line(line) for line in eachline(datafile)]...)
    end
    colors = Dict(k => i for (i, (k, _)) in enumerate(contents)) # all the naes
    
    # convert to matrix format
    content_mtx = zeros(Int, length(colors), length(colors)) # initialization
    for (color_from, idx_from) in colors
        for (color_to, n_allowed) in contents[color_from]
            content_mtx[idx_from, colors[color_to]] += n_allowed
        end
    end
    return BaggageRule(collect(keys(colors)), content_mtx, length(colors))
end

"""Finds all the nodes that have a path to the target node"""
function is_reachable(rule, start_idx::Int, target_idx::Int)

    visited = repeat([false], rule.N) # track which nodes we have visited
    queue = Stack{Int}() # Create a queue for BFS 

    # Mark the source node as visited and enqueue it
    push!(queue, start_idx)
    visited[start_idx] = true

    while !isempty(queue)

        n = pop!(queue)
        if n == target_idx
            return true # we found a path! all done
        end
        for i in findall(rule.allowed[n, :] .> 0)
            if !visited[i]
                push!(queue, i) 
                visited[i] = true
            end
        end
    end
    return false # if we haven't found a path, there is none
end

function solve1(rule::BaggageRule; target_color="shiny gold")
    target_idx = findfirst(target_color .== rule.colors)
    candidates = filter(x -> x !== target_idx, 1:rule.N)
    return mapreduce(i -> is_reachable(rule, i, target_idx), +, candidates)
end

function bag_contents(start_idx::Int, rule::BaggageRule)
    
    queue = Stack{Int}() # Create a queue of bags to 'unpack'
    push!(queue, start_idx)
    n_bags = 0

    while !isempty(queue)
        n = pop!(queue)
        n_bags += 1
        contents = findall(rule.allowed[n, :] .> 0)
        for cidx in filter(x -> x > 0, contents)
            contents = repeat([cidx], rule.allowed[n, cidx])
            push!(queue, contents...)
        end
    end

    return n_bags # if we haven't found a path, t
end
function solve2(rule::BaggageRule; target_color="shiny gold")
    target_idx = findfirst(target_color .== rule.colors)
    return bag_contents(target_idx, rule) - 1
end

function main()
    demo_rule = BaggageRule("demo/07.txt")
    @assert solve1(demo_rule) == 4
    demo2 = BaggageRule("Demo/07b.txt")
    @assert solve2(demo2) == 126

    rule = BaggageRule("inputs/07.txt")
    sol1 = solve1(rule)
    sol2 = solve2(rule)

    @show sol1, sol2
end

main();

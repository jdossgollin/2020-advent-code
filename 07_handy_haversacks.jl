# https://adventofcode.com/2020/day/7

using DataStructures: Stack

const Contents = Dict{String,Int}
const RuleMap = Dict{SubString{String},Contents}

"""This function bakes in the assumption that all colors have two words!"""
function parse_line(line::String)
    bag_color, content_str = split(line, " bags contain ")
    if content_str == "no other bags."
        contents = Contents()
    else
        expr = r"(\d+) (\w+) (\w+) bag"
        content_list = content_str |> x -> split(x, ".")[1] |> x -> split(x, ",") .|> lstrip .|> x -> match(expr, x).captures |> x -> (parse(Int, x[1]), x[2] * " " * x[3])
        contents = Contents(color => quantity for (quantity, color) in content_list)
    end
    return RuleMap(bag_color => contents)
end

"""Read the inputs"""
function parse_file(fname::String)::RuleMap
    open(fname, "r") do datafile
        merge([parse_line(line) for line in eachline(datafile)]...)
    end
end

"""Finds all the nodes that have a path to the target node using Breadth First Search"""
function is_reachable(rule::RuleMap, start::AbstractString, target::AbstractString)

    visited = Dict(key => false for key in keys(rule)) # track which nodes we have visited
    queue = Stack{String}() # the nodes we will check 
    push!(queue, start) # add the start
    visited[start] = true

     while !isempty(queue)
        color = pop!(queue)
        if color == target
            return true # we found a path! all done
        end
        for c in keys(rule[color])
            if !visited[c]
                push!(queue, c) 
                visited[c] = true
            end
        end
    end
    return false # if we haven't found a path, there is none
end

function solve1(rule::RuleMap; target="shiny gold")
    candidates = [key for key in String.(keys(rule)) if key !== target_color]
    return mapreduce(color -> is_reachable(rule, color, target_color), +, candidates)
end

function bag_contents(rule::RuleMap, start::AbstractString)
    
    queue = Stack{String}() # Create a queue of bags to 'unpack'
    push!(queue, start)
    n_bags = 0

    while !isempty(queue)
        color = pop!(queue)
        n_bags += 1
        contents = keys(rule[color])
        for c in contents
            push!(queue, repeat([c], rule[color][c])...)
        end
    end
    
    return n_bags # if we haven't found a path, t
end

function solve2(rule::RuleMap; target="shiny gold")
    return bag_contents(rule, target) - 1 # don't count itself
end

function main()
    
    demo_rule = parse_file("demo/07.txt")
    @assert solve1(demo_rule) == 4
    demo2 = parse_file("Demo/07b.txt")
    @assert solve2(demo2) == 126

    rule = parse_file("inputs/07.txt")
    sol1 = solve1(rule)
    sol2 = solve2(rule)

    @show sol1, sol2
end

main();

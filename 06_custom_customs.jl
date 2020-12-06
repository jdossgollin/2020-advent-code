# https://adventofcode.com/2020/day/6

# every `response` is a set of characters, where one character corresponds to a question answered `yes`
const response = Set{Char}

# every `group` consists of one or more responses
const group = Vector{response}

function parse_input(fname::String)
    groups = Vector{group}()
    group_response = group()
    open(fname, "r") do datafile
        for line in eachline(datafile)
            if length(line) == 0 # it's a blank line«
                push!(groups, group_response)
                group_response = group()
            else
                push!(group_response, Set(line))
            end
        end
    end
    push!(groups, group_response)
    return groups
end

function solve1(input::Vector{group})
    mapreduce(x -> length(union(x...)), +, input)
end

function solve2(input::Vector{group})
    mapreduce(x -> length(intersect(x...)), +, input)
end

function main()
    
    demo_input = parse_input("demo/06.txt")
    input = parse_input("inputs/06.txt")

    @assert solve1(demo_input) == 11
    solve1(input) |> println

    @assert solve2(demo_input) == 6
    solve2(input) |> println

end

main();

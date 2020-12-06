# https://adventofcode.com/2020/day/6

"""Get a `Vector` of `Vector` of `SubString`s"""
function parse_input(fname::String)
    return read(fname, String) |> str -> split(str, "\n\n") .|> split
end

function solve1(input)
    mapreduce(x -> length(union(x...)), +, input)
end

function solve2(input)
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

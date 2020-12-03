# https://adventofcode.com/2020/day/3

struct TreeMap
    width::Int
    height::Int
    obs::Array{Int,2}    
end
function TreeMap(fname::String)
    @assert isfile(fname)
    obs = open(fname, "r") do datafile
        vcat([[char == '#' for char in line] for line in eachline(datafile)]'...)
    end
    height, width = size(obs)
    return TreeMap(width, height, obs)
end

demo_map = TreeMap("demo/03.txt")
input_map = TreeMap("inputs/03.txt")

"""Slope is defined so that positive is (down, right). Thus (1, 1) is top left."""
function count_trees(map::TreeMap, slope::Tuple{Int,Int})
    x, y = 1, 1
    hits = 0
    while y < map.height
        x, y = (x, y) .+ slope
        while x > map.width
            x -= map.width # arboreal genetics and biome instability: trees repeat
        end
        hits += map.obs[y, x]
    end
    return hits
end

@assert count_trees(demo_map, (3, 1)) == 7
solution_01 = count_trees(input_map, (3, 1))
@show solution_01;

possible_slopes = [
    (1, 1),
    (3, 1),
    (5, 1),
    (7, 1),
    (1, 2),
]

function slope_product(map::TreeMap, slopes::Array{Tuple{Int,Int}})
    hits = [count_trees(map, slope) for slope in slopes]
    return prod(hits)
end

@assert slope_product(demo_map, possible_slopes) == 336
solution_02 = slope_product(input_map, possible_slopes)
@show solution_02;

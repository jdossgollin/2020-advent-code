# https://adventofcode.com/2020/day/17

parse_file(fname::String)::Array{Bool} = vcat([[char == '#' for char in line] for line in readlines(fname)]'...)

# modified from https://julialang.org/blog/2016/02/iteration/
function cycle(activated::Array{Bool})
    A = zeros(Bool, size(activated) .+ 2)
    A[[2:(dimsize - 1) for dimsize in size(A)]...] .= activated
    activated2 = similar(A) # preallocate
    R = CartesianIndices(A) # all the indices
    Ifirst, Ilast = first(R), last(R) # first and last indices
    I1 = oneunit(Ifirst) # the increments
    for I in R # loop over each cell in our space
        n = 0 # number of activated numbers
        for J in max(Ifirst, I - I1):min(Ilast, I + I1) # loop over neighbors considering edge cases
            if J !== I # count only neighbors, not self
                n += A[J] # update sum of neighbors
            end
        end
        if A[I] # if a cube is active
            activated2[I] = (n == 2 || n == 3) ? true : false
        else # if a cube is inactive
            activated2[I] = n == 3 ? true : false
        end
    end
    lb, ub = findall(==(true), activated2) |> extrema # we don't need to keep zeros on the edges
    return activated2[lb:ub]
end

function solve1(fname::String)
    activated = parse_file(fname) |> x -> reshape(x, (size(x)..., 1))
    for _ in 1:6
        activated = cycle(activated)
    end
    return sum(activated)
end

function solve2(fname::String)
    activated = parse_file(fname) |> x -> reshape(x, (size(x)..., 1, 1)) # make it 4d
    for _ in 1:6
        activated = cycle(activated) # same function should work
    end
    return sum(activated)
end

function main()
    @assert solve1("demo/17.txt") == 112
    @assert solve2("demo/17.txt") == 848
    part1 = solve1("inputs/17.txt")
    part2 = solve2("inputs/17.txt")
    @show part1, part2
end
main();

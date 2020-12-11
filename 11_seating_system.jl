# https://adventofcode.com/2020/day/11

"""Define a data structure for a seat map"""
mutable struct SeatMap
    nrow::Int
    ncol::Int
    occupied::Matrix{Bool}
    floor::Matrix{Bool}
end
function SeatMap(fname::String)
    raw_input = read(fname, String) |> x -> split(x, "\n") .|> collect |> x -> hcat(x...) |> permutedims
    nrow, ncol = size(raw_input)
    occupied = @. raw_input == '#'
    floor = @. raw_input == '.'
    return SeatMap(nrow, ncol, occupied, floor)
end
function reset!(sm::SeatMap)
    @. sm.occupied = 0
end

"""Count the number of adjacent occupied seats for each seat"""
function adjacent_occupied_seats(sm::SeatMap)
    n_adjacent = zeros(Int, size(sm.floor))
    for row in 1:sm.nrow
        for col in 1:sm.ncol
            n_adjacent[row, col] = sum(@view sm.occupied[max(1, row - 1):min(sm.nrow, row + 1), max(1, col - 1):min(sm.ncol, col + 1)]) - sm.occupied[row, col]
        end
    end
    return n_adjacent
end

"""Update where people are sitting"""
function step1!(sm::SeatMap)
    n_adjacent = adjacent_occupied_seats(sm)
    for row in 1:sm.nrow
        for col in 1:sm.ncol
            if !sm.floor[row, col]
                if (!sm.occupied[row, col]) & (n_adjacent[row, col] == 0)
                    sm.occupied[row, col] = 1
                elseif sm.occupied[row, col] & (n_adjacent[row, col] >= 4)
                    sm.occupied[row, col] = 0
                end
            end
        end
    end
end

function solve1(sm::SeatMap)
    occupied = fill(-1, size(sm.occupied))
    while occupied != sm.occupied
        occupied = copy(sm.occupied)
        step1!(sm)
    end
    return sum(occupied)
end

const directions = filter(y -> y != (0, 0), [(Δx, Δy) for Δx in -1:1 for Δy in -1:1])

"""Of the first seat (not floor) visible in each direction, how many are occupied?"""
function visible_occupied_seats(sm::SeatMap, row::Int, col::Int)
    n_visible = 0
    for direction in directions
        gaze = (row, col) .+ direction
        while (1 <= gaze[1] <= sm.nrow) & (1 <= gaze[2] <= sm.ncol)
            if sm.occupied[gaze...]
                n_visible += 1
                break
            elseif !sm.occupied[gaze...] & !sm.floor[gaze...] # it's empty!
                break
            end
            gaze = gaze .+ direction
        end
    end
    return n_visible
end

"""Count visible occupied seats for each seat in sm"""
function visible_occupied_seats(sm::SeatMap)
    return [visible_occupied_seats(sm, row, col) for row in 1:sm.nrow, col in 1:sm.ncol]
end

"""Revised update rules"""
function step2!(sm::SeatMap)
    n_visible = visible_occupied_seats(sm)
    for row in 1:sm.nrow
        for col in 1:sm.ncol
            if !sm.floor[row, col]
                if (!sm.occupied[row, col]) & (n_visible[row, col] == 0)
                    sm.occupied[row, col] = 1
                elseif sm.occupied[row, col] & (n_visible[row, col] >= 5)
                    sm.occupied[row, col] = 0
                end
            end
        end
    end
end 

function solve2(sm::SeatMap)
    occupied = fill(-1, size(sm.occupied))
    while occupied != sm.occupied
        occupied = copy(sm.occupied)
        step2!(sm)
    end
    return sum(occupied)
end

function main()
    demo_input = SeatMap("demo/11.txt")
    @assert solve1(demo_input) == 37
    reset!(demo_input)
    @assert solve2(demo_input) == 26

    input = SeatMap("inputs/11.txt")
    sol1 = solve1(input)
    reset!(input)
    sol2 = solve2(input)
    
    @show sol1 sol2
end
main();
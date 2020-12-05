# https://adventofcode.com/2020/day/5

"""Get the row from a given string -- this is just binary"""
function get_row(row_str::String)
    row_str = String(replace(collect(row_str), 'B' => '1', 'F' => '0'))
    return parse(Int, row_str; base=2)
end
@assert get_row("FBFBBFF") == 44 # example val given in problem

"""Get the column from a given string -- this is just binary"""
function get_col(col_str::String)
    col_str = String(replace(collect(col_str), 'R' => '1', 'L' => '0'))
    return parse(Int, col_str; base=2)
end
@assert get_col("RLR") == 5

struct BoardingPass
    row::Int
    col::Int
    id::Int
end
function BoardingPass(line::String)
    row = get_row(line[1:7])
    col = get_col(line[8:end])
    id = 8 * row + col
    return BoardingPass(row, col, id)
end
function BoardingPass(id::Int)
    col = id % 8
    row = Int((id - col) / 8)
    return BoardingPass(row, col, id)
end
@assert BoardingPass("BFFFBBFRRR") == BoardingPass(70, 7, 567)
@assert BoardingPass("FFFBBBFRRR") == BoardingPass(14, 7, 119)
@assert BoardingPass("BBFFBBFRLL") == BoardingPass(102, 4, 820)

function solve1(input::Vector{BoardingPass})
    bp_ids = [bp.id for bp in input]
    return maximum(bp_ids) # solution to part 1
end
function solve2(input::Vector{BoardingPass})
    bp_ids = [bp.id for bp in input]
    bp_rows = [bp.row for bp in input]
    for id in minimum(bp_ids):maximum(bp_ids)
        if !in(id, bp_ids)
            pass = BoardingPass(id)
            if in(pass.row + 1, bp_rows) & in(pass.row - 1, bp_rows)
                return id
            end
        end
    end
end

function main()
    
    input = open("inputs/05.txt", "r") do datafile
        [BoardingPass(line) for line in eachline(datafile)]
    end
    
    sol1 = solve1(input)
    sol2 = solve2(input)    
    @show sol1, sol2

end

main();

# https://adventofcode.com/2020/day/16

function parse_valid_line(line::String)
    fieldname, lb1, ub1, lb2, ub2 = match(r"([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)", line).captures
    return fieldname => Set(union([parse(Int, lb1):parse(Int, ub1), parse(Int, lb2):parse(Int, ub2)]...))
end
function parse_valid_section(lines::Vector{String})
    valid_keys = Dict{String,Set{Int}}()
    for line in lines
        push!(valid_keys, parse_valid_line(line))
    end
    return valid_keys
end
parse_ticket(line::String) = line |> x -> split(x, ",") .|> x -> parse(Int, x)
function parse_input(fname::String)
    lines = readlines(fname)
    breaks = findall(lines .== "")
    valid_keys = parse_valid_section(lines[1:(breaks[1] - 1)])
    ticket = lines[(breaks[2] - 1)] |> parse_ticket
    nearby_tickets = [parse_ticket(line) for line in lines[(breaks[2] + 2):end]]
    return valid_keys, ticket, nearby_tickets
end

function is_valid(ticket::Vector{Int}, valid::Dict{String,Set{Int}})
    [any([field in validrange for validrange in values(valid)]) for field in ticket]
end

function solve1(fname::String)
    valid_range, ticket, nearby_tickets = parse_input(fname)
    invalid_sum = 0
    for t in nearby_tickets
        invalid_sum += sum(t[findall(is_valid(t, valid_range) .== false)])
    end
    return invalid_sum
end

fname = "inputs/16.txt"
function parse_ticket2(fname::String)
    valid_range, ticket, nearby_tickets = parse_input(fname)
    nearby_tickets = nearby_tickets[findall([all(is_valid(t, valid_range)) for t in nearby_tickets])]
    nearby_tickets = vcat(nearby_tickets'...)
    nfields = size(nearby_tickets)[2]
    possible_matches = zeros(Int, nfields, nfields)
    for (i, entries) in enumerate(eachcol(nearby_tickets)) 
        for (j, valid) in enumerate(values(valid_range))
            possible_matches[i,  j] =  all([in(entry, valid) for entry in entries])
        end
    end
    while !(sum(possible_matches; dims=2)[:] == ones(Int, nfields))
        for (rowidx, row) in enumerate(eachrow(possible_matches))
            if sum(row) == 1 # we can set other stuff to zero now
                row = @view possible_matches[rowidx, :]
                colidx = findfirst(row .== 1)
                possible_matches[rowidx, findall(1:nfields .!= colidx)] .= 0
                possible_matches[findall(1:nfields .!= rowidx), colidx] .= 0
            end
        end
    end
    fieldnames = collect(keys(valid_range))
    parsed_ticket = Dict(fieldnames[findfirst(row .== 1)] => ticket[i] for (i, row) in enumerate(eachrow(possible_matches)))
    return parsed_ticket
end

function solve2(fname::String)
    parsed_ticket = parse_ticket2(fname)
    return prod([isnothing(match(r"^(departure)", key)) ? 1 : val for (key, val) in parsed_ticket])
end

function main()
    @assert solve1("demo/16.txt") == 71
    sol1 = solve1("inputs/16.txt")
    @assert parse_ticket2("demo/16b.txt") == Dict("class" => 12, "row" => 11, "seat" => 13)
    sol2 = solve2("inputs/16.txt")
    @show sol1, sol2
end

main();
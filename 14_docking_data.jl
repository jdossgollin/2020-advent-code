# https://adventofcode.com/2020/day/14

using Base.Iterators: product

const bit_translate = Dict('0' => 0, '1' => 1, 'X' => missing)

struct BitString
    len::Int
    values::Vector{Union{Missing,Int}}
end
BitString(values::Vector{Int}) = BitString(length(values), values)
BitString(values::Vector{Union{Missing,Int}}) = BitString(length(values), values)
BitString(s::AbstractString) = BitString([bit_translate[c] for c in s])
BitString(x::Int) = BitString(reverse(digits(x, base=2, pad=36)))
BitString() = BitString(0)

function fillmissing(bts::BitString, x::Vector{Int})
    idx = findall(ismissing, bts.values)
    values = copy(bts.values)
    values[idx] .= x
    return BitString(values)
end
fillmissing(bts::BitString, x::T) where T <: Tuple{Vararg{Int}} = fillmissing(bts, [xᵢ for xᵢ in x])

function expand(bts::BitString)
    if any(ismissing.(bts.values))
        idx = findall(ismissing, bts.values)
        combinations = product([[0, 1] for _ in idx]...)
        return [fillmissing(bts, combo) for combo in combinations][:]
    else
        return [bts]
    end
end

decimal(x::Vector{Union{Int,Missing}}) = x .|> string |> prod |> x -> parse(Int, x, base=2)
decimal(bts::BitString) = map(x -> decimal(x.values), expand(bts))

function decode1(address::BitString, mask::BitString)
    values = copy(address.values)
    mask.values .== 1
    values[findall(x -> ismissing(x) ? false : x == 0, mask.values)] .= 0
    values[findall(x -> ismissing(x) ? false : x == 1, mask.values)] .= 1
    return BitString(values)
end

const Memory = Dict{Union{Int,Missing},BitString}

function solve1(fname::String)
    mem = Memory()
    mask = BitString()
    for line in eachline(fname)
        cmd, code = split(line, " = ")
        if cmd == "mask"
            mask = BitString(code)
        else
            loc = parse(Int, match(r"mem\[(\d+)\]", cmd).captures[1])
            address = BitString(parse(Int, code))
            mem[loc] = decode1(address, mask)
        end
    end
    return mapreduce(decimal, +, values(mem)) |> first
end

decode2(address::BitString, mask::BitString) = BitString(address.values .| mask.values)

function solve2(fname::String)
    mem = Memory()
    mask = BitString()
    for line in eachline(fname)
        cmd, code = split(line, " = ")
        if cmd == "mask"
            mask = BitString(code)
        else
            addresses = parse(Int, match(r"mem\[(\d+)\]", cmd).captures[1])  |> BitString |> bts -> decode2(bts, mask) |> expand .|> decimal .|> first
            for addr in addresses
                mem[addr] = BitString(parse(Int, code))
            end
        end
    end
    return mapreduce(decimal, +, values(mem)) |> first
end

function main()
    @assert solve1("demo/14.txt") == 165
    @assert solve2("demo/14b.txt") == 208
    sol1 = solve1("inputs/14.txt")
    sol2 = solve2("inputs/14.txt")
    @show sol1, sol2
end

main();
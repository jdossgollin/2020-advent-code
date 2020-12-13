# https://adventofcode.com/2020/day/13
using Pkg; Pkg.activate(".")

function parse_file(fname::String)
    earliest_time, departures = readlines(fname)
    earliest_time = parse(Int, earliest_time)
    departures = map(s -> s == "x" ? missing : parse(Int, s), split(departures, ","))
    return earliest_time, departures
end

first_multiple(x::Int, τ::Int) = τ * Int(ceil(x / τ))

function solve1(fname::String)
    earliest_time, bus_ids = parse_file(fname)
    bus_ids = filter(x -> !ismissing(x), bus_ids)
    depart_time, best_idx = map(x -> first_multiple(earliest_time, x), bus_ids) |> findmin
    wait_time = depart_time - earliest_time
    best_id = bus_ids[best_idx]
    return best_id  * wait_time
end

fname = "demo/13.txt"

function solve2(fname::String)
    earliest_time, all_bus_ids = parse_file(fname)
    idx = findall(!ismissing, all_bus_ids)
    bus_ids = all_bus_ids[idx]
    Δts = idx .- 1
    increment_vars = [1]
    t = 0
    for (id, Δt) in zip(bus_ids, Δts)
        increment = lcm(increment_vars...)
        while ((t + Δt) % id !== 0)
            t += increment
        end
        append!(increment_vars, id)
    end
    return t
end

function main()
    @assert solve1("demo/13.txt") == 295
    @assert solve2("demo/13.txt") == 1068781
    sol1 = solve1("inputs/13.txt") # 4315
    sol2 = solve2("inputs/13.txt") # 556100168221141
    @show sol1, sol2
end

main();

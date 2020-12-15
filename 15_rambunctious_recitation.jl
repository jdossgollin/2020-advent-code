# https://adventofcode.com/2020/day/15

mutable struct NumSeq
    spoken::Dict{Int,Int} # all the numbers spoken and the last time it was spoken
    next::Int # the next value someone must call
    t::Int # time counter
end
NumSeq() = NumSeq(Dict(), 0, 0)
function NumSeq(input::Vector{Int})
    nsq = NumSeq()
    for n in input
        nsq.t += 1
        nsq.spoken[n] = nsq.t
    end
    nsq.next = 0 # inputs don't repeat
    return nsq
end

function callout!(nsq::NumSeq)
    nsq.t += 1
    output = nsq.next
    if in(output, keys(nsq.spoken))
        nsq.next = nsq.t - nsq.spoken[output]
    else
        nsq.next = 0
    end
    nsq.spoken[output] = nsq.t # store when everything was last spoken
    return output
end

function solve(input::Vector{Int}; end_year::Int=2020)
    nsq = NumSeq(input)
    output = -1
    while nsq.t < end_year
        output = callout!(nsq)
    end
    return output
end

function main()
    @assert solve([0,3,6]; end_year=2020) == 436
    @assert solve([1,3,2]; end_year=2020) == 1
    @assert solve([2,1,3]; end_year=2020) == 10
    @assert solve([1,2,3]; end_year=2020) == 27
    @assert solve([2,3,1]; end_year=2020) == 78
    @assert solve([3,2,1]; end_year=2020) == 438
    @assert solve([3,1,2]; end_year=2020) == 1836

    @assert solve([0, 3, 6]; end_year=30000000) == 175594
    sol1 = solve([11,18,0,20,1,7,16]; end_year=2020)
    sol2 = solve([11,18,0,20,1,7,16]; end_year=30000000)
    
    @show sol1, sol2
end
main();
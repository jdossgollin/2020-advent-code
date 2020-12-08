# https://adventofcode.com/2020/day/8

const Instruction = Pair{Symbol,Int}
const Input = Vector{Instruction}

function parse_line(line::String)::Instruction
    pattern = r"(\w+) ([+()\d-]+)"
    operation, number = match(pattern, line).captures
    return Instruction(Symbol(operation), parse(Int, number))
end

mutable struct CodeEngine
    instructions::Input
    accumulator::Int
    line::Int
    terminated::Bool
end
function CodeEngine(fname::String; initial_accumulator=0, initial_line=1)
    instructions = open(fname, "r") do datafile
        [parse_line(line) for line in eachline(datafile)]
    end
    return CodeEngine(instructions, initial_accumulator, initial_line, false)
end

function execute!(engine::CodeEngine)
    operation, number = engine.instructions[engine.line]
    if (operation == :acc)
        engine.accumulator += number
        engine.line += 1
    elseif (operation == :jmp)
        engine.line += number
    elseif (operation == :nop)
        engine.line += 1
    else
        throw("Invalid Key")
    end
    if engine.line > length(engine.instructions)
        engine.terminated = true
    end
end

function reset!(engine::CodeEngine)
    engine.line = 1
    engine.accumulator = 0
    engine.terminated = false
end

function solve1(engine::CodeEngine)
    lines_visited = repeat([0], length(engine.instructions))
    lines_visited[engine.line] += 1
    while !any(lines_visited .> 1)
        execute!(engine)
        lines_visited[engine.line] += 1
    end
    return engine.accumulator
end

function is_infinite_loop(engine::CodeEngine)
    lines_visited = repeat([0], length(engine.instructions))
    lines_visited[engine.line] += 1
    while !any(lines_visited .> 1)
        execute!(engine)
        engine.terminated && return false # we terminated before looping around!
        lines_visited[engine.line] += 1
    end
    return true # sadly we repeated
end

function solve2(engine::CodeEngine)
    mapping = Dict(:acc => :acc, :jmp => :nop, :nop => :jmp)
    swap_instruction(instruction::Instruction) = Instruction(mapping[instruction[1]], instruction[2])
    for (line, instr) in enumerate(engine.instructions)
        if in(instr[1], [:jmp, :nop])
            candidate = CodeEngine(copy(engine.instructions), engine.accumulator, engine.line, engine.terminated)
            candidate.instructions[line] = swap_instruction(instr)
            if !is_infinite_loop(candidate)
                reset!(candidate)
                while !candidate.terminated
                    execute!(candidate)
                end
                return candidate.accumulator
            end
        end
    end
end

function main()

    demo_engine = CodeEngine("demo/08.txt")
    @assert solve1(demo_engine) == 5
    input = CodeEngine("inputs/08.txt")
    sol1 = solve1(input)
    
    @assert is_infinite_loop(demo_engine)
    @assert is_infinite_loop(input)
    @assert solve2(demo_engine) == 8
    
    sol2 = solve2(input)
    @show sol1, sol2

end
main();
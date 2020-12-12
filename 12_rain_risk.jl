# https://adventofcode.com/2020/day/12

struct Instruction
    action::Char
    value::AbstractFloat
end
function Instruction(line::String)
    action, value = match(r"(\w)(\d+)", line).captures
    return Instruction(action[1], parse(Float64, value))
end

mutable struct Ship{T <: AbstractFloat}
    x::T
    y::T
    θ::T
end

function solve1(fname::String)
    ship = Ship(0., 0., 0.)
    for line in eachline(fname)
        instr = Instruction(line)
        if instr.action == 'N'    
            ship.y += instr.value
        elseif instr.action == 'S'
            ship.y -= instr.value
        elseif instr.action == 'E'
            ship.x += instr.value
        elseif instr.action == 'W'
            ship.x -= instr.value
        elseif instr.action == 'L'
            ship.θ = (ship.θ + instr.value) % 360
        elseif instr.action == 'R'
            ship.θ = (ship.θ - instr.value) % 360
        elseif instr.action == 'F'
            ship.x += cosd(ship.θ) * instr.value
            ship.y += sind(ship.θ) * instr.value
        else
            throw("Invalid action")
        end
    end
    return Int(abs(ship.x) + abs(ship.y))
end

"""A ship with waypoint"""
mutable struct Ship2{T <: AbstractFloat}
    x::T # ship location
    y::T
    Δx::T # waypoint relative to ship
    Δy::T
end

"""Revolve waypoint around ship"""
function revolve!(s::Ship2, θ)
    R = [cosd(θ) -sind(θ); sind(θ) cosd(θ)] # hooray linear algebra
    s.Δx, s.Δy = R * [s.Δx; s.Δy]
end

"""Move ship towards waypoint"""
function move_towards!(s::Ship2, d)
    s.x += s.Δx * d
    s.y += s.Δy * d
end

function solve2(fname::String)
    ship = Ship2(0., 0., 10., 1.)
    for line in eachline(fname)
        instr = Instruction(line)
        if instr.action == 'N'
            ship.Δy += instr.value
        elseif instr.action == 'S'
            ship.Δy -= instr.value
        elseif instr.action == 'E'
            ship.Δx += instr.value
        elseif instr.action == 'W'
            ship.Δx -= instr.value
        elseif instr.action == 'L'
            revolve!(ship, instr.value)
        elseif instr.action == 'R'
            revolve!(ship, -instr.value)
        elseif instr.action == 'F'
            move_towards!(ship, instr.value)
        else
            throw("Invalid action")
        end
    end
    return Int(abs(ship.x) + abs(ship.y))
end

function main()
    @assert solve1("demo/12.txt") == 25
    @assert solve2("demo/12.txt") == 286
    sol1 = solve1("inputs/12.txt")
    sol2 = solve2("inputs/12.txt")
    @show sol1, sol2
end
main();
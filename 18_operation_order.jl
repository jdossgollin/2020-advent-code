# https://adventofcode.com/2020/day/18

|(x₁, x₂) = x₁ * x₂ # multiplication operator with precedence of addition
/(x₁, x₂) = x₁ + x₂ # addition operator with precedence of division

solve1(line::String) = line |> l -> replace(l, '*' => '|') |> Meta.parse |> eval
solve2(line::String) = line |> l -> replace(l, '*' => '|') |> l -> replace(l, '+' => '/') |> Meta.parse |> eval

function main()
    @assert solve1("1 + 2 * 3 + 4 * 5 + 6") == 71
    sol1 = sum(solve1(l) for l in eachline("inputs/18.txt"))
    @assert solve2("1 + 2 * 3 + 4 * 5 + 6") == 231
    sol2 = sum(solve2(l) for l in eachline("inputs/18.txt"))
    @show sol1, sol2
end
main();
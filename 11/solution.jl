mutable struct Monky
    items::Vector{Int}
    operation
    test_int::Int
    t_monky::Int
    f_monky::Int
    inspections::Int

    Monky(items, operation, test_int, t_monky, f_monky) = new(items, operation, test_int, t_monky, f_monky, 0)
end

function read_monky_data(f)
    # Monky declaration
    line = readline(f)
    # Items
    line = readline(f)
    s = split(line, ':')
    items = Vector{Int}()
    for i in split(s[2], ',')
        push!(items, parse(Int, i))
    end 
    # Operations
    line = readline(f)
    s = split(line, '=')
    operation = eval(quote
        old -> $(Meta.parse(s[2]))
    end)
    # Test
    line = readline(f)
    s = split(line, ' ')
    test_int = parse(Int, s[end])
    # True
    line = readline(f)
    s = split(line, ' ')
    t_monky = parse(Int, s[end])
    # False
    line = readline(f)
    s = split(line, ' ')
    f_monky = parse(Int, s[end])
    # Empty
    line = readline(f)

    return Monky(items, operation, test_int, t_monky, f_monky)
end 

function play_round!(monkys::Vector{Monky}, ::Val{N}) where N

    mod_int = 1
    for monky in monkys
        mod_int *= monky.test_int
    end 

    for monky in monkys
        for i in monky.items
            v = monky.operation(i)::Int
            value = if (N) Int(floor( v / 3)) else v end
            value = value % mod_int
            monky.inspections += 1
            idx = if (value % monky.test_int == 0)
                monky.t_monky + 1
            else 
                monky.f_monky + 1
            end 
            push!(monkys[idx].items, value)
        end 
        empty!(monky.items)
    end 
end

monkys = Vector{Monky}()
open("./11/input.txt") do f 
    while !eof(f)
        # Push monky
        push!(monkys,  read_monky_data(f))
    end 
end

div = Val{true}()
for i in 1:20
    play_round!(monkys, div)
end

inspections = Vector{Int}()
for monky in monkys
    push!(inspections, monky.inspections)
end
sort!(inspections, rev=true)

println("1: Monkey business ", inspections[1] * inspections[2])

monkys = Vector{Monky}()
open("./11/input.txt") do f 
    while !eof(f)
        # Push monky
        push!(monkys,  read_monky_data(f))
    end 
end

div = Val{false}()
for i in 1:10_000
    play_round!(monkys, div)
end 

inspections = Vector{Int}()
for monky in monkys
    push!(inspections, monky.inspections)
end

sort!(inspections, rev=true)
println("2: Monkey business ", inspections[1] * inspections[2])
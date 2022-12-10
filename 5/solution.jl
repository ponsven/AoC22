function make_moves(stack, from, to, number)
    len = length(from)
    if (length(to) != len) error("Invalid input") end
    for i in 1:len
        for _ in 1:number[i]
            push!(stack[to[i]], pop!(stack[from[i]]))
        end 
    end 
end

function make_moves_new(stack, from, to, number)
    len = length(from)
    if (length(to) != len) error("Invalid input") end
    tmp = Vector{eltype(stack[1])}()
    for i in 1:len
        for _ in 1:number[i]
            push!(tmp, pop!(stack[from[i]]))
        end 
        for _ in 1:number[i]
            push!(stack[to[i]], pop!(tmp))
        end 
    end 
end

function top_cartes(stack)
    str = ""
    len = length(stack)
    for i in 1:len
        str *= stack[i][end]
    end 
    return str
end


stack = Vector{Vector{Char}}()
from  = Vector{Int}()
to    = Vector{Int}()
number = Vector{Int}()

stack_index(i) = Int((i - 1)/4) + 1
open("./5/input.txt") do f 
    maxstack = 0
    while !eof(f)
        line = readline(f)
        if (isempty(line))
            break
        end
        for idx in findall('[', line)
            i = stack_index(idx)
            while (i > maxstack)
                push!(stack, Vector{Char}())
                maxstack += 1
            end 
            push!(stack[i], line[idx+1])
        end
    end 
    for line in readlines(f)
        p = split(line, ' ')
        push!(number, parse(Int, p[2]))
        push!(from, parse(Int, p[4]))
        push!(to, parse(Int, p[6])) 
    end 
end 

for s in stack
    reverse!(s) 
end 


first = false
if (first)
    make_moves(stack, from, to, number)
    println("1: Top -- ", top_cartes(stack))
else 
    make_moves_new(stack, from, to, number)
    println("2: Top -- ", top_cartes(stack))
end 

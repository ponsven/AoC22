
struct Op{I} 
    isAdd::Bool
    value::I
end

instructions = Vector{Op{Int}}()
open("./10/input.txt") do f
    for line in readlines(f)
        if (line == "noop")
            push!(instructions, Op{Int}(false, 0))
        else     
            s = split(line, ' ')
            push!(instructions, Op{Int}(true, parse(Int, s[2])))
        end 
    end 
end 

mutable struct CPU 
    redy::Bool
    X::Int
    op::Op{Int}
    i::Int
    ins::Vector{Op{Int}}
    done::Bool
end

isDone(cpu::CPU) = cpu.done

function load_ins!(cpu::CPU)
    if (cpu.redy)
        cpu.op = cpu.ins[cpu.i]
    end 
    nothing
end

function performe_ins!(cpu::CPU)
    if (cpu.op.isAdd)
        if (cpu.redy)
            cpu.redy = false 
        else 
            cpu.redy = true
            cpu.X += cpu.op.value
            cpu.i += 1
        end 
    else 
        cpu.redy = true
        cpu.i += 1
    end 
    if (cpu.i > length(cpu.ins) && cpu.redy)
        cpu.done = true
    end 
end 


CTR = Vector{Char}(undef, 40*6)
fill!(CTR, ' ')


cpu = CPU(true, 1, Op{Int}(false, 0), 1, instructions, false)
cycel = 1
strength = 0
while (!isDone(cpu))
    load_ins!(cpu)

    if ((20 + cycel) % 40) == 0 
        strength += cycel*cpu.X
    end 

    if (abs(((cycel - 1) % 40) - cpu.X) < 2)
        CTR[cycel] = '#'
    else 
        CTR[cycel] = ' '
    end 

    performe_ins!(cpu)
    cycel += 1    
end 

println("1: Sum of signal strength ", strength)

println("2: Screen output")
c = 1 
while (c <= 6*40)
    print(CTR[c])
    if (c % 40 == 0)
        println()
    end 
    c += 1
end


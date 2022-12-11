using StaticArrays
using BenchmarkTools

mutable struct move_buffer{N, I}
    buf::MVector{N, I}
    idx::I
end 

function next_signal(buf::move_buffer{N, I}, c) where {I, N}
    ic = I(c)
    buf.buf[buf.idx] = ic
    buf.idx = (buf.idx % N) + 1 
    return match
end 

function unique_signal(buf::move_buffer{N, I}) where {I, N}
    for i in 1:N
        for j in (i+1):N
            if (buf.buf[i] == buf.buf[j]) return false end
        end
    end 
    return true
end 

signal = Vector{Char}()
open("./6/input.txt") do f 
    line = readline(f)
    for i in line
        push!(signal, i)
    end 
end 

function find_first_N_unique(::Val{N}, signal) where {N}
    idx = N
    start = @view signal[1:N]
    buf = move_buffer{N, Int}(start, 1)
    while (!unique_signal(buf))
        idx += 1
        next_signal(buf, signal[idx])
    end
    return idx
end 

println("1: First unique at ", find_first_N_unique(Val{4}(), signal))
println("2: First unique at ", find_first_N_unique(Val{14}(), signal))

@btime find_first_N_unique(Val{14}(), signal)

using BenchmarkTools

function parse_input(f)
    cal = zeros(Int64,0)
    while !eof(f)
        c = 0
        while !eof(f)
            line = readline(f)
            if (isempty(line))
                break
            end 
            c += parse(Int64, line)
        end
        push!(cal,c)
    end 
    return cal
end 

function find_k_top_values(cal, k)
    idx = 1
    top = zeros(Int64, k)
    for c in cal
        if (c > top[idx])
            top[idx] = c
            _, idx = findmin(top)
        end 
    end 
    sort!(top)
    return top
end 

open("./1/input1.txt") do f
    cal = parse_input(f)
end 
top = find_k_top_values(cal, 3)

println("Maximun value: ", maximum(top))
println("Sum top 3 value: ", sum(top))
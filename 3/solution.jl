function ComValue(x)
    if (x >= 97) return x - 96
    else return x - 64 + 26 end
end 

compartment_1 = Vector{String}()
compartment_2 = Vector{String}()
full = Vector{String}()

open("./3/input.txt") do f 
    for line in readlines(f)
        len = Int(length(line)/2)
        s1 = line[1:len]
        s2 = line[len+1:end]
        push!(compartment_1, s1)
        push!(compartment_2, s2)
        push!(full, line)
    end 
end 


num = length(compartment_1)
value = 0
for i in 1:num 
    for c in intersect(Set(compartment_1[i]), Set(compartment_2[i]))
        value += ComValue(Int(c))
    end 
end 
println("1: Value is ", value)

len = length(full)
i = 1; 
value = 0
while (i < len)
    if ((i + 2) > len) error("Invalid input") end
    common = intersect(Set(full[i]), Set(full[i+1]), Set(full[i+2]))
    for c in common
        value += ComValue(Int(c))
    end 
    i += 3
end 
println("2: Value is ", value)

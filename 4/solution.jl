using BenchmarkTools

struct range{I}
    low::I
    high::I
end

function Base.contains(h::range{I}, n::range{I}) where I
    return (h.low <= n.low) && (n.high <= h.high) 
end 

function overlap(h::range{I}, n::range{I}) where I
    if (h.low <= n.high) return (n.low <= h.high) end 
    if (n.low <= h.high) return (h.low <= n.high) end
    return false  
end 

function number_full_overlaps(first, second)
    len = length(first)
    if (length(second) != len) error("List must be of the same length.") end
    tot = 0
    @inbounds for i in 1:len
        if (contains(first[i], second[i]) || contains(second[i], first[i]))
            tot += 1
        end 
    end
    return tot
end 

function number_overlaps(first, second)
    len = length(first)
    if (length(second) != len) error("List must be of the same length.") end
    tot = 0 
    @inbounds for i in 1:len 
        if (overlap(first[i], second[i])) tot += 1 end
    end 
    return tot
end 

first  = Vector{range{Int}}()
second = Vector{range{Int}}()

open("./4/input.txt") do f 
    for line in readlines(f)
        s = split(line,',')
        s2 = split(s[1],'-')
        s3 = split(s[2],'-')
        push!(first, range(parse(Int, s2[1]), parse(Int, s2[2])))
        push!(second, range(parse(Int, s3[1]), parse(Int, s3[2])))
    end 
end 


println("1: Number of contains ", number_full_overlaps(first, second))
println("2: Number of overlaps ", number_overlaps(first, second))


@btime number_full_overlaps($first,$second)
@btime number_overlaps($first,$second)

nothing
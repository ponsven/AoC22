lines = Vector{String}()
open("./12/input.txt") do f 
    for line in readlines(f)
        push!(lines, line)
    end 
end 

function height(c::Char)
    if (c == 'S')
        return 0
    elseif (c == 'E')
        return 25 
    else 
        return Int(c) - 97
    end 
end

rows = length(lines)
cols = length(lines[1])

h = Matrix{Int}(undef, rows+2, cols+2)
fill!(h, -99)
start = (0, 0)
goal = (0, 0)
for r in 1:rows 
    for c in 1:cols
        h[r+1, c+1] = height(lines[r][c])
        if (lines[r][c] == 'S')
            start = (r+1, c+1)
        end 
        if (lines[r][c] == 'E')
            goal = (r+1, c+1)
        end 
    end
end  


function shortestpath!(l, h, start, next, prev)
    len = 0
    while (l[start...] == -1)
        next, prev = prev, next
        if (length(prev) == 0)
            return -1
        end
        for pos in prev
            if (l[pos...] != -1)
                continue
            end
            l[pos...] = len
            
            toMin = h[pos...] - 1
            # Up
            if (toMin <= h[pos[1]+1, pos[2]])
                push!(next, (pos[1]+1, pos[2]))
            end 
            # Down
            if (toMin <= h[pos[1]-1, pos[2]])
                push!(next, (pos[1]-1, pos[2]))
            end 
            # Right
            if (toMin <= h[pos[1], pos[2]+1])
                push!(next, (pos[1], pos[2]+1))
            end 
            # Left
            if (toMin <= h[pos[1], pos[2]-1])
                push!(next, (pos[1], pos[2]-1))
            end 
        end 
        empty!(prev)
        len += 1
    end 
    return l[start...]
end 


l = Matrix{Int}(undef, rows+2, cols+2)
fill!(l, -1)

next = Vector{Tuple{Int,Int}}()
prev = Vector{Tuple{Int,Int}}()
push!(next,goal)

shortest = shortestpath!(l, h, start, next, prev)

println("1: Shortest path ", shortest)

for pos in eachindex(h)
    if (h[pos] == 0)
        # Longer then shortest from first
        if (l[pos] == -1)
            continue
        end 
        if (l[pos] < shortest)
            shortest = l[pos]
        end 
    end 
end 

println("2: Shortest path ", shortest)




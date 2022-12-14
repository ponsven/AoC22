
lines = Vector{String}()
open("./8/input.txt") do f 
    for line in readlines(f)
        push!(lines, line)
    end 
end

cols = length(lines)
rows = length(lines[1])

forest = Matrix{Int}(undef, rows, cols)
for i in 1:cols 
    c = split(lines[i], "")
    for j in 1:rows 
        forest[i, j] = parse(Int, c[j])
    end
end 


function find_visable!(visable, forest)
    rows, cols = size(visable)
    fill!(visable, 0)
    for idx in 1:cols
        top = -1 
        for i in 1:rows
            t = forest[i, idx]
            if (t > top)
                top = t
                visable[i, idx] = 1
            end 
        end 
        top = -1 
        for i in rows:-1:1
            t = forest[i, idx]
            if (t > top)
                top = t
                visable[i, idx] = 1
            end 
        end 
    end 

    for idx in 1:rows
        top = -1 
        for i in 1:cols
            t = forest[idx, i]
            if (t > top)
                top = t
                visable[idx, i] = 1
            end 
        end 
        top = -1 
        for i in cols:-1:1
            t = forest[idx, i]
            if (t > top)
                top = t
                visable[idx, i] = 1
            end 
        end 
    end 
end 

visable = Matrix{Int}(undef, rows, cols)
find_visable!(visable, forest)
println("1: Number of visable trees ", sum(visable))

function score(forest, i, j)
    c = forest[i, j]
    # To the up
    u = 0
    for ii in (i-1):-1:1
        u += 1
        if (c <= forest[ii,j]) 
            break
        end 
    end

    # To the left
    l = 0
    for jj in (j-1):-1:1
        l += 1
        if (c <= forest[i,jj]) 
            break
        end 
    end

    # To the right
    r = 0
    for jj in (j+1):1:cols
        r += 1
        if (c <= forest[i,jj]) 
            break
        end 
    end

    # To the down
    d = 0
    for ii in (i+1):1:rows
        d += 1
        if (c <= forest[ii,j]) 
            break
        end 
    end

    return u * l * r * d
end 


top_score = -1
for i in 1:rows
    for j in 1:cols 
        s = score(forest, i, j)
        if (s > top_score)
            top_score = s 
        end 
    end 
end 

top_score



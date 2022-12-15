using StaticArrays
using BenchmarkTools

@enum DIRECTION R=1 L=2 U=3 D=4

function Direction(d::Char)
    if     (d == 'R') return R
    elseif (d == 'L') return L
    elseif (d == 'U') return U
    elseif (d == 'D') return D 
    else error("Invalid direction") end  
end 

function move_head!(H, d)
    if     (d == Int(R)) H[1] += 1
    elseif (d == Int(L)) H[1] -= 1
    elseif (d == Int(U)) H[2] += 1
    elseif (d == Int(D)) H[2] -= 1
    else error("Invalid direction") end
end 

function tail_move(T, H)
    if     (abs(H[1] - T[1]) > 1) return true
    elseif (abs(H[2] - T[2]) > 1) return true
    else return false end 
end 

function move_tail!(T, H)
    T[1] += sign(H[1] - T[1]) 
    T[2] += sign(H[2] - T[2])
    nothing
end 

directions = Vector{Int}()
number     = Vector{Int}()
open("./9/input.txt") do f 
    for line in readlines(f)
        s = split(line, " ")
        push!(directions, Int(Direction(s[1][1])))
        push!(number, parse(Int, s[2]))
    end 
end 


H = MVector{2, Int}(undef)
fill!(H, 0)
T = MVector{2, Int}(undef)
fill!(T, 0)


Thistory = Vector{Tuple{Int, Int}}()

len = length(number)
for i in 1:len
    for _ in 1:number[i]
        move_head!(H, directions[i])
        if (tail_move(T, H)) move_tail!(T, H) end 
        if !((T[1], T[2]) in Thistory) push!(Thistory, (T[1], T[2])) end
    end 
end 

println("1: Number of vistied spots ", length(Thistory))


function model_rope!(rope, directions, number, Thistory)
    # Set head 
    H = @view rope[1, :]
    T = @view rope[end, :]

    tmp = size(rope)
    knots = tmp[1]
    len = length(number)
    for i in 1:len
        for _ in 1:number[i]

            move_head!(H, directions[i])
            for j in 1:(knots-1)
                T1 = @view rope[j, :] 
                T2 = @view rope[j+1, :] 
                if (tail_move(T2, T1)) move_tail!(T2, T1) end
            end 
            if !((T[1], T[2]) in Thistory) push!(Thistory, (T[1], T[2])) end
        end 
    end 
end


# rope = MMatrix{10, 2, Int}(undef)
# fill!(rope, 0)
# Thistory = Vector{Tuple{Int, Int}}()
# @btime model_rope!($rope, $directions, $number, $Thistory)
# 
# rope = MMatrix{10, 2, Int}(undef)
# fill!(rope, 0)
# Thistory = Set{Tuple{Int,Int}}()
# @btime model_rope!($rope, $directions, $number, $Thistory)


rope = MMatrix{10, 2, Int}(undef)
fill!(rope, 0)
Thistory = Set{Tuple{Int,Int}}()
model_rope!(rope, directions, number, Thistory)
println("2: Number of vistied spots ", length(Thistory))
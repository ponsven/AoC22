
@enum OShape A=1 B=2 C=3
@enum YShape X=1 Y=2 Z=3

function parse_OShape(x)
    if (x == "A") return A end 
    if (x == "B") return B end 
    if (x == "C") return C end 
    error("Invalid input!")
end 

function parse_YShape(x)
    if (x == "X") return X end 
    if (x == "Y") return Y end 
    if (x == "Z") return Z end 
    error("Invalid input!")
end 

function scoore(o, y)
    if (o == y) return y+3 end 
    oo = OShape(o)
    yy = YShape(y)
    s = 0
    if (yy == X)  # Rock 
        if (oo == C) s = 6 end
    elseif  (yy == Y)  # Paper
        if (oo == A) s = 6 end
    else  # Scissors 
        if (oo == B) s = 6 end
    end 
    return y + s
end 

function youchoise(o, y)
    yy = YShape(y)
    if (yy == Y) return o end 
    oo = OShape(o)
    if (yy == X) # To lose 
        if (oo == A) return 3
        elseif (oo == B) return 1
        else return  2
        end 
    else # to win 
        if (oo == A) return 2
        elseif (oo == B) return 3
        else return  1
        end
    end 
end


Ochoise = zeros(Int,0)
Ychoise = zeros(Int,0)
open("./2/input.txt") do f
    for line in readlines(f)
        pline = split(line,' ')
        push!(Ochoise,Int(parse_OShape(pline[1])))
        push!(Ychoise,Int(parse_YShape(pline[2])))
    end 
end 


len = length(Ochoise)
tot = 0
for i in 1:len
    tot += scoore(Ochoise[i], Ychoise[i])
end 
println("1: Total scoore: ", tot)



len = length(Ochoise)
tot = 0
for i in 1:len
    o = Ochoise[i]
    y = Ychoise[i]
    tot += scoore(o, youchoise(o, y))
end 
println("2: Total scoore: ", tot)

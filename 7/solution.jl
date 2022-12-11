
mutable struct System 
    max::Int
    name::Vector{String}
    dir::Vector{Bool}
    size::Vector{Int}
    parent::Vector{Int}
    child::Vector{Vector{Int}}
end

function print_system(system, idx, pre)
    if (system.dir[idx])
        println(pre, system.name[idx], " (dir)  -- ", string(system.size[idx]))
    else 
        println(pre, system.name[idx], "(file, size=", string(system.size[idx]), ")")
    end 
    pre = "  " * pre
    for i in system.child[idx]
        print_system(system, i, pre)
    end
end 

function print_system(system)
    idx = 1
    pre = "-"
    print_system(system, idx, pre)
end 

function mkdir!(system, pos, dir)
    system.max += 1
    if (dir == "/")
        if (system.max != 1) error("Can only add root to empty system") end
        cpos = 0
    else 
        cpos = pos
        push!(system.child[pos], system.max)
    end 
    push!(system.name, dir)
    push!(system.dir, true)
    push!(system.size, 0)
    push!(system.parent, cpos)
    push!(system.child, Vector{Int}())
end 

function touch(system, pos, size, name)
    system.max += 1
    push!(system.name, name)
    push!(system.dir, false)
    push!(system.size, size)
    push!(system.parent, pos)
    push!(system.child, Vector{Int}()) 
    push!(system.child[pos], system.max)
end 

function cd(system, pos, dir)
    if (dir == "/") return 1 
    elseif (dir == "..") return system.parent[pos]
    else
        child = system.child[pos]
        for i in eachindex(child)
            if (system.name[child[i]] == dir)
                return child[i]
            end 
        end 
        error("No file found: ", dir)
    end 
end

function ls!(system, pos, f)
    while !eof(f)
        c = peek(f, Char)
        if (c == '$')
            return nothing
        end 
        line = split(readline(f), ' ')
        if (line[1] == "dir")
            mkdir!(system, pos, line[2])
        else
            touch(system, pos, parse(Int, line[1]), line[2])
        end 
    end
    return nothing
end

system = System(0, Vector{String}(), Vector{Bool}(), Vector{Int}(), Vector{Int}(), Vector{Vector{Int}}())
# Push root
mkdir!(system, 0, "/")
open("./7/input.txt") do f 
    pos = 0
    while !eof(f)
        command = split(readline(f), ' ')

        if (command[1] == "\$")
            if (command[2] == "cd")
                pos = cd(system, pos, command[3])
            elseif (command[2] == "ls")
                ls!(system, pos, f)
            else error("Unsupported comamnd!") end
        end 
    end 
end 


function update(system, idx)
    for i in system.child[idx]
        if (system.dir[i])
            if (system.size[i] == 0)
                system.size[idx] += update(system, i)
            else 
                system.size[idx] += system.size[i]
            end 
        else 
            system.size[idx] += system.size[i]
        end 
    end 
    return system.size[idx]
end 

# Update dir size
function update(system)
    len = system.max
    for i in 1:len
        if (system.dir[i]) system.size[i] = 0 end
    end 
    update(system,1)
end 

update(system)
print_system(system)

tot = 0
for i in 1:(system.max)
    if (system.dir[i])
        if (system.size[i] < 100000) tot += system.size[i] end
    end 
end 

println("1: Total size ", tot)


smallest = typemax(Int)
idx = -1
unused = 70000000 - system.size[1]
needed = 30000000 - unused

for i in 1:system.max
    if (system.dir[i])
        if (system.size[i] > needed && system.size[i] < smallest)
            smallest = system.size[i]
            idx = i
        end 
    end 
end 

println("2: Smallest size ", smallest)

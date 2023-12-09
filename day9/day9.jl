function readlines_from_file(filename)
    f = open(filename, "r")
    lines = readlines(f)
    close(f)
    return lines
end

function extrap(x)
    if isempty(x)
        return 0
    else
        return last(x) + extrap(diff(x))
    end
end

function parse_int(s)
    parts = split(s)
    numbers = Int[]
    for part in parts
        push!(numbers, parse(Int, part))
    end
    return numbers
end

lines = readlines_from_file("day9.in")

V = [parse_int(l) for l in lines]

ans1 = sum([extrap(v) for v in V])
ans2 = sum([extrap(reverse(v)) for v in V])

println("ans1 = $ans1")
println("ans2 = $ans2")

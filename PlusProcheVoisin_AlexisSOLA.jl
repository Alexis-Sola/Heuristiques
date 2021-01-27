INF = 10000000
nh = 5

data = [0 3 4 2 7;
3 0 4 6 3;
4 4 0 5 8;
2 6 5 0 6;
7 3 8 6 0]

used = [0 0 0 0 0 0;
0 0 0 0 0 0;
0 0 0 0 0 0;
0 0 0 0 0 0;
0 0 0 0 0 0]

function f(s)
    tmp = []
    final = 0
    for i in 1:nh - 1
        append!(tmp, data[s[i], s[i + 1]])
        final = s[i + 1]
    end
    append!(tmp, data[s[1], final])
    return sum(tmp)
end

function MarkUse(id)
    if(id != 0)
        for i in 1:nh
            used[i, id] = 1
        end
    end
end

function PlusProcheVoisin(line, s)
    prec = INF
    id = 0
    for i in 1:nh
        current = data[line, i]
        if current < prec && current != 0 && used[line, i] != 1
            prec = data[line, i]
            id = i
        end
    end
    return id
end

function HeuristiquePlusProcheVoisin()
    s = []
    depart = 1
    append!(s, depart)

    for i in 1:nh - 1
        MarkUse(depart)
        next = PlusProcheVoisin(depart, s)
        append!(s, next)
        depart = next
    end
    return s
end

@time begin
  f(HeuristiquePlusProcheVoisin())
end

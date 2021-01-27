nh = 5

data = [0 3 4 2 7;
3 0 4 6 3;
4 4 0 5 8;
2 6 5 0 6;
7 3 8 6 0]

s0 = [1 2 3 4 5]
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

#On inverse le sens d'un sommet
function Swap(s,id)
    nb1 = id
    if nb1 != nh
        val1 = s[nb1]
        val2 = s[nb1 + 1]
        s[nb1] = val2
        s[nb1 + 1] = val1
    end
    return s
end

function AlgoRechercheLocale()
    s_star = s0
    z = f(s0)
    for i in 1:nh-1
        new_s = Swap(s_star, i)
        if f(new_s) < z
            break
        end
        s_star = new_s
        z = f(new_s)
    end
    return s_star
end

@time begin
    f(AlgoRechercheLocale())
end

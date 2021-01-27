using JuMP, Cbc
using Random

nh = 5
data = [0 3 4 2 7;
3 0 4 6 3;
4 4 0 5 8;
2 6 5 0 6;
7 3 8 6 0]

m = Model(Cbc.Optimizer)

#Définition des variables d'entrées du modèle
@variable(m, x[1:nh, 1:nh], Bin) #matrice binaire permettant de savoir le chemin à effectuer
@variable(m, u[1:nh], Int) #vecteur de solution

#Définition de la fonction objective
@objective(m, Min, sum(data[i, j] * x[i,j] for i in 1:nh, j in 1:nh)) #fonction objective à minimiser

#Définition des contraintes
@constraint(m, [i = 1:nh], x[i,i] == 0) #la diagonale de la matrice doit être égale à zéro
@constraint(m, [i = 1:nh], sum(x[i,j] for j in 1:nh) == 1) #la somme d'une ligne de la matrice doit être égale à un
@constraint(m, [i = 1:nh], sum(x[j,i] for j in 1:nh) == 1) #la somme d'une colonne de la matrice doit être égale à un
@constraint(m, u[1] == 1) #le point de départ est un

# Cette partie permet de rendre l'arbre connexe
@constraint(m, [i = 2:nh], nh >= u[i] >= 2)
@constraint(m, [i in 2:nh, j in 2:nh], u[i] - u[j] + 1 <= nh * (1 - x[i,j]))

status = optimize!(m)

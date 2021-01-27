import numpy as np
import random
import math
import time

file_path = "30_nodes_3_clusters.txt"
data = np.genfromtxt(file_path, skip_header=2)

G = np.asmatrix(data)
Size = 30
k = 3

#Construire s0
def BuildRandomS():
    s = []
    for i in range(0, k):
        s.append([])
    for i in range(1, Size + 1):
        s[random.randint(0, k - 1)].append(i)
    return s

#Calculer distance intra
def MaxDistIntra(s, num):
    nodes_cluster = s[num]
    dist_clust = []
    for i in range(0, len(nodes_cluster) - 1):
        for j in range(i, len(nodes_cluster) - 1):
            dist_clust.append(G[nodes_cluster[i] - 1, nodes_cluster[j] - 1])
    if len(dist_clust) == 0:
        return 10000
    else:
        return max(dist_clust)

#Calculer Z
def Z(s):
    dist_clusts = []
    for i in range(0, k):
        vec = MaxDistIntra(s, i)
        dist_clusts.append(vec)
    return max(dist_clusts)

def ClusterDifferent(cl):
    while True:
        newcl = random.randint(0, k - 1)
        if cl != newcl:
            return newcl

#Choisir un voisinage de s
def V(s):
    cl1 = random.randint(0, k - 1)
    cl2 = ClusterDifferent(cl1)

    lengh = len(s[cl1]) - 1

    if lengh <= 2:
        return s

    val1 = random.randint(0, lengh)
    tmp = s[cl1][val1]
    s[cl2].append(tmp)
    del s[cl1][val1]
    return s

def Metropolis(delta_f, T):
    return math.exp(-(delta_f / T))

def RecuitSimule(s, epsi, K, T0):
    s_star = s
    T = T0
    while T > epsi:
        s_prime = V(s_star)
        delta_f = Z(s_prime) - Z(s_star)
        if delta_f <= 0:
            s_star = s_prime
        else:
            if Metropolis(delta_f, T) >= random.random():
                s_star = s_prime
        T = K * T
    return s_star

s0 = BuildRandomS()
val_s0 = Z(s0)

start_time = time.time()

opti = RecuitSimule(s0, 1, 0.99, 100)

interval = time.time() - start_time
print('Total time in seconds:', interval)

val_opti = Z(opti)
print("s0 :", val_s0, " optimum :", val_opti)
print(opti)

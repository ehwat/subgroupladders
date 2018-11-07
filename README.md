# subgroup-ladders

This repository contains a gap implementation of an algorithm described by Bernd Schmalz [1, Theorem 3.1.1] to compute subgroup ladders of permutation groups.

Solutions of some problems in group theory can relatively easy be transferred to a sub- or supergroup if the index is small.
Let G be a permutation group on the set {1,…,n}.
So one might try to find a series of subgroups of subgroups G = H_0,…,H_k = S_n of the symmetric group S_n such that H_{i-1} is a subgroup of H_i for every i and transfer the solution of a problem for the symmetric group step by step to G.

Sometimes it is not possible to find such a series with small indices between consecutive subgroups.
This is where subgroup ladders may make sense:
A subgroup ladder is series of subgroups G = H_0,…,H_k = S_n of the symmetric group such that for every 1≤i≤k, H_i is a subgroup of H_{i-1} or H_{i-1} is a subgroup of H_i.
So we sometimes go up to a larger group in order to keep the indices small.

If G is a Young subgroup of S_n, the algorithm in this repository can find a subgroup ladder of G such that the indices are at most the degree of the permutation group.

```text
S_n
 |
 |
 |
H_1
 |      H_3
 |      /|
 |    /  |
 |  /    |
H_2      |
        H_4
         |        H_6
         |      /  |
         |    /    |
         |  /      |
        H_5        |
                   |
                H_7 = G
```

## References

[1] B. Schmalz. Verwendung von Untergruppenleitern zur Bestimmung von Doppelnebenklassen. Bayreuther Mathematische Schriften, 31, S.109--143, 1990.

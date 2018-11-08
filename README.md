# The GAP package subgroupladders

This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
The algorithm was described by Bernd Schmalz in [1, Theorem 3.1.1].

Solutions of some problems in group theory can relatively easy be transferred to a sub- or supergroup if the index is small.
Let G be a permutation group on the set {1,...,n}.
So one might try to find a series of subgroups G = H_0,...,H_k = S_n of the symmetric group S_nsuch that H_{i-1} is a subgroup of H_i for every i and transfer the solution of a problem for the symmetric group step by step to G.

Sometimes it is not possible to find such a series with small indices between consecutive subgroups.
This is where subgroup ladders may make sense:
A subgroup ladder is series of subgroups G = H_0,...,H_k = S_n of the symmetric group such that for every 1<=i<=k, H_i is a subgroup of H_{i-1} or H_{i-1} is a subgroup of H_i.
So we sometimes go up to a larger group in order to keep the indices small.

If G is a Young subgroup of S_n, the algorithm in this repository can find a subgroup ladder of G such that the indices are at most the degree of the permutation group.
A subgroup ladder may look like this:

```text
 H_8 = S_n
     |
     |
     |
    H_7
     |      H_5
     |      /|
     |    /  |
     |  /    |
    H_6      |
            H_4
             |        H_2
             |      /  |
             |    /    |
             |  /      |
            H_3        |
                       |
                      H_1
                       |
                       |
                       |
                    H_0 = G
```


TODO: add a description of your package; perhaps also instructions how how to
install and use it, resp. where to find out more

## Documentation

The documentation of this package is available as [HTML](https://hrnz.li/subgroupladders) and as a [PDF](https://hrnz.li/subgroupladders/manual.pdf).
It can also be generated locally with `gap makedoc.g`.

## Contact

You can report issues on GitHub at <https://github.com/ehwat/subgroup-ladders>.


## License

subgroupladders is free software you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version. For details, see the file LICENSE distributed as part of this package
or see the FSF's own site.

## References

[1] B. Schmalz. Verwendung von Untergruppenleitern zur Bestimmung von Doppelnebenklassen. Bayreuther Mathematische Schriften, 31, S.109--143, 1990.

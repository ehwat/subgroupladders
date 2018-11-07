gap> Read("subgroupladder.g");
gap> l := [[2,3,5,8],[6,12,15],[14,9,17],[19,7,4,13,1,18],[20,16]];
[ [ 2, 3, 5, 8 ], [ 6, 12, 15 ], [ 14, 9, 17 ], [ 19, 7, 4, 13, 1, 18 ], [ 20, 16 ] ]
gap> P := DirectProduct(List(l, SymmetricGroup));
<permutation group of size 1244160 with 9 generators>
gap> Subgroupladder(P);
[ <permutation group of size 1244160 with 9 generators>, <permutation group of size 311040 with 9 generators>, <permutation group of size 2177280 with 9 generators>, <permutation group of size 725760 with 8 generators>, 
  <permutation group of size 5806080 with 8 generators>, <permutation group of size 2903040 with 7 generators>, <permutation group of size 26127360 with 7 generators>, <permutation group of size 261273600 with 7 generators>, 
  <permutation group of size 87091200 with 6 generators>, <permutation group of size 958003200 with 6 generators>, Group([ (1,2,3,4,5,6,7,8,9,10,11), (1,2), (12,13,14), (12,13), (15,16) ]), Group([ (1,2,3,4,5,6,7,8,9,10,11,
   12), (1,2), (13,14,15), (13,14), (16,17) ]), Group([ (1,2,3,4,5,6,7,8,9,10,11,12,13), (1,2), (14,15,16), (14,15), (17,18) ]), Group([ (1,2,3,4,5,6,7,8,9,10,11,12,13), (1,2), (14,15), (16,17) ]), Group([ (1,2,3,4,5,6,7,8,9,
   10,11,12,13,14), (1,2), (15,16), (17,18) ]), Group([ (1,2,3,4,5,6,7,8,9,10,11,12,13,14), (1,2), (15,16) ]), Group([ (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15), (1,2), (16,17) ]), Group([ (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
   16), (1,2), (17,18) ]), Group([ (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), (1,2) ]), Group([ (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17), (1,2) ]), Group([ (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18), (1,2) ]) ]
gap> ll := List(last, Order);
[ 1244160, 311040, 2177280, 725760, 5806080, 2903040, 26127360, 261273600, 87091200, 958003200, 479001600, 5748019200, 74724249600, 24908083200, 348713164800, 174356582400, 2615348736000, 41845579776000, 20922789888000, 
  355687428096000, 6402373705728000 ]
gap> for i in [2..Length(ll)] do Print(ll[i]/ll[i-1],"\n"); od;
1/4
7
1/3
8
1/2
9
10
1/3
11
1/2
12
13
1/3
14
1/2
15
16
1/2
17
18
gap> 

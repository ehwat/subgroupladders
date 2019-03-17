gap> TestLadder := function(l)
>  local
>    i;
>  for i in [2..Length(l)] do
>    if not l[i].LastDirection in [-1,1] then
>      return false;
>    fi;
>    if l[i].LastDirection = 1 then
>      if not IsSubgroup( l[i].Group,l[i-1].Group ) then
>        return false;
>      fi;
>    fi;
>    if l[i].LastDirection = -1 then
>      if not IsSubgroup( l[i-1].Group,l[i].Group ) then
>        return false;
>      fi;
>    fi;
>  od;
>  return true;
> end;;

#
gap> G := SubdirectProducts(TransitiveGroup(10,25),TransitiveGroup(14,20))[4];
<permutation group of size 62720 with 8 generators>
gap> TestLadder(SubgroupLadder(G));
true
gap> n := LargestMovedPoint(G) + 3;
27
gap> TestLadder(SubgroupLadder(G, false, n));
true
gap> Remove(SubgroupLadder(G, false, n)).Group = SymmetricGroup(n);
true
gap> G := TransitiveGroup(31,1);
t31n1
gap> TestLadder(SubgroupLadderForTransitive(G));
true
gap> n := LargestMovedPoint(G) + 3;
34
gap> TestLadder(SubgroupLadderForTransitive(G, false, n));
true
gap> G := TransitiveGroup(10,25);
1/2[2^5]F(5)
gap> TestLadder(SubgroupLadderForTransitive(G));
true
gap> n := LargestMovedPoint(G) + 3;
13
gap> TestLadder(SubgroupLadderForTransitive(G, false, n));
true
gap> G := TransitiveGroup(10,25);
1/2[2^5]F(5)
gap> TestLadder(SubgroupLadderForImprimitive(G));
true
gap> n := LargestMovedPoint(G) + 3;
13
gap> TestLadder(SubgroupLadderForImprimitive(G, false, n));
true
gap> Remove(SubgroupLadderForImprimitive(G, false, n)).Group = SymmetricGroup(n);
true
gap> G := Group([(1,2,3),(1,2),(6,7,8),(6,7)]);
Group([ (1,2,3), (1,2), (6,7,8), (6,7) ])
gap> TestLadder(SubgroupLadderForYoungGroup(G));
true
gap> n := 10;
10
gap> TestLadder(SubgroupLadderForYoungGroup(G, n));
true
gap> Remove(SubgroupLadderForYoungGroup(G, n)).Group = SymmetricGroup(n);
true

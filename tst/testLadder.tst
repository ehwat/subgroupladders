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
gap> TestLadder([
>  rec(Group := Group(()), LastDirection := 0),
>  rec(Group:= Group(()), LastDirection := 0)]);
false
gap> TestLadder([
>  rec(Group := Group(()), LastDirection := 0),
>  rec(Group:= Group((1,2)), LastDirection := -1)]);
false
gap> TestLadder([
>  rec(Group := Group((1,2)), LastDirection := 0),
>  rec(Group:= Group(()), LastDirection := 1)]);
false
gap> G := SubdirectProducts(TransitiveGroup(10,25),TransitiveGroup(14,20))[4];
<permutation group of size 62720 with 8 generators>
gap> TestLadder(SubgroupLadder(G));
true
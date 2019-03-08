gap> TestRandomYoungGroup := function(n)
>  local
>    p,
>    g,
>    l, 
>    i;
>  p := RandomPartialPerm(n);
>  p := ComponentsOfPartialPerm(p);
>  g := YoungGroupFromPartition(p);
>  l := SubgroupLadderForYoungGroup(g, n);
>  for i in [2..Length(l)] do
>    if l[i].LastDirection = 1 then
>      if not ( IsSubgroup( l[i].Group,l[i-1].Group ) and Index( l[i].Group,l[i-1].Group ) <= n) then
>        return false;
>      fi;
>    fi;
>    if l[i].LastDirection = -1 then
>      if not ( IsSubgroup( l[i-1].Group,l[i].Group ) and Index( l[i-1].Group,l[i].Group ) <= n) then
>        return false;
>      fi;
>    fi;
>  od;
>  return true;
> end;;

#
gap> TestRandomYoungGroup(20);
true
gap> TestRandomYoungGroup(30);
true
gap> TestRandomYoungGroup(40);
true

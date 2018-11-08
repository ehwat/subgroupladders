gap> TestRandom := function(n)
>  local
>    p,
>    g,
>    l, 
>    i;
>  p := RandomPartialPerm(n);
>  p := ComponentsOfPartialPerm(p);
>  g := YoungGroupFromPartition(p);
>  l := SubgroupLadder(g);
>  for i in [2..Length(l)] do
>    if Order(l[i]) < Order(l[i-1]) then
>      if not (IsSubgroup(l[i-1],l[i]) and Index(l[i-1],l[i]) <= n) then
>         return false;
>      fi;
>    else
>      if not (IsSubgroup(l[i],l[i-1]) and Index(l[i],l[i-1]) <= n) then
>         return false;
>      fi;
>    fi;
>  od;
>  return true;
> end;;

#
gap> TestRandom(20);
true
gap> TestRandom(30);
true
gap> TestRandom(40);
true
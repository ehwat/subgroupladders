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
gap> T := AllTransitiveGroups(Size, [30..50], IsAbelian, false);;
#I  AllTransitiveGroups: Degree restricted to [ 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 
  23, 24, 25, 26, 27, 28, 29, 30, 31, 33, 34, 35, 36, 37 ]
gap> success := true;;

#
gap> for G in T do
>  if TestLadder(SubgroupLadderForTransitive(G)) = false then
>    success := false;
>  fi;
> od;

#
gap> success;
true
## Given a group G, this computes the partial table of marks induced by the subgroups of G in list.
InstallGlobalFunction(TableOfMarksPartial,
function(list, G)
	local
		n,           # length of list
		table,       # partial table of marks
		chain,       # subgroup chain
		i,           # loop variable
		j;           # loop variable
	n := Length(list);
	table := NullMat(n,n);

	for i in [1..n] do
		chain := AscendingChain(G, list[i]);
		for j in [1..i] do
			if Length(chain) = 1 then
				table[i][j] := 1;
			else
				table[i][j] := TableOfMarksEntryWithChain(G, ShallowCopy(chain), list[j]);
			fi;
		od;
	od;

	return table;
end);

## Internal function called by TableOfMarksPartial, which computes iteratively one entry of the table of marks.
## Let G be the parent group of the table of marks, i.e.
## U,V <= G, where chain is an ascending subgroup chain of the form V <= ... <= B <= A <= ... <= G.
## By iteration we compute the fixed points of R[G : V] with respect to the action by right multiplication of U.
InstallGlobalFunction(TableOfMarksEntryWithChain,
function(G, chain, U)
	local 
		groupA,                    # subgroup in chain
		groupB,                    # subgroup in chain
		cosetsBinA,                # right cosets of B in A
		fixedPointsInCosetsOfAinG, # fixed points of U in the right cosets of A in G
		fixedPointInCosetsOfAinG,  # loop variable, fixed point, element of fixedPointsInCosetsOfAinG
		splitCosets,               # the split cosets of fixedPointInCosetsOfAinG as cosets of B in G
		fixedPointsInCosetsOfBinG; # the fixed points in splitCosets

	fixedPointsInCosetsOfAinG := ShallowCopy( RightCosets(G, G) );
	while Length(chain) >= 2 do
		groupA := Remove(chain);
		groupB := chain[Length(chain)];
		cosetsBinA := RightCosets(groupA, groupB);
		fixedPointsInCosetsOfBinG := [];
		for fixedPointInCosetsOfAinG in fixedPointsInCosetsOfAinG do
			splitCosets := List(cosetsBinA, c -> RightCoset(groupB, Representative(c)*Representative(fixedPointInCosetsOfAinG)));
			Append(fixedPointsInCosetsOfBinG, _FixedPoints(splitCosets, U, OnRight));
		od;
		fixedPointsInCosetsOfAinG := ShallowCopy(fixedPointsInCosetsOfBinG);
	od;
	return Length(fixedPointsInCosetsOfAinG);
end);

## Given a group G with an action act on an object obj,
## this operation returns a subset of obj that is pointwise fixed by G.
InstallMethod( _FixedPoints,
"for a generic object",
true,
[ IsObject, IsGroup, IsFunction ],
0,
function(obj, G, act)
	local 
		gens,        # generators of G
		fixedPoints, # fixed points of obj
		x;           # loop variable, element of obj
	gens := GeneratorsOfGroup(G);
	fixedPoints := [];
	for x in obj do
		if ForAll(gens, g-> act(x, g) = x) then
			Add(fixedPoints, x);
		fi;
	od;
	return fixedPoints;
end);

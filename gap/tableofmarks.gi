## Given a group G, this computes the partial table of marks induced by the subgroups of G in list.
InstallGlobalFunction(TableOfMarksPartial,
function(arg)
	local
		list,        # list of subgroups corresponding to the desired section of the tom
		G,           # parent group
		skipConjTest,# whether to test arguments for conjugacy
		n,           # length of list
		reps,        # list of representatives of conjugacy classes of the subgroups in list
		repMapping,  # mapping of the groups in list to their reps
		table,       # partial table of marks for representatives
		tom,         # partial table of marks
		chain,       # subgroup chain
		k,           # number of conjugacy classes in list
		i,           # loop variable
		j;           # loop variable

	if Length(arg) = 2 then
		list := arg[1];
		G := arg[2];
		skipConjTest := false;
	else if Length(arg) = 3 then
			list := arg[1];
			G := arg[2];
			skipConjTest := arg[3];
		else
			ErrorNoReturn("Invalid Arguments.\n");
		fi;
	fi;
		

	n := Length(list);
	if (skipConjTest = false) then
		reps := [];
		repMapping := [];

		# determine representatives of the supplied groups modulo conjugacy 
		for i in [1..n] do
			for j in [1..Length(reps)] do
				if IsConjugate(G, list[i], reps[j]) then
					repMapping[i] := j;
					break;
				fi;
			od;
			if not IsBound(repMapping[i]) then
				Add(reps, list[i]);
				repMapping[i] := Length(reps);
			fi;
		od;
	else
		reps := list;
		repMapping := [1..n];
	fi;

	# first compute the section of the table of marks for the representatives.
	k := Length(reps);
	table := NullMat(k,k);
	for i in [1..k] do
		chain := AscendingChain(G, reps[i]);
		for j in [1..i] do
			if Length(chain) = 1 then
				table[i][j] := 1;
			else
				table[i][j] := TableOfMarksEntryWithChain(G, ShallowCopy(chain), reps[j]);
			fi;
		od;
	od;

	if (skipConjTest = true) then
		return table;
	fi;

	# then copy the corresponding entries
	tom := NullMat(n,n);
	for i in [1..n] do
		for j in [1..i] do
			tom[i][j] := table[repMapping[i]][repMapping[j]];
		od;
	od;

	return tom;
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

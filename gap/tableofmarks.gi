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
## By iteration we compute the fixed points of R[G : V] with resprect to the action by right multiplication of U.
InstallGlobalFunction(TableOfMarksEntryWithChain,
function(G, chain, U)
	local 
		A,          # subgroup in chain
		B,          # subgroup in chain
		RAB,        # cosets of B in A
		Omega,      # fixed points of RGA
		x,          # loop variable, fixed point, element of Omega
		Delta,      # the split cosets of x in Omega
		Gamma;      # the fixed points in Delta

	Omega := ShallowCopy( RightCosets(G, G) );
	while Length(chain) >= 2 do
		A := Remove(chain);
		B := chain[Length(chain)];
		RAB := RightCosets(A, B);
		Gamma := [];
		for x in Omega do
			Delta := List(RAB, c -> RightCoset(B, Representative(c)*Representative(x)));
			Append(Gamma, _FixedPoints(Delta, U, OnRight));
		od;
		Omega := ShallowCopy(Gamma);
	od;
	return Length(Omega);
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
		gens,    # generators of G
		res,     # fixed points of obj
		x;       # loop variable, element of obj
	gens := GeneratorsOfGroup(G);
	res := [];
	for x in obj do
		if ForAll(gens, g-> act(x, g) = x) then
			Add(res, x);
		fi;
	od;
	return res;
end);

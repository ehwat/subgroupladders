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
				table[i][j] := TableOfMarksEntryWithChain(RightCosets(G, chain[Length(chain)-1]), ShallowCopy(chain), list[j]);
			fi;
		od;
	od;

	return table;
end);

## Internal function called by TableOfMarksPartial, which computes recursively one entry of the table of marks.
## Let G be the parent group of the table of marks, i.e.
## U,H <= G, where chain is an ascending subgroup chain of the form C <= ... <= B <= A <= H.
## Let Gamma be the fixed points of R[G : H] in U, say Hg_1, ..., Hg_k.
## Let R[H : A] be Ah_1, ..., Ah_l.
## Then Omega is the set of the split cosets of Gamma, i.e. 
## Ah_1g_1, ..., Ah_lg_1, ..., Ah_1g_k, ..., Ah_lg_k.
## Return the number of fixed points of R[G : C] in U.
InstallGlobalFunction(TableOfMarksEntryWithChain,
function(Omega, chain, U)
	local 
		fixed,      # fixed points of Omega, cosets of A in H 
		A,          # subgroup in chain
		B,          # subgroup in chain
		cosets,     # cosets of B in A
		sum,        # number of fixed points
		Delta,      # the split cosets of Omega
		x;          # loop variable, fixed point
	fixed := FixedPoints(Omega, U, OnRight);
	if (Length(chain) = 2) then
		return Length(fixed);
	else
		Remove(chain);
		A := chain[Length(chain)];
		B := chain[Length(chain)-1];
		cosets := RightCosets(A, B);
		sum := 0;
		for x in fixed do
			Delta := List(cosets, c -> RightCoset(B, Representative(c)*Representative(x)));
			sum := sum + TableOfMarksEntryWithChain(Delta, ShallowCopy(chain), U);
		od;
		return sum;
	fi;
end);

## Given a group G with an action act on an object obj,
## this operation returns a subset of obj that is pointwise fixed by G.
InstallMethod( FixedPoints,
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

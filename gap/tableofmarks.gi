InstallGlobalFunction(TableOfMarksPartial,
function(list, G)
	local n, table, chain, U, Omega, fixed, i, j, x;
	n := Length(list);
	table := NullMat(n,n);

	for i in [1..n] do
		chain := AscendingChain(G, list[i]);
		Print(Length(chain), "\n");
		for j in [1..i] do
			if Length(chain) = 1 then
				table[i][j] := 1;
			else
				table[i][j] := CountFixedPoints(RightCosets(G, chain[Length(chain)-1]), ShallowCopy(chain), list[j]);
			fi;
		od;
	od;

	return table;
end);

InstallGlobalFunction(CountFixedPoints,
function(Omega, chain, U)
	local fixed, A, B, cosets, sum, Delta, x;
	fixed := FixedPoints1(U, Omega, OnRight);
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
			sum := sum + CountFixedPoints(Delta, chain, U);
		od;
		return sum;
	fi;
end);

InstallGlobalFunction(FixedPoints1,
function(G, Omega, op)
	gens := GeneratorsOfGroup(G);
	res := [];
	for x in Omega do
		if ForAll(gens, g-> op(x, g) = x) then
			Add(res, x);
		fi;
	od;
	return res;
end);

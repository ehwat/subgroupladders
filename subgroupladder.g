YoungGroupFromPartition := function(part)
	local
		i,
		P,
		G,
		grps,
		olds,
		news,
		perms,
		info,
		generators;

	grps := [];
	olds := [];
	news := [];
	perms := [];
	generators := [];

	for i in part do
		G := SymmetricGroup(i);
		Append(generators, GeneratorsOfGroup(G));
		Add(grps, G);
		Add(olds, i);
		Add(news, i);
		Add(perms, ());
	od;

	P := Group(generators);
	info := rec( groups := grps,
	             olds := olds,
				 news := news,
				 perms := perms,
				 embeddings := [],
				 projections := [] );
	SetDirectProductInfo(P, info);

	return P;
end;

FindPos := function(list, x)
	local n, i;
	n := Length(list);
	for i in [1..n] do
		if x in list[i] then
			return i;
		fi;
	od;
end;

SubgroupLadder := function(G)
	local
		orb,
		i,
		k,
		n,
		pair,
		ladder,
		directfactors,
		generators,
		mapping,
		output,
		partition;


	if (not IsPermGroup(G)) then
		ErrorNoReturn("the argument must be a permutation group!\n");
	fi;

	n := LargestMovedPoint(G);

	orb := List(Orbits(G), x -> x);
	SortBy(orb, x->-Length(x));

	output := [];

	partition := List(orb, Length);
	mapping := List([1..n], x -> FindPos(orb, x));
	ladder := [[List(partition), List(mapping)]];


	while (Length(partition) <> 1 or partition[1] < n) do
		if (Length(partition) = 1 and partition[1] < n) then
			mapping[Position(mapping, 0)] := 1;
			partition[1] := partition[1] + 1;
			Add(ladder, [List(partition), List(mapping)]);
		else
			if (partition[2] = 1) then
				Remove(partition, 2);
				for i in [1..n] do
					if (mapping[i]) > 1 then
						mapping[i] := mapping[i] - 1;
					fi;
				od;
				partition[1] := partition[1] + 1;
				Add(ladder, [List(partition), List(mapping)]);
			else
				mapping[Position(mapping, 2)] := Length(partition)+1;
				partition[2] := partition[2] - 1;
				Add(partition, 1);
				Add(ladder, [List(partition), List(mapping)]);

				mapping[Position(mapping, Length(partition))] := 1;
				Remove(partition);
				partition[1] := partition[1] + 1;
				Add(ladder, [List(partition), List(mapping)]);
			fi;
		fi;
	od;

	for pair in ladder do
		k := Length(pair[1]);
		mapping := pair[2];
		Add(output, YoungGroupFromPartition(List([1..k], i -> Filtered([1..n], x -> i = mapping[x]))));
	od;

	return output;
end;

# vim: set noet ts=4:

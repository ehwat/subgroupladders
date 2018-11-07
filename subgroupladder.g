FindPos := function(list, x)
	local n, i;
	n := Length(list);
	for i in [1..n] do
		if x in list[i] then
			return i;
		fi;
	od;
end;

id := function(x)
	return x;
end;

Subgroupladder := function(G)
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
	ladder := [[List(partition, id), List(mapping, id)]];


	while (Length(partition) <> 1 or partition[1] < n) do
		if (Length(partition) = 1 and partition[1] < n) then
			mapping[Position(mapping, 0)] := 1;
			partition[1] := partition[1] + 1;
			Add(ladder, [List(partition, id), List(mapping, id)]);
		else 
			if (partition[2] = 1) then
				Remove(partition, 2);
				for i in [1..n] do
					if (mapping[i]) > 1 then
						mapping[i] := mapping[i] - 1;
					fi;
				od;
				partition[1] := partition[1] + 1;
				Add(ladder, [List(partition, id), List(mapping, id)]);
			else 
				mapping[Position(mapping, 2)] := Length(partition)+1;
				partition[2] := partition[2] - 1;
				Add(partition, 1);
				Add(ladder, [List(partition, id), List(mapping, id)]);

				mapping[Position(mapping, Length(partition))] := 1;
				Remove(partition);
				partition[1] := partition[1] + 1;
				Add(ladder, [List(partition, id), List(mapping, id)]);
			fi;
		fi;
	od;

	for pair in ladder do
		k := Length(pair[1]);
		mapping := pair[2];
		directfactors := [];
		generators := [];
		for i in [1..k] do
			Append(generators, GeneratorsOfGroup(SymmetricGroup(Filtered([1..n], x -> i = mapping[x]))));
		od;
		Add(output, Group(generators));
	od;

	return output;
end;

#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# Implementations
#

#
# Generate a Young subgroup of a partial partition part = (p_1, ..., p_k) of some positive integer n.
# Every p_i is a list of positive integers such that the union of the p_i is disjoint and is a subset of {1,...n}.
# The Young subgroup is then the direct product of the symmetric groups on the p_i.
InstallGlobalFunction( YoungGroupFromPartition,
function(part)
	if (IsDuplicateFree(Concatenation(part))) then
		return YoungGroupFromPartitionNC(part);
	fi;
	ErrorNoReturn("The Argument must me a list of disjoint lists!\n");
end);

# Generate a Young subgroup of a partial partition part = (p_1, ..., p_k) of some positive integer n.
# Every p_i is a list of positive integers such that the union of the p_i is disjoint and is a subset of {1,...n}.
# The Young subgroup is then the direct product of the symmetric groups on the p_i.
InstallGlobalFunction( YoungGroupFromPartitionNC,
function( part )
	return DirectProductPermGroupsWithoutRenamingNC(List(part, SymmetricGroup));
end);

InstallGlobalFunction( DirectProductPermGroupsWithoutRenaming,
function( list )
	if ForAny(list, G -> not IsPermGroup(G)) then
		ErrorNoReturn("At least one Group in the passed list is not a permutation group, aborting\n");
	fi;
	if not IsDuplicateFree(Concatenation(List(list, MovedPoints))) then
		ErrorNoReturn("The sets of moved points of the passed groups are not pairwise disjoint, aborting\n");
	fi;
	return DirectProductPermGroupsWithoutRenamingNC( list );
end);

InstallGlobalFunction( DirectProductPermGroupsWithoutRenamingNC,
function( list )
	local
		G,           # loop variable over the direct factors
		p,           # Moved Points of G
		P,           # the direct product we will return
		generators,  # the generators of P.
		grps,        # record entry of info.
		olds,        # record entry of info.
		news,        # record entry of info.
		perms,       # record entry of info.
		info;        # record for the DirectProductInfo of Y.

	# Initialize the variables.
	grps := [];
	olds := [];
	news := [];
	perms := [];
	generators := [];

	# Generate the record entries of info.
	for G in list do
		p := MovedPoints(G);
		Append(generators, GeneratorsOfGroup(G));
		Add(grps, G);
		Add(olds, p);
		Add(news, p);
		Add(perms, ());
	od;

	# Generate the Young subgroup Y and add the DirectProductInfo info to Y.
	P := Group(generators);
	info := rec( groups := grps,
	             olds := olds,
	             news := news,
	             perms := perms,
	             embeddings := [],
	             projections := [] );
	SetDirectProductInfo(P, info);

	return P;
end);

## Given a young group G, this will compute a subgroup ladder
## from G up to the symmetric group of degree n.
## If the second argument is ommited, the largest moved point of G will be
## used. We can guarantee that all
## the indices are at most the degree n of the permutation group.
InstallGlobalFunction( SubgroupLadderForYoungGroup,
function(arg)
	local
		G,            # the provided young subgroup we will start the construction from
		orb,          # the orbits of the permutation group G
		n,            # degree of the parent symmetric group
		i,            # loop variable
		k,            # size of current partition
		ladder,       # the ladder is a list containing pairs [partition, mapping]
		partition,    # partition is a list of positive integers (a_1, ..., a_k) such that
		              # a_1 is the biggest integer of the list.
		mapping,      # mapping is a list of positive integers (m_1, ..., m_n) such that
		              # 1 <= m_i <= k for all i.
		pair,         # a entry of the ladder [partition, mapping] used to construct a young subgroup
		output;       # a list of groups forming the ladder of G into S_n

	if (Length(arg) <> 1 and Length(arg) <> 2) then
		ErrorNoReturn("usage: SubgroupLadder(<G>[, <n>]), where <G> is a young subgroup of the symmetric group on <n> letters\n");
	fi;

	if (Length(arg) = 2) then
		G := arg[1];
		n := arg[2];
	else
		G := arg[1];
		n := LargestMovedPoint(G);
	fi;


	# Check if G is a permuatation group
	if (not IsPermGroup(G)) then
		ErrorNoReturn("the first argument must be a permutation group!\n");
	fi;

	# Initialize the variables
	orb := List(Orbits(G, [1..n]));
	SortBy(orb, x->-Length(x));

	output := [];

	if (YoungGroupFromPartition(orb) <> G) then
		ErrorNoReturn("the first argument must be a young subgroup!\n");
	fi;

	if (n < LargestMovedPoint(G)) then
		ErrorNoReturn("degree of desired parent symmetric group is smaller than the degree of G!\n");
	fi;

	partition := List(orb, Length);
	mapping := List([1..n], x -> PositionProperty([1..Length(orb)], i -> x in orb[i]));
	ladder := [[List(partition), List(mapping)]];

	# Start the iterative construction of the ladder
	while (Length(partition) <> 1 or partition[1] < n) do
		# This is the case where partition = (a) and the current young subgroup is S_{a}.
		# Add the group S_{a+1} to the ladder
		# and continue iteration with this group.
		if (Length(partition) = 1) then
			mapping[Position(mapping, 0)] := 1;
			partition[1] := partition[1] + 1;
			Add(ladder, [List(partition), List(mapping)]);
		else
			# This is the case where partition = (a_1, a_2, a_3, ..., a_k) and a_2 = 1.
			# Add the young subgroup with partition (a_1, a_3, ..., a_k)
			# and continue iteration with this group.
			if (partition[2] = 1) then
				Remove(partition, 2);
				for i in [1..n] do
					if (mapping[i]) > 1 then
						mapping[i] := mapping[i] - 1;
					fi;
				od;
				partition[1] := partition[1] + 1;
				Add(ladder, [List(partition), List(mapping)]);
			# This is the case where partition = (a_1, a_2, a_3, ..., a_k) and a_2 > 1.
			# First add the young subgroup with partition (a_1, 1, a_2 - 1, a_3, ..., a_k).
			# Then add the young subgroup with partition (a_1 + 1, a_2 - 1, a_3, ..., a_k)
			# and continue iteration with this group.
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

	# Construct the young subgroups of the pairs [partition, mapping] stored in ladder
	for pair in ladder do
		k := Length(pair[1]);
		mapping := pair[2];
		Add(output, YoungGroupFromPartition(List([1..k], i -> Filtered([1..n], x -> i = mapping[x]))));
	od;

	return output;
end);

InstallGlobalFunction(SubgroupLadder, 
function(arg)
	local 
		G,
		n,
		orbs,
		gens,
		subgroupladder,
		o,
		gensSo,
		Y;

	if (Length(arg) <> 1 and Length(arg) <> 2) then
		ErrorNoReturn("usage: SubgroupLadder(<G>[, <n>]), where <G> is a intransitive subgroup of the symmetric group on <n> letters\n");
	fi;

	if (Length(arg) = 2) then
		G := arg[1];
		n := arg[2];
	else
		G := arg[1];
		n := LargestMovedPoint(G);
	fi;

	orbs := List(Orbits(G));
	gens := List(GeneratorsOfGroup(G));
	subgroupladder := [G];

	for o in orbs do 
		gensSo := GeneratorsOfGroup(SymmetricGroup(o));
		if not IsSubgroup(G, Group(gensSo)) then
			Append(gens,gensSo);
			Add(subgroupladder,Group(gens));
		fi;
	od;

	Y := Remove(subgroupladder);
	Append( subgroupladder, SubgroupLadderForYoungGroup(Y, n) );
	return subgroupladder;
end);

RenamePerm := function(x, lambda)
	local g,i;
	g := List([1..Maximum(lambda)]);
	for i in MovedPoints(x) do
		g[lambda[i]] := lambda[i^x];
	od;
	return PermList(g);
end;

#
# Given a permutation group G and a set Om, such that G acts imprimitive on Om,
# this function will compute an embedding into the wreath product of S_m 
# with S_k where k is the size of a minimal non-trivial block system and m 
# is the size of the blocks.
# The output is [lambda, emb], where emb is the embedding and lambda is a list,
# such that G and the image of G under emb are permutation isomorphic,
# that is lambda[o^g] = (lambda[o])^(g)emb for all o in Om.
#
InstallGlobalFunction( EmbeddingWreathProduct,
function(G, Om)
	local
		B,              # a minimal non-trivial blocks system.
		k,              # size of blocks system B.
		m,              # size of the blocks in B (they all have equal size).
		W,              # the wreath product of S_m with S_k.
		gens,           # the generators of G.
		orb,            # the orbit object with schreier tree for B[1][1].
		gi,             # a list of elements, such that B[i]^gi[i] = B[1].
		i,              # loop variable for index in L.
		o,              # loop variable for element in Omega.
		lambda,         # the map which makes Wr a supergroup of G.
		Wr,             # group W after renaming the points with lambda.
		info;           # wreath product info of Wr.

	if(not IsPermGroup(G)) then
		ErrorNoReturn("G must be a permutation group");
	fi;

	# This method will return an error if G does not act transitively on Om.
	B := Blocks(G, Om);

	# Initialize all variables
	k := Length(B);
	m := Length(B[1]);
	W := WreathProductImprimitiveAction(SymmetricGroup(B[1]),SymmetricGroup(k));
	gens := GeneratorsOfGroup(G);
	orb := Orb(gens,B[1][1],OnPoints,rec(schreier:=true, storenumbers:=true));
	Enumerate(orb);
	gi := List([1..k], i -> EvaluateWord( gens, TraceSchreierTreeForward(orb, Position(orb, B[i][1])) ));

	lambda := [];
	for o in Om do
		i := PositionProperty(B, b -> o in b);
		lambda[ Position(B[1], o^(gi[i]))+(i-1)*m] := o;
	od;

	Wr := Group(List(GeneratorsOfGroup(W), x -> RenamePerm(x, lambda)));
	info := ShallowCopy(WreathProductInfo(W));
	info.basegens := List(info.basegens, x -> RenamePerm(x,lambda));
	info.base := Group(info.basegens);
	info.components := List(info.components, x -> List(x, y -> lambda[y]));
	info.hgens := List(info.hgens, x -> RenamePerm(x, lambda));
	info.perms := Concatenation( [()], List([2..k], i -> Product([1..m], j -> CycleFromList([B[1][j],lambda[j+m*(i-1)]]))));
	SetWreathProductInfo(Wr, info);
	return Wr;
end);

# vim: set noet ts=4:

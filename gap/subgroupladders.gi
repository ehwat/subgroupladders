#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# Implementations
#

## Generate a Young subgroup of a partial partition part = (p_1, ..., p_k) of some positive integer n.
## Every p_i is a list of positive integers such that the union of the p_i is disjoint and is a subset of {1,...n}.
## The Young subgroup is then the direct product of the symmetric groups on the p_i.
InstallGlobalFunction( YoungGroupFromPartition,
function(part)
	if (IsDuplicateFree(Concatenation(part))) then
		return YoungGroupFromPartitionNC(part);
	fi;
	ErrorNoReturn("The Argument must me a list of disjoint lists!\n");
end);

## Generate a Young subgroup of a partial partition part = (p_1, ..., p_k) of some positive integer n.
## Every p_i is a list of positive integers such that the union of the p_i is disjoint and is a subset of {1,...n}.
## The Young subgroup is then the direct product of the symmetric groups on the p_i.
InstallGlobalFunction( YoungGroupFromPartitionNC,
function( part )
	return DirectProductPermGroupsWithoutRenamingNC(List(part, SymmetricGroup));
end);

## Constructs a direct product of a list <A>list</A> of permutation groups
## with pairwise disjoint moved points such that all embeddings are canonical.
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

## Like the above, but does not tests whether the argument is a list of permutation
## groups with pairwise disjoint moved points.
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

## Given a permutation group G, this will compute a subgroup ladder
## from G up to the symmetric group of degree n.
## If the second argument is ommited, the largest moved point of G will be
## used.
## A subgroup ladder is series of subgroups G = H_0,…,H_k = S_n of the
## symmetric group such that for every 1 <= i <= k, H_i is a
## subgroup of H_{i-1} or H_{i-1} is a subgroup of H_i.
## This functions embeds G first into the direct product of the induced
## permutation groups on the orbits. This then is embedded into the young group
## corresponding to the orbits by iteratively replacing the restrictions
## of G on each orbit first with  the wreath product of
## symmetric groups corresponding to a minimal block system of
## that transitive constituent and then with the symmetric group on that orbit.
## Up to this step, the indices in the subgroup chain can be preetty high.
## This chain is followed by a subgroup ladder from the young subgroup to
## S_(n) is constructed with SubgroupLadderForYoungGroup, which produceds a
## subgroup ladder with indiceds at most n.
InstallGlobalFunction( SubgroupLadder,
function(arg)
	local
		refine,
		G,
		H,
		n,
		i,
		orbs,
		gens,
		subgroupladder,
		tmpladder,
		directfactors,
		gensSo,
		Y;

	if (Length(arg) <> 1 and Length(arg) <> 2 and Length(arg) <> 3) then
		ErrorNoReturn("usage: SubgroupLadder(<G>[, <n>][,<refine>]), where <G> is a intransitive subgroup of the symmetric group on <n> letters\n");
	fi;

	if (Length(arg) = 3) then
		G := arg[1];
		n := arg[2];
		refine := arg[3];
	else
		if (Length(arg) = 2) then
			G := arg[1];
			n := arg[2];
			refine := false;
		else
			G := arg[1];
			n := LargestMovedPoint(G);
			refine := false;
		fi;
	fi;

	orbs := List(Orbits(G));
	gens := List(GeneratorsOfGroup(G));

	# initialize directfactors as the list of the induced permutation groups on the orbits
	directfactors := List(orbs, o->Group(DuplicateFreeList(List(gens, x->RestrictedPerm(x, o)))));
	# embed G into the direct product of these transitive constituents.
	# As the index may be very high, we compute a Ascendingchain
	H := DirectProductPermGroupsWithoutRenamingNC(directfactors);
	if refine then
		subgroupladder := AscendingChain(H, G);
	else
		subgroupladder := DuplicateFreeList([G, H]);
	fi;

	# loop in directfactors and try to embed these into symmetric groups
	# end result is a young group
	for i in [1..Length(orbs)] do
		# check if directfactor is primitive
		if (not IsPrimitive(directfactors[i], orbs[i])) then
			# embedding into wreath product on blocks
			# TO DO: CHECK IF WREATHPRODUCT AND DIRECTFACTOR WERE THE SAME
			directfactors[i] := EmbeddingWreathProduct(directfactors[i]);
			Add(subgroupladder, DirectProductPermGroupsWithoutRenamingNC(directfactors));
			gensSo := GeneratorsOfGroup(SymmetricGroup(orbs[i]));
			# embedding of wreath product into symmetric group
			if (not IsSubgroup(directfactors[i], Group(gensSo))) then
				tmpladder := SubgroupLadderWreath(WreathProductInfo(directfactors[i]).components);
				for H in tmpladder do
					directfactors[i] := H;
					Add(subgroupladder, DirectProductPermGroupsWithoutRenamingNC(directfactors));
				od;
			fi;
		else
			if refine then
				tmpladder := AscendingChain(SymmetricGroup(orbs[i]), directfactors[i]);
			else
				tmpladder := DuplicateFreeList([directfactors[i], SymmetricGroup(orbs[i])]);
			fi;
			for H in tmpladder{[2..Length(tmpladder)]} do
				directfactors[i] := H;
				Add(subgroupladder, DirectProductPermGroupsWithoutRenamingNC(directfactors));
			od;
		fi;
	od;

	Y := Remove(subgroupladder);
	Append( subgroupladder, SubgroupLadderForYoungGroup(Y, n) );
	return subgroupladder;
end);

## Given a permutation group G such that G acts imprimitive on moving points,
## this function will compute an embedding into the wreath product of S_m
## with S_k where k is the size of a minimal non-trivial block system and m
## is the size of the blocks.
InstallGlobalFunction( EmbeddingWreathProduct,
function(G)
	local blocks, lengths, rep;

	# We compute a block system of median length
	blocks := AllBlocks(G);
	lengths := List(blocks, Length);
	lengths := Set(lengths);
	rep := First(blocks, x -> Length(x) = Median(lengths));
	blocks := Orbit(G, rep, OnSets);

	# compute the wreath product corresponding to this block system
	return EmbeddingWreathProductOp(blocks);
end);

## Given a permutation group G and a set Om, such that G acts imprimitive on Om,
## this function will compute an embedding into the wreath product of S_m
## with S_k where k is the size of a minimal non-trivial block system and m
## is the size of the blocks.
## The output is [lambda, emb], where emb is the embedding and lambda is a list,
## such that G and the image of G under emb are permutation isomorphic,
## that is lambda[o^g] = (lambda[o])^(g)emb for all o in Om.
InstallGlobalFunction( EmbeddingWreathProductOp,
function(B)
	local
		k,              # size of blocks system B
		m,              # size of the blocks in B (they all have equal size)
		W,              # the wreath product of S_m with S_k
		basegens,       # generators of the base group of W, being (S_m)^k
		hgens,          # generators of the top group
		perms,          # list of permutation of integers
		                # inducing the embedding of S_m into the copies in W
		info;           # wreath product info of W

	# Initialize all variables
	k := Length(B);
	m := Length(B[1]);

	# construct the wreath product info
	basegens := Concatenation( List([1..k], i-> List(GeneratorsOfGroup(SymmetricGroup(B[i]))) ));
	hgens := [Product([1..m], i -> CycleFromList(List([1..k], j->B[j][i])), ()), MappingPermListList(B[1],B[2])];
	perms := List( [1..k], i-> MappingPermListList([1..m], B[i]) );

	W := Group(Concatenation(basegens, hgens));
	info := rec(
		I := SymmetricGroup(k),
		alpha := IdentityMapping( SymmetricGroup(k) ),
		base := Group(basegens),
		basegens := basegens,
		components := ShallowCopy(B),
		degI := k,
		embeddingType := NewType(
			GeneralMappingsFamily(PermutationsFamily,PermutationsFamily),
			IsEmbeddingImprimitiveWreathProductPermGroup),
		embeddings := [],
		groups := [SymmetricGroup(m), SymmetricGroup(k)],
		hgens := hgens,
		permimpr := true,
		perms := perms
	);
	SetWreathProductInfo(W, info);
	return W;
end);

InstallGlobalFunction(SubgroupLadderWreath,
function(blocks)
	local
		ladder,    # the constructed subgroupladder
		i,         # loop integer variable
		G,         # loop variable for Groups
		l;         # the number of blocks

	ladder := [];
	l := Length(blocks);

	# the first group is not in the output

	for i in Reversed([2..l-1]) do
		G := DirectProductPermGroupsWithoutRenamingNC( Concatenation([EmbeddingWreathProductOp(blocks{[1..i]})], List([i+1..l], k -> SymmetricGroup(blocks[k]))));
		Add(ladder, G);
	od;

	G := YoungGroupFromPartitionNC(blocks);
	Add(ladder, G);
	#Append(ladder, SubgroupLadderForYoungGroup(G));
	return ladder;
end);

# vim: set noet ts=4:

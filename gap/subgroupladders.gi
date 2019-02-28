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

	# Generate the direct product Y and add the DirectProductInfo info to Y.
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
		ladder,       # the ladder is a list containing triples [partition, lastDirection]
		              # lastDirection is an integer -1, 1 or 0 depending on whether the last step in the chain was
		              # down, up or the group was the first in the ladder.
		partition,    # partition part = (p_1, ..., p_k).
		              # Every p_i is a list of positive integers such that the union of the p_i is disjoint.
		k,            # size of current partition
		p;            # loop variable, integer in p_k in partition.
		
	# Check Input and Initialize the variables
	if (Length(arg) <> 1 and Length(arg) <> 2) then
		ErrorNoReturn("usage: SubgroupLadder(<G>[, <n>]), where <G> is a young subgroup of the symmetric group on <n> letters\n");
	fi;

	if (Length(arg) = 2) then
		G := arg[1];
		n := arg[2];
	else
		G := arg[1];
		n := NrMovedPoints(G);
	fi;

	if (not IsPermGroup(G)) then
		ErrorNoReturn("the first argument must be a permutation group!\n");
	fi;

	if(Length(arg) = 2) then
		if (n < LargestMovedPoint(G)) then
			ErrorNoReturn("degree of desired parent symmetric group is smaller than the largest moved point of G!\n");
		fi;
		partition := List( Orbits(G, [1..n]), o -> List(o) );
	else
		partition := List( Orbits(G), o -> List(o));
	fi;

	if (YoungGroupFromPartition(partition) <> G) then
		ErrorNoReturn("the first argument must be a young subgroup!\n");
	fi;

	ladder := [rec(Group := G, LastDirection := 0)];
	k := Length(partition);

	# Start the iterative construction of the ladder
	while (k <> 1 or Length(partition[1]) < n) do
		# This is the case where partition = (p_1, p_2, p_3, ..., p_k), p in p_k and |p_k| = 1,
		# Add the young subgroup with partition (p_1 U {p}, p_2, p_3, ..., p_{k-1})
		# and continue iteration with this group.
		if (Length(partition[k]) = 1) then
			p := Remove(partition[k]);
			Add(partition[1], p);
			Add(ladder, rec(Group:=YoungGroupFromPartitionNC(partition), LastDirection:=1));
			k := k - 1;
		# This is the case where partition = (p_1, p_2, p_3, ..., p_k), p in p_k and |p_k| >= 2.
		# First add the young subgroup with partition (p_1, p_2, p_3, ..., p_k - {p}, {p}).
		# Then add the young subgroup with partition (p_1 U {p}, p_2, p_3, ..., p_k - {p})
		# and continue iteration with this group.
		else
			p := Remove(partition[k]);
			Add(partition, [p]);
			Add(ladder, rec(Group:=YoungGroupFromPartitionNC(partition), LastDirection:=-1));

			Remove(partition);
			Add(partition[1], p);
			Add(ladder, rec(Group:=YoungGroupFromPartitionNC(partition), LastDirection:=1));
		fi;
	od;

	# Return the ladder.
	return ladder;
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
		ladder,
		tmpladder,
		step,
		directfactors;

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
	ladder := SubgroupLadderRefineStep(G, H);
	ladder[1].LastDirection := 0;

	# Loop in directfactors and try to embed these into symmetric groups.
	# End result is a young group.
	for i in [1..Length(orbs)] do
		# Check if directfactor is primitive
		if (not IsPrimitive(directfactors[i], orbs[i])) then
			tmpladder := SubgroupLadderForImprimitive(directfactors[i]);
			for step in tmpladder{[2..Length(tmpladder)]} do
				directfactors[i] := step.Group;
				H := DirectProductPermGroupsWithoutRenamingNC(directfactors);
				Add(ladder, rec(Group := H, LastDirection := step.LastDirection));
			od;
		else
			tmpladder := SubgroupLadderRefineStep( directfactors[i], SymmetricGroup(orbs[i]) );
			for step in tmpladder{[2..Length(tmpladder)]} do
				directfactors[i] := step.Group;
				H := DirectProductPermGroupsWithoutRenamingNC(directfactors);
				Add(ladder, rec(Group := H, LastDirection := step.LastDirection));
			od;
		fi;
	od;

	# Now we have a young group.
	step := ladder[Length(ladder)];
	tmpladder := SubgroupLadderForYoungGroup(step.Group, n);
	Append( ladder, tmpladder{[2..Length(tmpladder)]});
	return ladder;
end);

## This method is called when the index may be critical high,
## whereas G is a subgroup of H
## If refine is true, try to construct an ascending chain from G into H.
InstallGlobalFunction( SubgroupLadderRefineStep,
function(G, H, refine)
	local
		ladder;

	if refine then
		ladder := List(AscendingChain(H, G), x -> rec(Group:=x, LastDirection:=1));
	else
		ladder :=  List(DuplicateFreeList([G, H]), x -> rec(Group:=x, LastDirection:=1));
	fi;

	return ladder;
end);

InstallGlobalFunction( WreathProductOnBlocks,
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

InstallGlobalFunction(SubgroupLadderForImprimitive,
function(G)
	local
		ladder,    # the constructed subgroupladder
		allblocks, # representants of all possible block systems of G
		lengths,   # set of all block sizes in allblocks
		rep,       # representant of the block system with median block size out of all block systems
		blocks,    # block system of G for the represenant rep
		l,         # the number of blocks
		i,         # loop integer variable
		H,         # loop variable for Groups
		tmpladder; # placeholder for part of ladder

	# We compute a block system of median length
	allblocks := AllBlocks(G);
	lengths := List(allblocks, Length);
	lengths := Set(lengths);
	rep := First(allblocks, x -> Length(x) = Median(lengths));
	blocks := Orbit(G, rep, OnSets);
	l := Length(blocks);

	ladder := [rec(Group := G, LastDirection := 0)];
	
	# First embedd the group into the wreath product on the blocks
	Add(ladder, rec(Group := WreathProductOnBlocks(blocks), LastDirection := 1));

	# Iteratively go down from wreath product to base group
	for i in Reversed([2..l-1]) do
		H := DirectProductPermGroupsWithoutRenamingNC( Concatenation([WreathProductOnBlocks(blocks{[1..i]})], List([i+1..l], k -> SymmetricGroup(blocks[k]))));
		Add(ladder, rec(Group := H, LastDirection := -1));
	od;

	# H is now the base group, i.e. a young group.
	# Construct a subgroupladder for the young group.
	H := YoungGroupFromPartitionNC(blocks);
	tmpladder := SubgroupLadderForYoungGroup(H);
	tmpladder[1].LastDirection := -1;
	Append(ladder, tmpladder);

	return ladder;
end);

# vim: set noet ts=4:

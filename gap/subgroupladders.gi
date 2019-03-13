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
		partition,    # partition = (p_1, ..., p_k).
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

	if (YoungGroupFromPartitionNC(partition) <> G) then
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
			Remove(partition);
			Add(partition[1], p);
			Add(ladder, rec(Group:=YoungGroupFromPartitionNC(partition), LastDirection:=1));
			k := k - 1;
		# This is the case where partition = (p_1, p_2, p_3, ..., p_k), p in p_k and |p_k| >= 2.
		# First add the young subgroup with partition (p_1, p_2, p_3, ..., p_k - {p}, {p}).
		# and continue iteration with this group.
		else
			p := Remove(partition[k]);
			Add(partition, [p]);
			Add(ladder, rec(Group:=YoungGroupFromPartitionNC(partition), LastDirection:=-1));
			k := k + 1;
		fi;
	od;

	return ladder;
end);

InstallGlobalFunction( SubgroupLadderCheckInput, 
function(arg)
	local 
		G,
		refine,
		n;

	if (Length(arg) <> 1 and Length(arg) <> 2 and Length(arg) <> 3) then
		ErrorNoReturn("usage: SubgroupLadder(<G>[,<refine>][, <n>]), where <G> is a subgroup of the symmetric group on <n> letters and refine is a boolean\n");
	fi;

	G := arg[1];
	if (not IsPermGroup(G)) then
		ErrorNoReturn("the first argument must be a permutation group!\n");
	fi;

	if (Length(arg) = 1) then
		refine := false;
	else
		refine := arg[2];
	fi;

	if (not IsBool(refine)) then
		ErrorNoReturn("the second argument must be a bool!\n");
	fi;

	if (Length(arg) = 3) then
		n := arg[3];
		if (not IsInt(n)) then
			ErrorNoReturn("the third argument must be an int!\n");
		fi;
		if (n < LargestMovedPoint(G)) then
			ErrorNoReturn("the third argument is smaller than the largest moved point on G");
		fi;
	fi;
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
		tmpArg,
		directfactors;

	SubgroupLadderCheckInput(arg);
	G := arg[1];
	if (Length(arg) = 1) then
		refine := false;
	else
		refine := arg[2];
	fi;

	# embed G into the direct product of the transitive constituents of G.
	# note that G is a subdirect product of the transtive constituents,
	# hence we embed a subdirect product into a direct product. Index may be large.
	orbs := Orbits(G);
	gens := GeneratorsOfGroup(G);
	directfactors := List(orbs, o->Group(DuplicateFreeList(List(gens, x->RestrictedPerm(x, o)))));
	H := DirectProductPermGroupsWithoutRenamingNC(directfactors);
	ladder := SubgroupLadderRefineStep(G, H, refine);
	ladder[1].LastDirection := 0;

	tmpladder := SubgroupLadderForDirectProductOfTransitiveGroups(H);
	Append(ladder, tmpladder{[2..Length(tmpladder)]});

	return ladder;
end);

InstallGlobalFunction(SubgroupLadderForDirectProductOfTransitiveGroups, function(arg)
	local 
		G,
		refine,
		ladder,
		directfactors,
		i,
		tmpladder,
		step,
		H,
		tmpArg;

	G := arg[1];
	if (Length(arg) = 1) then
		refine := false;
	else
		refine := arg[2];
	fi;

	# by iteration construct ladder for each direct factor
	ladder := [rec(Group := G, LastDirection := 0)];
	directfactors := ShallowCopy(DirectFactorsOfGroup(G));
	for i in [1..Length(directfactors)] do
		tmpladder := SubgroupLadderForTransitive(directfactors[i], refine);
		for step in tmpladder{[2..Length(tmpladder)]} do
			directfactors[i] := step.Group;
			H := DirectProductPermGroupsWithoutRenamingNC(directfactors);
			Add(ladder, rec(Group := H, LastDirection := step.LastDirection));
		od;
	od;

	# now we construct a ladder for the remaining young group.
	tmpladder := SubgroupLadderForYoungGroup(ladder[Length(ladder)].Group);
	Append( ladder, tmpladder{[2..Length(tmpladder)]});

	return ladder;
end);

InstallGlobalFunction( SubgroupLadderForTransitive, 
function(arg)
	local
		G,
		refine,
		orb,
		ladder;

	if (Length(arg) <> 1 and Length(arg) <> 2 and Length(arg) <> 3) then
		ErrorNoReturn("usage: SubgroupLadder(<G>[,<refine>][, <n>]), where <G> is a subgroup of the symmetric group on <n> letters and refine is a boolean\n");
	fi;

	G := arg[1];
	if (Length(arg) = 1) then
		refine := false;
	else
		refine := arg[2];
	fi;

	if not IsTransitive(G) then
		ErrorNoReturn("G must be a transitive group!\n");
	fi;

	orb := List(Orbits(G)[1]);

	# Check if directfactor is imprimitive
	if (not IsPrimitive(G, orb)) then
		ladder := SubgroupLadderForImprimitive(G, refine);
	else
		ladder := SubgroupLadderRefineStep( G, SymmetricGroup(orb), refine );
	fi;

	return ladder;
end);

InstallGlobalFunction(SubgroupLadderForImprimitive,
function(arg)
	local
		G,         # imprimitive permutation group
		refine,    # boolean, if true, ascending chains are placed where index is bad
		ladder,    # the constructed subgroupladder
		W,         # wreath product supergroup of G
		l,         # loop integer variable
		H,         # loop variable for Groups
		p,         # moved points of top group
		step,
		tmpladder, # placeholder for part of ladder
		tmpArg;    # placeholder for arguments on SubgroupLadderForYoungGroup call

	if (Length(arg) <> 1 and Length(arg) <> 2 and Length(arg) <> 3) then
		ErrorNoReturn("usage: SubgroupLadder(<G>[,<refine>][, <n>]), where <G> is a imprimitive subgroup of the symmetric group on <n> letters and refine is a boolean\n");
	fi;

	G := arg[1];
	if (Length(arg) = 1) then
		refine := false;
	else
		refine := arg[2];
	fi;
	
	# First embedd the group into a wreath product on some block system of G
	W := WreathProductSupergroupOfImprimitive(G);
	ladder := SubgroupLadderRefineStep( G, W, refine);
	ladder[1].LastDirection := 0;

	# Next embed the top group of wreath product into a symmetric group
	# Then go down from symmetric group to trivial group
	# Comstruct the dual ladder for the whole wreath product
	tmpladder := SubgroupLadderForTransitive(WreathProductInfo(W).groups[2], refine);
	H := tmpladder[Length(tmpladder)].Group;
	p := List(Orbits(H)[1]);
	for l in [1..Length(p)] do
		Add(tmpladder, rec(Group := SymmetricGroup(p{[1..(Length(p)-l)]}), LastDirection := -1));
	od;
	for step in tmpladder{[2..Length(tmpladder)]} do
		H := WreathProductWithoutRenaming(WreathProductInfo(W).groups[1], step.Group, WreathProductInfo(W).perms);
		Add(ladder, rec(Group := H, LastDirection := step.LastDirection));
	od;

	# We have now reached the base group.
	tmpladder := SubgroupLadderForDirectProductOfTransitiveGroups(ladder[Length(ladder)].Group,refine);
	Append(ladder, tmpladder{[2..Length(tmpladder)]});

	return ladder;
end);

InstallGlobalFunction(WreathProductSupergroupOfImprimitive, 
function(G)
	local 
		gens,         # generators of group G
		order,        # order of smallest wreath product
		W,            # smallest wreath product
		allblocks,    # representants of all possible block systems of G
		rep,          # loop variable, representant in allblocks of some block system
		B,            # block system of G for the represenant rep
		k,            # length of block system B
		gens_bar,     # gens induce permutations of block system B, induce generators of top group
		perms,        # list of translations from block B[1] into block B[i], 
		              # i.e. perms[i] is an element in G s.t. B[1]^perms[i] = B[i]
		l,            # loop variable for construction of t
		S1,           # stabilizer group of B[1]
		SB1,          # S1 induces a permutation group on B[1]
		o;            # order of the to constructed wreath product

	gens := GeneratorsOfGroup(G);
	order := infinity;
	W := Group(());
	allblocks := AllBlocks(G);

	for rep in allblocks do
		B := Orbit(G, rep, OnSets);
		k := Length(B);
		gens_bar := List(gens, g -> PermList(List([1..k], i -> PositionProperty(B, b -> B[i][1]^g in b ))));
		gens_bar := Set(gens_bar);
		RemoveSet(gens_bar, ());
		perms := List([1..k], i -> ());
		for l in [2..k] do
			perms[l] := SchreierTreeTrace_(G, B[1][1], B[l][1]);
		od;

		S1 := Stabilizer(G,B[1],OnSets);
		SB1 := Set(List(GeneratorsOfGroup(S1), g -> RestrictedPerm(g,B[1])));
		RemoveSet(SB1, ());
		if (IsEmpty(SB1)) then
			Add(SB1, ());
		fi;

		o := Order(Group(SB1))^k*Order(Group(gens_bar));
		if o >= order then
			continue;
		fi;
		order := o;
		W := WreathProductWithoutRenaming(Group(SB1), Group(gens_bar), perms);
	od;

	return W;
end);

InstallGlobalFunction(WreathProductWithoutRenaming,
function(basefactor, topgroup, perms)
	local
		k,              # number of copies of basefactor in basegroup
		topgroupgens,   # generators of topgroup
		basefactorgens, # generators of basefactorgens
		img,            # list of images which represent the action of top group on base group
		x,              # loop variable, integer representing some generator of topgroup
		topgen,         # some generator of topgroupgens
		i,              # loop variable, integer representing the i-th factor in base group
		g,              # loop variable, some generator of i-th factor in base group
		basegens,       # generators of base group of wreath product
		base,           # base group generated by basegens
		maps,           # list of maps which represent the action of top group on base group
		hgens,          # generators of top group in wreath product induced by maps
		W,              # wreath product of basefactor and topgroup
		info;           # wreath product info of W

	k := Length(perms);
	topgroupgens := GeneratorsOfGroup(topgroup);
	basefactorgens := GeneratorsOfGroup(basefactor);
	img := [];
	for x in [1..Length(topgroupgens)] do
		Add(img, []);
		topgen := topgroupgens[x];
		for i in [1..k] do
			for g in basefactorgens do
				Add(img[x], g^perms[i^(topgen)]);
			od;
		od;
	od;
	basegens := Concatenation( List([1..k], i->List(basefactorgens, g -> g^perms[i])) );
	base := Group(basegens);
	maps := List([1..Length(topgroupgens)], x -> GroupHomomorphismByImagesNC(base, base, basegens, img[x]) );
	hgens := List(maps, ConjugatorOfConjugatorIsomorphism);
	W := Group(Concatenation(basegens, hgens));

	info := rec(
		I := topgroup,
		alpha := IdentityMapping( topgroup ),
		base := base,
		basegens := basegens,
		components := List([1..k], i -> List(MovedPoints(basefactor), x -> x^perms[i])),
		degI := k,
		embeddingType := NewType(
			GeneralMappingsFamily(PermutationsFamily,PermutationsFamily),
			IsEmbeddingImprimitiveWreathProductPermGroup),
		embeddings := [],
		groups := [basefactor, topgroup],
		hgens := hgens,
		permimpr := true,
		perms := perms
	);
	SetWreathProductInfo(W, info);
	return W;
end);

# use the schreier tree in the stab chain of G to trace some element g in G s.t. a^g=b
InstallGlobalFunction(SchreierTreeTrace_, 
function(G, a, b)
	local 
		T,     # Schreier tree
		c,     # base point in T
		g,     # element in G s.t. a^g = c
		h,     # element in G s.t. b^h = c
		x,     # loop variable, point 
		t;     # loop variable, element in G
	T := StabChain(G).transversal;
	c := StabChain(G).orbit[1];
	g := ();
	h := ();
	x := a;
	while x <> c do
		t := T[x];
		x := x^t;
		g := g * t;
	od;
	x := b;
	while x <> c do
		t := T[x];
		x := x^t;
		h := h * t;
	od;
	return g * h^(-1);
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
# vim: set noet ts=4:

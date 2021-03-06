#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# Implementations
#

InstallGlobalFunction( SubgroupLadder,
function(arg)
	local
		G,             # permutation group
		refine,        # boolean, if true, ascending chains are placed where index is large
		gens,          # generators of G
		orbs,          # orbits of G
		directFactors, # direct factors of the direct product of transitive constituents of G
		orbit,         # loop variable, one orbit of G
		gensDirFactor, # loop variable, generators of a direct factor
		H,             # placeholder for group in subgroupladder
		dirFactor,     # loop variable, integer representing a direct factor
		tmpLadder,     # placeholder for part of ladder
		tmpArg,        # placeholder for arguments on SubgroupLadder... variants calls
		step,          # loop variable over records of tmpLadder
		ladder,        # the constructed subgroupladder
		movedPoints,   # loop variable used for construction in the trivial case
		movedPoint;    # loop variable used to add points to symmetric group in trivial case

	CallFuncList(_SubgroupLadderCheckInput,arg);
	G := arg[1];
	if (Length(arg) = 1) then
		refine := false;
	else
		refine := arg[2];
	fi;

	# catch the trivial case
	if IsNaturalSymmetricGroup(G) then
		ladder := [ rec(Group := G, LastDirection := 0) ];
		if (Length(arg) <> 3) then
			return ladder;
		else
			movedPoints := List(MovedPoints(G));
			for movedPoint in Difference([1..arg[3]], movedPoints) do;
				Add(movedPoints, movedPoint);
				Add(ladder, rec(Group := SymmetricGroup(movedPoints), LastDirection := 1));
			od;
			return ladder;
		fi;
	fi;

	# embed G into the direct product of the transitive constituents of G.
	# note that G is a subdirect product of the transtive constituents,
	# hence we embed a subdirect product into a direct product. Index may be large.
	gens := GeneratorsOfGroup(G);
	orbs := Orbits(G);
	directFactors := [];
	for orbit in orbs do
		gensDirFactor := Set(List(gens, x->RestrictedPerm(x, orbit)));
		RemoveSet(gensDirFactor ,());
		Add(directFactors,Group(gensDirFactor));
	od;
	H := DirectProductPermGroupsWithoutRenamingNC(directFactors);
	ladder := _SubgroupLadderRefineStep(G, H, refine);
	ladder[1].LastDirection := 0;

	# by iteration construct ladder for each transitive direct factor
	for dirFactor in [1..Length(directFactors)] do
		tmpArg := [directFactors[dirFactor], refine];
		tmpLadder := CallFuncList(SubgroupLadderForTransitive, tmpArg);
		for step in tmpLadder{[2..Length(tmpLadder)]} do
			directFactors[dirFactor] := step.Group;
			H := DirectProductPermGroupsWithoutRenamingNC(directFactors);
			Add(ladder, rec(Group := H, LastDirection := step.LastDirection));
		od;
	od;

	# now we construct a ladder for the remaining young group
	H := ladder[Length(ladder)].Group;
	tmpArg := [H];
	if (Length(arg) = 3) then
		Add(tmpArg, arg[3]);
	fi;
	tmpLadder := CallFuncList(SubgroupLadderForYoungGroup, tmpArg);
	Append( ladder, tmpLadder{[2..Length(tmpLadder)]});

	return ladder;
end);

InstallGlobalFunction( _SubgroupLadderCheckInput,
function(arg)
	local
		G,        # permutation group
		refine,   # bool, whether the algorithm should try using ascending chains whenever the index may be large
		n;        # positive integer, the degree of the parent symmetric group

	if (Length(arg) <> 1 and Length(arg) <> 2 and Length(arg) <> 3) then
		ErrorNoReturn("usage: SubgroupLadder(<G>[,<refine>][, <n>]), where <G> is a subgroup of the symmetric group on <n> letters and refine is a boolean\n");
	fi;

	G := arg[1];
	if (not IsPermGroup(G)) then
		ErrorNoReturn("the first argument must be a permutation group\n");
	fi;

	if (Length(arg) = 1) then
		refine := false;
	else
		refine := arg[2];
	fi;

	if (not IsBool(refine)) then
		ErrorNoReturn("the second argument must be a bool\n");
	fi;

	if (Length(arg) = 3) then
		n := arg[3];
		if (not IsInt(n) or n <= 0) then
			ErrorNoReturn("the third argument must be an positive integer\n");
		fi;
		if (n < LargestMovedPoint(G)) then
			ErrorNoReturn("degree of desired parent symmetric group is smaller than the largest moved point of G");
		fi;
	fi;
end);

InstallGlobalFunction( _SubgroupLadderRefineStep,
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

InstallGlobalFunction( SubgroupLadderForYoungGroup,
function(arg)
	local
		G,            # the provided young subgroup we will start the construction from
		orb,          # the orbits of the permutation group G
		n,            # degree of the parent symmetric group
		ladder,       # the ladder is a list containing triples [partition, lastDirection]
		              # lastDirection is an integer -1, 1 or 0 depending on whether the last step in the chain was
		              # down, up or the group was the first in the ladder.
		partition,    # partition = (p_1, ..., p_k) of young group G.
		              # Every p_i is a list of positive integers such that the union of the p_i is disjoint.
		k,            # size of current partition
		point;        # loop variable, integer in p_k in partition.

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
		ErrorNoReturn("the first argument must be a permutation group\n");
	fi;

	if(Length(arg) = 2) then
		if (not IsInt(n) or n <= 0) then
			ErrorNoReturn("the second argument must be a positive integer\n");
		fi;
		if (n < LargestMovedPoint(G)) then
			ErrorNoReturn("degree of desired parent symmetric group is smaller than the largest moved point of G\n");
		fi;
		partition := List( Orbits(G, [1..n]), o -> List(o) );
	else
		partition := List( Orbits(G), o -> List(o));
	fi;

	if (YoungGroupFromPartitionNC(partition) <> G) then
		ErrorNoReturn("the first argument must be a young subgroup\n");
	fi;

	ladder := [rec(Group := G, LastDirection := 0)];
	k := Length(partition);

	# Start the iterative construction of the ladder
	while (k <> 1 or Length(partition[1]) < n) do
		# This is the case where partition = (p_1, p_2, p_3, ..., p_k), point in p_k and |p_k| = 1,
		# Add the young subgroup with partition (p_1 U {p}, p_2, p_3, ..., p_{k-1})
		# and continue iteration with this group.
		if (Length(partition[k]) = 1) then
			point := Remove(partition[k]);
			Remove(partition);
			Add(partition[1], point);
			Add(ladder, rec(Group:=YoungGroupFromPartitionNC(partition), LastDirection:=1));
			k := k - 1;
		# This is the case where partition = (p_1, p_2, p_3, ..., p_k), point in p_k and |p_k| >= 2.
		# First add the young subgroup with partition (p_1, p_2, p_3, ..., p_k - {p}, {p}).
		# and continue iteration with this group.
		else
			point := Remove(partition[k]);
			Add(partition, [point]);
			Add(ladder, rec(Group:=YoungGroupFromPartitionNC(partition), LastDirection:=-1));
			k := k + 1;
		fi;
	od;

	return ladder;
end);

InstallGlobalFunction( SubgroupLadderForTransitive,
function(arg)
	local
		G,             # transitive permutation group
		refine,        # boolean, if true, ascending chains are placed where index is large
		orb,           # orbit of G
		ladder;        # the constructed subgroupladder

	CallFuncList(_SubgroupLadderCheckInput,arg);
	G := arg[1];
	if (Length(arg) = 1) then
		refine := false;
	else
		refine := arg[2];
	fi;

	if not IsTransitive(G) then
		ErrorNoReturn("G must be a transitive group\n");
	fi;

	orb := List(Orbits(G)[1]);

	# Check if directfactor is imprimitive
	if (not IsPrimitive(G, orb)) then
		ladder := CallFuncList(SubgroupLadderForImprimitive, arg);
	else
		if Length(arg) = 3 then
			ladder := _SubgroupLadderRefineStep(G, SymmetricGroup(arg[3]), refine );
		else
			ladder := _SubgroupLadderRefineStep(G, SymmetricGroup(orb), refine );
		fi;
	fi;

	return ladder;
end);

InstallGlobalFunction(SubgroupLadderForImprimitive,
function(arg)
	local
		G,             # imprimitive permutation group
		refine,        # boolean, if true, ascending chains are placed where index is bad
		ladder,        # the constructed subgroupladder
		W,             # wreath product supergroup of G
		i,             # loop integer variable
		H,             # loop variable for Groups
		mp,            # moved points of top group
		step,          # loop variable over records of tmpLadder
		tmpLadder,     # placeholder for part of ladder
		tmpArg,        # placeholder for arguments on SubgroupLadderForYoungGroup call
		directFactors, # direct factors of base group
		dirFactor;     # loop variable, integer representing a direct factor

	CallFuncList(_SubgroupLadderCheckInput,arg);
	G := arg[1];
	if (Length(arg) = 1) then
		refine := false;
	else
		refine := arg[2];
	fi;

	if not IsTransitive(G) then
		ErrorNoReturn("G must be a transitive group\n");
	fi;
	if IsPrimitive(G, List(Orbits(G)[1])) then
		ErrorNoReturn("G must be an imprimitive group\n");
	fi;

	# First embed the group into a wreath product on some block system of G
	W := WreathProductSupergroupOfImprimitive(G);
	ladder := _SubgroupLadderRefineStep( G, W, refine);
	ladder[1].LastDirection := 0;

	# Next embed the top group of wreath product into a symmetric group
	# Then go down from symmetric group to trivial group
	# Construct an anologue ladder for the whole wreath product by replacing the top group
	tmpLadder := SubgroupLadderForTransitive(WreathProductInfo(W).groups[2], refine);
	H := tmpLadder[Length(tmpLadder)].Group;
	mp := List(Orbits(H)[1]);
	for i in [1..Length(mp)-1] do
		Add(tmpLadder, rec(Group := SymmetricGroup(mp{[1..(Length(mp)-i)]}), LastDirection := -1));
	od;
	for step in tmpLadder{[2..Length(tmpLadder)]} do
		H := WreathProductWithoutRenaming(WreathProductInfo(W).groups[1], step.Group, WreathProductInfo(W).perms);
		Add(ladder, rec(Group := H, LastDirection := step.LastDirection));
	od;

	# We have now reached the base group.
	# We know that the factors of the base group are conjugate by using perms of W
	# Construct ladder for one factor and by iteration an anologue ladder for base group
	directFactors := List(WreathProductInfo(W).perms, g -> WreathProductInfo(W).groups[1]^g);
	tmpArg := [WreathProductInfo(W).groups[1], refine];
	tmpLadder := CallFuncList(SubgroupLadder, tmpArg);
	for dirFactor in [1..Length(directFactors)] do
		for step in tmpLadder{[2..Length(tmpLadder)]} do
			directFactors[dirFactor] := step.Group^WreathProductInfo(W).perms[dirFactor];
			H := DirectProductPermGroupsWithoutRenamingNC(directFactors);
			Add(ladder, rec(Group := H, LastDirection := step.LastDirection));
		od;
	od;

	# We have now reached a Young group.
	H := ladder[Length(ladder)].Group;
	tmpArg := [H];
	if (Length(arg) = 3) then
		Add(tmpArg, arg[3]);
	fi;
	tmpLadder := CallFuncList(SubgroupLadderForYoungGroup, tmpArg);
	Append( ladder, tmpLadder{[2..Length(tmpLadder)]});

	return ladder;
end);

InstallGlobalFunction(WreathProductSupergroupOfImprimitive,
function(G)
	local
		gens,           # generators of group G
		order,          # order of smallest constructed wreath product
		W,              # smallest constructed wreath product as described in documentation in .gd file
		allBlocks,      # representants of all possible block systems of G
		repBlock,       # loop variable, representant in allBlocks of some block system
		blockSystem,    # block system of G for the represenant rep
		k,              # length of block system
		gensBlockPerms, # gens induce permutations of block system, these will be generators of top group
		perms,          # list of translations from block 1 into block i,
		                # i.e. perms[i] is an element in G s.t. blockSystem[1]^perms[i] = blockSystem[i]
		gensStabBlock1, # generators of stabilizer group of block 1 induce a permutation group on block 1,
		                # these will the generators of base factor group
		o;              # order of the to constructed wreath product

	if not IsPermGroup(G) then
		ErrorNoReturn("G must be a permutation group\n");
	fi;
	if not IsTransitive(G) then
		ErrorNoReturn("G must be a transitive group\n");
	fi;
	if IsPrimitive(G) then
		ErrorNoReturn("G must be an imprimitive group\n");
	fi;

	gens := GeneratorsOfGroup(G);
	order := Factorial(NrMovedPoints(G));
	W := SymmetricGroup(MovedPoints(G));
	allBlocks := AllBlocks(G);

	for repBlock in allBlocks do
		blockSystem := Orbit(G, repBlock, OnSets);
		k := Length(blockSystem);
		gensBlockPerms := List(gens, g -> PermList(List([1..k], i -> PositionProperty(blockSystem, b -> blockSystem[i][1]^g in b ))));
		gensBlockPerms := Set(gensBlockPerms);
		RemoveSet(gensBlockPerms, ());
		perms := List([1..k], i -> _SchreierTreeTrace(G, blockSystem[1][1], blockSystem[i][1]));
		perms[1] := ();

		gensStabBlock1 := Set(List(GeneratorsOfGroup(Stabilizer(G,blockSystem[1],OnSets)), g -> RestrictedPerm(g,blockSystem[1])));
		RemoveSet(gensStabBlock1, ());
		if (IsEmpty(gensStabBlock1)) then
			Add(gensStabBlock1, ());
		fi;

		o := Order(Group(gensStabBlock1))^k*Order(Group(gensBlockPerms));
		if o >= order then
			continue;
		fi;
		order := o;
		W := WreathProductWithoutRenaming(Group(gensStabBlock1), Group(gensBlockPerms), perms);
	od;

	return W;
end);

InstallGlobalFunction( YoungGroupFromPartition,
function(part)
	if (IsDuplicateFree(Concatenation(part))) then
		return YoungGroupFromPartitionNC(part);
	fi;
	ErrorNoReturn("The Argument must be a list of disjoint lists\n");
end);

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
		mp,          # moved points of G
		dirProduct,  # the direct product we will return
		generators,  # the generators of P.
		grps,        # record entry of info, direct factor groups
		olds,        # record entry of info, old moved points of direct factor in grps
		news,        # record entry of info, new moved points of direct factor,
		             # i.e. the moved points of the copies in the direct product
		perms,       # record entry of info, permutations, such that the conjugate group
		             # of direct factor group in grps equals the copy in the direct product
		info;        # record for the DirectProductInfo of Y.

	# Initialize the variables.
	grps := [];
	olds := [];
	news := [];
	perms := [];
	generators := [];

	# Generate the record entries of info.
	for G in list do
		mp := MovedPoints(G);
		Append(generators, GeneratorsOfGroup(G));
		Add(grps, G);
		Add(olds, mp);
		Add(news, mp);
		Add(perms, ());
	od;

	# Generate the direct product Y and add the DirectProductInfo info to Y.
	dirProduct := Group(generators);
	info := rec( groups := grps,
	             olds := olds,
	             news := news,
	             perms := perms,
	             embeddings := [],
	             projections := [] );
	SetDirectProductInfo(dirProduct, info);

	return dirProduct;
end);

InstallGlobalFunction(WreathProductWithoutRenaming,
function(baseFactor, topGroup, perms)
	local
		nrCopiesBaseFactor,  # number of copies of baseFactor in basegroup
		topGroupGens,        # generators of topGroup
		baseFactorGens,      # generators of baseFactorGens
		img,                 # list of images which represent the action of top group on base group
		indexTopGen,         # loop variable, integer representing some generator of topGroup
		topGen,              # some generator of topGroupGens
		indexBaseFactor,     # loop variable, integer representing the i-th factor in base group
		baseFactorGen,       # loop variable, some generator of i-th factor in base group
		baseGens,            # generators of base group of wreath product
		baseGroup,           # base group generated by baseGens
		maps,                # list of maps which represent the action of top group on base group
		hgens,               # generators of top group in wreath product induced by maps
		W,                   # wreath product of baseFactor and topGroup
		info;                # wreath product info of W

	if not IsPermGroup(baseFactor) then
		ErrorNoReturn("the first argument must be a permutation group\n");
	fi;
	if not IsPermGroup(topGroup) then
		ErrorNoReturn("the second argument must be a permutation group\n");
	fi;
	if Length(perms) < LargestMovedPoint(topGroup) then
		ErrorNoReturn("the third argument must have at least length equal to the largest moved point of the topGroup");
	fi;
	if not IsDuplicateFree(Concatenation(List(perms, p -> List(MovedPoints(baseFactor),x -> x^p)))) then
		ErrorNoReturn("The images of baseFactor of the passed permutations are not pairwise disjoint\n");
	fi;

	nrCopiesBaseFactor := Length(perms);
	topGroupGens := GeneratorsOfGroup(topGroup);
	baseFactorGens := GeneratorsOfGroup(baseFactor);
	img := [];
	for indexTopGen in [1..Length(topGroupGens)] do
		Add(img, []);
		topGen := topGroupGens[indexTopGen];
		for indexBaseFactor in [1..nrCopiesBaseFactor] do
			for baseFactorGen in baseFactorGens do
				Add(img[indexTopGen], baseFactorGen^perms[indexBaseFactor^(topGen)]);
			od;
		od;
	od;
	baseGens := Concatenation( List([1..nrCopiesBaseFactor], i->List(baseFactorGens, g -> g^perms[i])) );
	baseGroup := Group(baseGens);
	maps := List([1..Length(topGroupGens)], x -> GroupHomomorphismByImagesNC(baseGroup, baseGroup, baseGens, img[x]) );
	hgens := List(maps, ConjugatorOfConjugatorIsomorphism);
	W := Group(Concatenation(baseGens, hgens));

	info := rec(
		I := topGroup,
		alpha := IdentityMapping( topGroup ),
		base := baseGroup,
		basegens := baseGens,
		components := List([1..nrCopiesBaseFactor], i -> List(MovedPoints(baseFactor), x -> x^perms[i])),
		degI := nrCopiesBaseFactor,
		embeddingType := NewType(
			GeneralMappingsFamily(PermutationsFamily,PermutationsFamily),
			IsEmbeddingImprimitiveWreathProductPermGroup),
		embeddings := [],
		groups := [baseFactor, topGroup],
		hgens := hgens,
		permimpr := true,
		perms := perms
	);
	SetWreathProductInfo(W, info);
	return W;
end);

InstallGlobalFunction(_SchreierTreeTrace,
function(G, a, b)
	local
		T,          # Schreier tree vector
		basePoint,  # base point in T
		g,          # element in G s.t. a^g = c
		h,          # element in G s.t. b^h = c
		x,          # loop variable, point
		t;          # loop variable, element in G
	T := StabChain(G).transversal;
	basePoint := StabChain(G).orbit[1];
	g := ();
	h := ();
	x := a;
	while x <> basePoint do
		t := T[x];
		x := x^t;
		g := g * t;
	od;
	x := b;
	while x <> basePoint do
		t := T[x];
		x := x^t;
		h := h * t;
	od;
	return g * h^(-1);
end);

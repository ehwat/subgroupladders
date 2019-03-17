#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# Declarations
#

#! @Description
#! Given a permutation group <A>G</A>, this will compute a subgroup ladder
#! from <A>G</A> up to the symmetric group on the set of moved points of <A>G</A>
#! If the optional third argument <A>n</A>is given, the ladder will be constructed up <M>S_n</M>.
#! The optional second argument determines whether this function uses `AscendingChain`
#! calls to find additional intermediate subgroup when the index may be large.
#!
#! This functions embeds <A>G</A> first into the direct product of the induced
#! permutation groups on the orbits, possible refined using `AscendingChain`. 
#! Then ladders for each of the direct factors
#! are constructed and put together yielding a letter up to the Young subgroup
#! corresponding to the orbits. This then is embedded into the wanted parent
#! symmetric group using Schmalz's ladder, see `SubgroupLadderForYoungSubgroup`.
#! If the transitive constituents are primitive, they will be embedded into
#! the symmetric group on the orbit directly or using `AscendingChain`, depending on
#! wether the `refine` option was used. For more details on the ladder constructed 
#! for imprimitive transitive constituents, see the documentation of
#! `SubgroupLadderForImprimitive`.
#! 
#! @InsertChunk exampleSubgroupLadder
#! @Returns A subgroup ladder from <A>G</A> to the wanted symmetric group.
#! The output is a list of records with a `Group` and a `LastDirection` field.
#! The `LastDirection` entry is set to 1, if the last step in the ladder was an up-step,
#! to -1, if the last step was a down-step and to 0 for the first entry.
#! @Arguments G [,refine] [,n]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadder");

#! @Description
#! This is an internal function called by `SubgroupLadder` to validate the input.
#! @Returns nothing if the input is correct, otherwise it `ErrorNoReturn`s.
#! @Arguments G [,refine] [,n]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderCheckInput");

#! @Description
#! This method is called when the index may be critical high in a ladder, whereas G is a subgroup of H.
#! @Returns A subgroup ladder (in fact an ascending chain) from H to G. If `refine` is true, this is established with `AscendingChain`, otherwise this is the "trivial" chain.
#! @Arguments G, H, refine
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderRefineStep");

#! @Description
#! Given a Young group <A>G</A>, this will compute a subgroup ladder
#! from <A>G</A> up to the symmetric group of degree <A>n</A>.
#! If <A>n</A> is given, it cannot be smaller than the largest moved point of <A>G</A> 
#! and the symmetric group is the canonical one acting on {1,…,n}.
#! If the second argument is ommited, <A>n</A> will be the number of moved points of <A>G</A>
#! and the symmetric group of degree <A>n</A> will act on the moved points of <A>G</A>.
#! We can guarantee that all
#! the indices are at most the degree <M>n</M> of the permutation group.
#! Details on the ladder can be found in <Cite Key="MR1056150" Where="Satz 3.1.1"/>.
#! @Returns A subgroup ladder from <A>G</A> to the wanted symmetric group.
#! The output is a list of records with a `Group` and a `LastDirection` field.
#! The `LastDirection` entry is set to 1, if the last step in the ladder was an up-step,
#! to -1, if the last step was a down-step and to 0 for the first entry.
#! @Arguments G, [n]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderForYoungGroup");

#! @Description
#! This internal function is called by `SubgroupLadder` with <A>G</A>
#! Direct product of transitive permutation groups with disjoint moved points.
#! The argument <A>n</A> is the degree of the target symmetric group <M>S_n</M>.
#! If omitted, the moved points will be used. The `refine` option may result in further
#! `AscendingChain` calls in order to decrease indices in the ladder.
#! 
#! The function constructs a ladder for every direct factor using 
#! `SubgroupLadderForTransitive`.
#! By concatenation of the ladders we construct a ladder on the whole group up
#! the Young group corresponding to the orbits. Then `SubgroupLadderForYoungGroup`
#! is called.
#! @Returns A subgroup ladder from <A>G</A> to the wanted symmetric group.
#! The output is a list of records with a `Group` and a `LastDirection` field.
#! The `LastDirection` entry is set to 1, if the last step in the ladder was an up-step,
#! to -1, if the last step was a down-step and to 0 for the first entry.
#! @Arguments G [,refine] [,n]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderForDirectProductOfTransitiveGroups");

#! @Description
#! Let <A>G</A> be a transitive permutaten group.
#! This checks whether the group is primitive or imprimitive and constructs the ladder.
#! by directly embedding or `SubgroupLadderForImprimitive` respectively
#! In the first case, the embedding will be refined with `AscendingChain` 
#! if the second argument is true.
#! @Returns A subgroup ladder from <A>G</A> to the symmetric group on the moved points
#! The output is a list of records with a `Group` and a `LastDirection` field.
#! The `LastDirection` entry is set to 1, if the last step in the ladder was an up-step,
#! to -1, if the last step was a down-step and to 0 for the first entry.
#! @Arguments G [,refine]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderForTransitive");

#! @Description
#! First embed G into the smallest canonical wreath product W containg G.
#! Then construct ladder from top group of W into the trivial group.
#! Use this ladder to construct a dual ladder on the wreath product into the base group.
#! After that construct a ladder from base group into the parent symmetric group.
#! @Returns
#! @Arguments G [,refine] [,n]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderForImprimitive");

#! @Description
#! Check all block systems of G and construct the smallest canonical wreath product containing G.
#! For a block system B_1,...,B_k, G induces a permutation group on B, denoted by G/B, and the canonical wreath product is 
#! Stab_G(B_1) ~ G/B =~ Stab_G(B_1) x ... x Stab_G(B_k) semidirect product with G/B.
#! @Returns
#! @Arguments G
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "WreathProductSupergroupOfImprimitive");

#! @Description
#! Given a partial partition <A>part</A> <M>= (p_1,…,p_k)</M>, this will compute
#! the Young subgroup corresponding to this partition.
#! Every <M>p_i</M> is a list of positive integers such that the union of the <M>p_i</M> is disjoint.
#! The Young subgroup equals the internal direct product of the symmetric groups on the p_i
#! @Returns a group
#! @Arguments part
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "YoungGroupFromPartition" );

#! @Description
#! Like the above, but does not tests whether the argument is a list of disjoint lists.
#! @Returns a group
#! @Arguments part
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "YoungGroupFromPartitionNC" );

#! @Description
#! Constructs a direct product of a list <A>list</A> of permutation groups
#! with pairwise disjoint moved points such that all embeddings are canonical.
#! @Returns the direct product P.
#! @Arguments list
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "DirectProductPermGroupsWithoutRenaming");

#! @Description
#! Like the above, but does not tests whether the argument is a list of permutation
#! groups with pairwise disjoint moved points.
#! @Returns the direct product P.
#! @Arguments list
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "DirectProductPermGroupsWithoutRenamingNC");

#! @Description
#! Construct a wreath product, such that the basegroup is the direct product of the conjugate groups of basefactors by using perms
#! The top group acts on the basegroup by permuting the factors and conjugating with the corresponding perms
#! @Returns
#! @Arguments basefactor, topgroup, perms
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "WreathProductWithoutRenaming");

#! @Description
#! Use the Schreier tree in the stabilizer chain of G to trace some element g in G s.t. a^g=b
#! @Returns
#! @Arguments G, a, b
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SchreierTreeTrace_");

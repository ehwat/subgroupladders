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
#! This method is called when the index may be critical high in a ladder, whereas <A>G</A> is a subgroup of <A>H</A>.
#! @Returns A subgroup ladder (in fact an ascending chain) from <A>H</A> to <A>G</A>. If `refine` is true, this is established with `AscendingChain`, otherwise this is the "trivial" chain.
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
#! Let <A>G</A> be a transitive permutaten group.
#! This checks whether the group is primitive or imprimitive and constructs the ladder
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
#! Let <A>G</A> be an imprimitive permutation group.
#! First this function embeds <A>G</A> into the smallest canonical wreath product <M>W</M> containg <M>G</M>.
#! Then construct ladder from top group of <M>W</M> into the trivial group.
#! Using this ladder, we can construct a ladder from the wreath product to its base group
#! by iteratively replacing the top group with the groups in the other ladder.
#! After that construct a ladder from base group to the parent symmetric group. 
#! The output is the concatenation of these ladders.
#! @Returns A subgroup ladder from <A>G</A> to the symmetric group on the moved points
#! The output is a list of records with a `Group` and a `LastDirection` field.
#! The `LastDirection` entry is set to 1, if the last step in the ladder was an up-step,
#! to -1, if the last step was a down-step and to 0 for the first entry.
#! @Arguments G [,refine]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderForImprimitive");

#! @Description
#! Let <A>G</A> be an imprimitive permutation group.
#! For every block system of <A>G</A> this constructs the smallest canonical
#! wreath product containing <A>G</A> corresponding to this block system,
#! then this returns the smallest one in total.
#! For a block system <M>B = \{B_1,...,B_k\}</M>, <A>G</A> induces a permutation
#! group on <M>B</M>, denoted by <M>G/B</M>, and the canonical wreath product is
#! <Display><Alt Only="LaTeX">
#! \operatorname{Stab}_G(B_1) \wr G/B \cong \Big(\operatorname{Stab}_G(B_1) \times \cdots \times \operatorname{Stab}_G(B_k)\Big) \rtimes G/B.
#! </Alt><Alt Not="LaTeX">
#! Stab_G(B_1) Wr G/B ~= (Stab_G(B_1) x ... x Stab_G(B_k)) x| G/B.
#! </Alt></Display> 
#! @Returns the smallest nontrivial canonical wreath product containing <A>G</A>
#! @Arguments G
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "WreathProductSupergroupOfImprimitive");

#! @Description
#! Given a partial partition <A>part</A> <M>= (p_1,…,p_k)</M>, this will compute
#! the Young subgroup corresponding to this partition.
#! Every <M>p_i</M> is a list of positive integers such that the union of the <M>p_i</M> is disjoint.
#! The Young subgroup equals the internal direct product of the symmetric groups on the p_i
#! @Returns the young subgroup <M>Sym(p_1) x ... x Sym(p_k)</M>.
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

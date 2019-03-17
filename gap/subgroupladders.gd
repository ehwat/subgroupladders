#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# Declarations
#

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
#! Given a Young group <A>G</A>, this will compute a subgroup ladder
#! from <A>G</A> up to the symmetric group of degree <A>n</A>.
#! If <A>n</A> is given, it cannot be smaller than the largest moved point of <A>G</A> 
#! and the symmetric group is the canonical one acting on {1,…,n}.
#! If the second argument is ommited, <A>n</A> will be the number of moved points of <A>G</A>
#! and the symmetric group of degree <A>n</A> will act on the moved points of <A>G</A>.
#! A subgroup ladder is series of subgroups <M>G = H_0,…,H_k = S_n</M> of the
#! symmetric group such that for every <M>1 \leq i \leq k</M>, <M>H_i</M> is a
#! subgroup of <M>H_{{i-1}}</M> or <M>H_{{i-1}}</M> is a subgroup of <M>H_i</M>.
#! We can guarantee that all
#! the indices are at most the degree <M>n</M> of the permutation group.
#! @Returns a list of groups
#! @Arguments G, [n]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderForYoungGroup");

#! @Description
#! Given a permutation group <A>G</A>, this will compute a subgroup ladder
#! from <A>G</A> up to the symmetric group of degree <A>n</A>.
#! If the second argument is ommited, the largest moved point of <A>G</A> will be
#! used.
#! A subgroup ladder is series of subgroups <M>G = H_0,…,H_k = S_n</M> of the
#! symmetric group such that for every <M>1 \leq i \leq k</M>, <M>H_i</M> is a
#! subgroup of <M>H_{{i-1}}</M> or <M>H_{{i-1}}</M> is a subgroup of <M>H_i</M>.
#! This functions embeds <A>G</A> first into the direct product of the induced
#! permutation groups on the orbits. This then is embedded into the young group 
#! corresponding to the orbits by iteratively replacing the restrictions
#! of <A>G</A> on each orbit first with  the wreath product of 
#! symmetric groups corresponding to a minimal block system of
#! that transitive constituent and then with the symmetric group on that orbit.
#! Up to this step, the indices in the subgroup chain can be preetty high.
#! This chain is followed by a subgroup ladder from the young subgroup to 
#! <M>S_(n)</M> is constructed with SubgroupLadderForYoungGroup, which produceds a
#! subgroup ladder with indiceds at most <M>n</M>.
#! @Returns a list of groups
#! @Arguments G [,refine] [,n]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadder");

#! @Description
#! @Returns
#! @Arguments
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderCheckInput");

#! @Description
#! This method is called when the index may be critical high in a ladder, whereas G is a subgroup of H
#! If refine is true, try to construct an ascending chain from G into H.
#! @Returns
#! @Arguments G, H, refine
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadderRefineStep");

#! @Description
#! Check whether the group is primitive or imprimitive and construct the ladder.
#! @Returns
#! @Arguments
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

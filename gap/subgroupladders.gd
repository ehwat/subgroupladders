#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# Declarations
#

#! @Description
#! Given a list of lists <A>part</A> of positive integers, this will compute
#! the Young subgroup corresponding to this partition.
#! @Returns a group
#! @Arguments part
#! @ChapterInfo subgroupladders, subgroupladders

DeclareGlobalFunction( "YoungGroupFromPartition" );
#! @Description
#! Given a list of lists <A>part</A> of positive integers, this will compute
#! the Young subgroup corresponding to this partition.
#! This function does not check whether the supplied lists are actually disjoint.
#! @Returns a group
#! @Arguments part
#! @ChapterInfo subgroupladders, subgroupladders

DeclareGlobalFunction( "YoungGroupFromPartitionNC" );
#! @Description
#! Given a young group <A>G</A>, this will compute a subgroup ladder
#! from <A>G</A> up to the symmetric group of degree <A>n</A>.
#! If the second argument is ommited, the largest moved point of <A>G</A> will be
#! used.
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
#! @Arguments G, [n]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "SubgroupLadder");

#! @Description
#! Given a transitive permutation group <A>G</A> on <A>Omega</A>, 
#! This function computes the wreath product corresponding to a minimal 
#! block system of <A>G</A> as a supergroup of the permutation group <A>G</A>.
#! @Returns the Wreath Product 
#! @Arguments G, [Omega]
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "ImprimitiveIntoWreathProduct");

#! @Description
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "WreathProductOnBlocks");

#! @Description
#! Constructs a direct product of a list <A>list</A> of permutation groups
#! with pairwise disjoint moved points such that all embeddings are canonical,
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


DeclareGlobalFunction( "SubgroupLadderForImprimitive");

DeclareGlobalFunction( "SubgroupLadderRefineStep");

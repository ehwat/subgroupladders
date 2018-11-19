#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# Declarations
#

#! @Description
#! Given a list of lists <A>part</A> of positive integers, this will compute 
#! the Young subgroup corresponding to this partition.
#! This function does not check whether the supplied lists are actually disjoint. 
#! @Returns a group
#! @Arguments part
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "YoungGroupFromPartition" );
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
DeclareGlobalFunction( "SubgroupLadder");

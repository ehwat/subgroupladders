#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# Declarations
#

#! @Chapter subgroup-ladders
#! @Section subgroup-ladders

#! @Description
#! Given a list of lists <A>part</A> of positive integers, this will compute 
#! the Young #! subgroup corresponding to this partition.
#! @Returns a group
#! @Arguments part
DeclareGlobalFunction( "YoungGroupFromPartition" );
#! @Description
#! Given a permutation group <A>G</A>, this will compute a subgroup ladder
#! from <A>G</A> up to the parent symmetric group.
#! A subgroup ladder is series of subgroups <M>G = H_0,…,H_k = S_n</M> of the 
#! symmetric group such that for every <M>1 \leq i \leq k</M>, <M>H_i</M> is a 
#! subgroup of <M>H_{{i-1}}</M> or <M>H_{{i-1}}</M> is a subgroup of <M>H_i</M>.
#! If <A>G</A> is a Young subgroup of <M>S_n</M>, we can guarantee that all 
#! the indices are at most the degree <M>n</M> of the permutation group. 
#! Otherwise, we will at first embed <A>G</A> into the Young subgroup 
#! corresponding to the orbits of <A>G</A>. 
#! At this step, the index may be larger than the degree.
#! @Returns a list of groups
#! @Arguments G
DeclareGlobalFunction( "SubgroupLadder");

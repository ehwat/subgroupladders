#! @Description
#! Given a group <A>G</A>, this computes the partial table of marks induced by the subgroups of <A>G</A> in <A>list</A>.
#! @Returns matrix
#! @Arguments list, G
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "TableOfMarksPartial" );

#! @Description
#! Internal function called by TableOfMarksPartial, which computes recursively one entry of the table of marks.
#! Let <M>G</M> be the parent group of the table of marks, i.e.
#! <A>U</A>,<M>H \leq G</M>, where <A>chain</A> is an ascending subgroup chain of the form 
#! <M>C \leq \cdots \leq B \leq A \leq H</M>.
#! Let Gamma be the fixed points of <M>R[G : H]</M> in <A>U</A>, say <M>Hg_1, \ldots, Hg_k</M>.
#! Let <M>R[H : A]</M> be <M>Ah_1, ..., Ah_l</M>.
#! Then Omega is the set of the split cosets of Gamma, i.e. 
#! <M>Ah_1g_1, \ldots, Ah_lg_1, \ldots, Ah_1g_k, \ldots, Ah_lg_k</M>.
#! Return the number of fixed points of <M>R[G : C]</M> in <A>U</A>.
#! @Returns integer
#! @Arguments Omega, chain, U
#! @ChapterInfo subgroupladders, subgroupladders
DeclareGlobalFunction( "TableOfMarksEntryWithChain" );

#! @Description
#! Given a group <A>G</A> with an action <A>act</A> on an object <A>obj</A>,
#! this operation returns a subset of <A>obj</A> that is pointwise fixed by <A>G</A>.
#! @Returns subset of <A>obj</A>
#! @Arguments obj, G, act
#! @ChapterInfo subgroupladders, subgroupladders
DeclareOperation("FixedPoints", [IsObject, IsGroup, IsFunction]);

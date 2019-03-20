#! @Description
#! Given a group <A>G</A>, this computes the partial table of marks induced by the subgroups of <A>G</A> in <A>list</A>.
#! It will test the supplied subgroups for conjugacy. Passing `false` as the optional third argument <A>skipConjTest</A> will skip this test.
#! @Returns the desired section of the table of marks as a matrix.
#! @Arguments list, G, [sikpConjTest]
#! @ChapterInfo subgroupladders, tom
DeclareGlobalFunction( "TableOfMarksPartial" );

#! @Description
#! Internal function called by TableOfMarksPartial, which computes recursively one entry of the table of marks.
#! Let <M>G</M> be the parent group of the table of marks, i.e.
#! <M>U,V \leq G</M>, where chain is an ascending subgroup chain of the form <M>V \leq \ldots \leq B \leq A \leq \ldots \leq G</M>.
#! By iteration we compute the fixed points of <M>R[G : V]</M> with resprect to the action by right multiplication of <M>U</M>.
#! @Returns integer
#! @Arguments G, chain, U
#! @ChapterInfo subgroupladders, tom
DeclareGlobalFunction( "TableOfMarksEntryWithChain" );

DeclareOperation("_FixedPoints", [IsObject, IsGroup, IsFunction]);

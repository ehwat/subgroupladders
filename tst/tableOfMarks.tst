gap> G := SymmetricGroup(5);;

#
gap> C := List(ConjugacyClassesSubgroups(G), Representative);;

#
gap> TP := TableOfMarksPartial(C, G);;

#
gap> T := TableOfMarks(G);;

#
gap> TP = MatTom(T);
true
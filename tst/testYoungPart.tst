gap> P := [[1,2,3],[10,11,12],[20]];
[ [ 1, 2, 3 ], [ 10, 11, 12 ], [ 20 ] ]
gap> Y := YoungGroupFromPartition(P);
Group([ (1,2,3), (1,2), (10,11,12), (10,11) ])
gap> DirectProductInfo(Y);
rec( embeddings := [  ], 
  groups := [ Sym( [ 1 .. 3 ] ), Sym( [ 10 .. 12 ] ), Group(()) ], 
  news := [ [ 1 .. 3 ], [ 10 .. 12 ], [  ] ], 
  olds := [ [ 1 .. 3 ], [ 10 .. 12 ], [  ] ], perms := [ (), (), () ], 
  projections := [  ] )
gap> Image(Embedding(Y, 1));
Group([ (1,2,3), (1,2) ])
gap> Image(Embedding(Y, 2));
Group([ (10,11,12), (10,11) ])
gap> Image(Embedding(Y, 3));
Group(())
gap> Image(Projection(Y, 1));
Sym( [ 1 .. 3 ] )
gap> Image(Projection(Y, 2));
Sym( [ 10 .. 12 ] )
gap> Image(Projection(Y, 3));
Group(())
gap> DirectProductInfo(Y);
rec( 
  embeddings := [ 1st embedding into Group([ (1,2,3), (1,2), (10,11,12), (10,
       11) ]), 2nd embedding into Group([ (1,2,3), (1,2), (10,11,12), (10,
       11) ]), 3rd embedding into Group([ (1,2,3), (1,2), (10,11,12), (10,
       11) ]) ], 
  groups := [ Sym( [ 1 .. 3 ] ), Sym( [ 10 .. 12 ] ), Group(()) ], 
  news := [ [ 1 .. 3 ], [ 10 .. 12 ], [  ] ], 
  olds := [ [ 1 .. 3 ], [ 10 .. 12 ], [  ] ], perms := [ (), (), () ], 
  projections := [ 1st projection of Group([ (1,2,3), (1,2), (10,11,12), (10,
       11) ]), 2nd projection of Group([ (1,2,3), (1,2), (10,11,12), (10,
       11) ]), 3rd projection of Group([ (1,2,3), (1,2), (10,11,12), (10,
       11) ]) ] )
gap> 
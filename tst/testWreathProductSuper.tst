gap> G := DihedralGroup(IsPermGroup,20);;
gap> IsTransitive(G);
true
gap> W := WreathProductSupergroupOfImprimitive(G);
Group([ (3,9)(5,7), (1,3,5,7,9), (4,10)(6,8), (2,4,6,8,10), (1,2)(3,4)(5,6)
(7,8)(9,10) ])
gap> IsSubgroup(W,G);
true
gap> I := WreathProductInfo(W);
rec( I := Group([ (1,2) ]), alpha := IdentityMapping( Group([ (1,2) ]) ), 
  base := Group([ (3,9)(5,7), (1,3,5,7,9), (4,10)(6,8), (2,4,6,8,10) ]), 
  basegens := [ (3,9)(5,7), (1,3,5,7,9), (4,10)(6,8), (2,4,6,8,10) ], 
  components := [ [ 1, 3, 5, 7, 9 ], [ 2, 4, 6, 8, 10 ] ], degI := 2, 
  embeddingType := <Type: (GeneralMappingsFamily, [ IsComponentObjectRep, IsAt\
tributeStoringRep, CanEasilyCompareElements, ... ]), data: fail,>, 
  embeddings := [  ], 
  groups := [ Group([ (3,9)(5,7), (1,3,5,7,9) ]), Group([ (1,2) ]) ], 
  hgens := [ (1,2)(3,4)(5,6)(7,8)(9,10) ], permimpr := true, 
  perms := [ (), (1,2,3,4,5,6,7,8,9,10) ] )
gap> Wr := WreathProduct(I.groups[1],I.groups[2]);
Group([ (2,5)(3,4), (1,2,3,4,5), (7,10)(8,9), (6,7,8,9,10), (1,6)(2,7)(3,8)
(4,9)(5,10) ])
gap> IsomorphismGroups(Wr,W);
[ (2,5)(3,4), (1,2,3,4,5), (7,10)(8,9), (6,7,8,9,10), 
  (1,6)(2,7)(3,8)(4,9)(5,10) ] -> [ (3,9)(5,7), (1,3,5,7,9), (4,10)(6,8), 
  (2,4,6,8,10), (1,2)(3,4)(5,6)(7,8)(9,10) ]
gap> Image(Embedding(W,1));
Group([ (3,9)(5,7), (1,3,5,7,9) ])
gap> Image(Embedding(W,2));
Group([ (4,10)(6,8), (2,4,6,8,10) ])
gap> Image(Embedding(W,3));
Group([ (1,2)(3,4)(5,6)(7,8)(9,10) ])
gap> Image(Embedding(W,1))^I.perms[2] = Image(Embedding(W,2));
true
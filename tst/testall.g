#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "subgroupladders" );

TestDirectory(DirectoriesPackageLibrary( "subgroupladders", "tst" ), rec(exitGAP := true));
FORCE_QUIT_GAP(1);

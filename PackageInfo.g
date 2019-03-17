#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "subgroupladders",
Subtitle := "This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.",
Version := "0.1",
Date := "08/11/2018", # dd/mm/yyyy format

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Ulli",
    LastName := "Kehrle",
    #WWWHome := TODO,
    Email := "ulli.kehrle@rwth-aachen.de",
    #PostalAddress := TODO,
    #Place := TODO,
    #Institution := TODO,
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Friedrich",
    LastName := "Rober",
    #WWWHome := TODO,
    Email := "friedrich.rober@rwth-aachen.de",
    #PostalAddress := TODO,
    #Place := TODO,
    #Institution := TODO,
  ),
],

#SourceRepository := rec( Type := "TODO", URL := "URL" ),
#IssueTrackerURL := "TODO",
PackageWWWHome := "https://github.com/ehwat/subgroupladders/",
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL     := Concatenation( ~.PackageWWWHome,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "subgroupladders",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.",
),

Dependencies := rec(
  GAP := ">= 4.9",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));



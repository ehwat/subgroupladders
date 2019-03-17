#
# subgroupladders: This package provides an algorithm that computes a subgroup ladder from a permutation group up to the parent symmetric group.
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", "2018.02.14") then
    Error("AutoDoc version 2018.02.14 or newer is required.");
fi;

AutoDoc( 
	rec( scaffold :=
		rec( gapdoc_latex_options :=
			rec(
				EarlyExtraPreamble := "\\usepackage{tikz}\\usetikzlibrary{graphs}\\usepackage{amsmath}",
				Maintitlesize := "\\fontsize{36}{38}\\selectfont"
			)
		),
		autodoc := true
	)
);
QUIT;

The file 
	basics.h
	mapcoder.c
	mapcoder.h
together provide routine to encode/decode mapcodes (see www.mapcode.com for details).
Note that this version may be restricted to a particular area of the Earth.
In that case, basics.h will state a version number of the for 
	#define mapcode_cversion "1.2xxx"
where "xxx" states the geographical limitation.


version history
---------------
1.25 initial release to the public domain
1.26 added alias OD ("Odisha") for indian state OR ("Orissa")
1.27 improved (faster) implementation of the function isInArea
1.28 bug fix for the needless generation of 7-letter alternatives to short mapcodes in large states in India
1.29 also generate country-wide alternative mapcodes for states
1.30 updated the documentation and extended it with examples and suggestions


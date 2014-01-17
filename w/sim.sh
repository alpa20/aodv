#!/bin/sh
#
#Script to test the simulation
#
#
# tab=(10 20 30 40 50);
tab=(3 4 5 6 7);

lentab=${#tab[*]};
i=0;

while [ $i -lt $lentab ]; do
	echo "Nombre de noeuds =  ------ ${tab[$i]} ------ " ;
	ns ./w.tcl ${tab[$i]} 5 1.0;
	awk -v nn=${tab[$i]} -f pdr.awk wireless-simple-mac.tr >> res
	rm wireless-simple-mac.tr
	rm wireless-simple-mac.nam
	let i++
done
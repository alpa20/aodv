#!/bin/sh
#
#Script to test the simulation
#
#
#tab=(10 20 30 40 50);
tab=(5 10 15 20 25);

lentab=${#tab[*]};
i=0;

while [ $i -lt $lentab ]; do
	echo "Nombre de noeuds =  ${tab[$i]} ............................................ " ;
	ns ./w.tcl ${tab[$i]} 1;
	awk -v nn=${tab[$i]} -f t.awk wireless-simple-mac.tr
	rm wireless-simple-mac.tr
	rm wireless-simple-mac.nam
	let i++
done
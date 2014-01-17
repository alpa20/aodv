#!/bin/sh
#
#Script to test the simulation
#
#
tabc=(2 3 4 5 6);
tabs=(1.0 2.0 3.0 4.0 5.0);

lentabc=${#tabc[*]};
lentabs=${#tabs[*]};
i=0;

while [ $i -lt $lentabc ]; do
	echo "Nombre de connexions =  ************ ${tabc[$i]} ************ " ;
		j=0;
		while [ $j -lt $lentabs ]; do
			echo "Le seed courant =  ------ ${tabc[$j]} ------" ;
			ns ./w.tcl 30 ${tabc[$i]} ${tabs[$j]};
			awk -v nn=${tab[$i]} -f pdr.awk wireless-simple-mac.tr >> res
			rm wireless-simple-mac.tr
			rm wireless-simple-mac.nam
			let j++
		done
	let i++	
done
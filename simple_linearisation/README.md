TODO - sort and organize things

partition.mod -- the original model ("linéarisation simple")
partition_v2.mod -- an optimzed version of this model

glpsol --data inst9_1_comp.dat --model partition.mod
glpsol --data inst9_1_comp.dat --model partition_v2.mod

glpsol --data inst16_1_comp.dat --model partition.mod
glpsol --data inst16_1_comp.dat --model partition_v2.mod


partition_v2.mod on 16*16 graph
	Time used:   51.2 secs
	Memory used: 12.3 Mb (12914503 bytes)
	Partitionnement sous contrainte de capacité
	Traffic inter total : 98200
	Partition 1 : traffic in/out 83052
	  noeud 1
	  noeud 2
	  noeud 3
	  noeud 7
	  noeud 8
	  noeud 9
	  noeud 12
	  noeud 13
	  noeud 14
	Partition 2 : traffic in/out 0
	Partition 3 : traffic in/out 0
	Partition 4 : traffic in/out 27506
	  noeud 4
	  noeud 11
	Partition 5 : traffic in/out 94942
	  noeud 5
	  noeud 10
	  noeud 15
	Partition 6 : traffic in/out 90927
	  noeud 6
	  noeud 16

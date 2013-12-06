# Partition with capacity constraints -> boolean quadratic problem

# maximum allowed traffic by partition
param MaxPartitionTraffic;
# number of partitions, nodes
param N;

# traffic on edge
param Traffic{1..N, 1..N};
# z_ijp = x_ip * x_jp: true if node i and node j in p
var edge_in_partition{1..N, 1..N, 1..N}, binary;
# x_ip: true if node i in partition p
var node_in_partition{1..N, 1..N}, binary;

minimize InterPartitionTraffic:
    sum{i in 1..N, j in 1..N}
        (1/2 * Traffic[i,j] 
        - 1/2 * Traffic[i,j] * sum{p in 1..N} edge_in_partition[i,j,p]);
s.t.

ConstraintMembership{i in 1..N}:
    sum{p in 1..N} node_in_partition[i,p] = 1;

ConstraintCapacity{p in 1..N}:
    (sum{i in 1..N, j in 1..N}
        (Traffic[i,j] * node_in_partition[i,p]))
    - 1/2 * (sum{i in 1..N, j in 1..N}
        (Traffic[i,j] * edge_in_partition[i,j,p]))
    <=
    MaxPartitionTraffic; 

ConstraintLinearization1{i in 1..N, j in 1..N, p in 1..N}:
    edge_in_partition[i,j,p] <= node_in_partition[i,p];

ConstraintLinearization2{i in 1..N, j in 1..N, p in 1..N}:
    edge_in_partition[i,j,p] <= node_in_partition[j,p];

ConstraintLinearization3{i in 1..N, j in 1..N, p in 1..N}:
    1
    - node_in_partition[i,p]
    - node_in_partition[j,p]
    + edge_in_partition[i,j,p] >= 0;

ConstraintLinearization4{i in 1..N, j in 1..N, p in 1..N}:
    edge_in_partition[i,j,p] >= 0;

ConstraintSymmetryBreak:
    node_in_partition[1,1] = 1;

solve;

printf "Partitionnement sous contrainte de capacité\n";
printf "Traffic inter total : %i\n",
    sum{i in 1..N, j in 1..N}
        (1/2 * Traffic[i,j] 
         - 1/2 * Traffic[i,j] * sum{p in 1..N} edge_in_partition[i,j,p]);
printf{p in 1..N, i in 1..N}
    "Partition %i noeud %i : %i\n", p, i, node_in_partition[i,p];

end;

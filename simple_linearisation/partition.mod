# Partition with capacity constraints -> boolean quadratic problem

param MaxPartitionTraffic;  # maximum allowed traffic by partition
param N;                    # number of partitions, nodes
param Traffic{1..N, 1..N}, default 0;  # traffic on edge

var node_in_partition{1..N, 1..N}, binary;       # x_ip: true if node i in partition p
var edge_in_partition{1..N, 1..N, 1..N}, binary; # z_ijp = x_ip * x_jp: true if node i and node j in p

minimize InterPartitionTraffic: sum{i in 1..N, j in 1..N} (1/2 * Traffic[i,j] - 1/2 * Traffic[i,j] * sum{p in 1..N} edge_in_partition[i,j,p]);

s.t.

ConstraintMembership{i in 1..N}: sum{p in 1..N} node_in_partition[i,p] = 1;
ConstraintCapacity{p in 1..N}:
    (sum{i in 1..N, j in 1..N} (Traffic[i,j] * node_in_partition[i,p])) - 1/2 * (sum{i in 1..N, j in 1..N} (Traffic[i,j] * edge_in_partition[i,j,p]))
    <= MaxPartitionTraffic;

ConstraintLinearization1{i in 1..N, j in 1..N, p in 1..N}: edge_in_partition[i,j,p] <= node_in_partition[i,p];
ConstraintLinearization2{i in 1..N, j in 1..N, p in 1..N}: edge_in_partition[i,j,p] <= node_in_partition[j,p];
ConstraintLinearization3{i in 1..N, j in 1..N, p in 1..N}: 1 - node_in_partition[i,p] - node_in_partition[j,p] + edge_in_partition[i,j,p] >= 0;
ConstraintLinearization4{i in 1..N, j in 1..N, p in 1..N}: edge_in_partition[i,j,p] >= 0;

ConstraintSymmetry{i in 1..N, j in 1..N, p in 1..N}: edge_in_partition[i,j,p] = edge_in_partition[j,i,p];
ConstraintSymmetryBreak: node_in_partition[1,1] = 1;
ConstraintSymmetryBreak2{i in 1..N, p in 1..N: p>i}: node_in_partition[i,p] = 0;
#ConstraintSymmetryBreak3{p1 in 1..N, p2 in 1..N: p1<p2}: (sum{i in 1..N} node_in_partition[i,p1]) >=  (sum{i in 1..N} node_in_partition[i,p2]);

solve;

printf "Partitionnement sous contrainte de capacité\n";
printf "Traffic inter total : %i\n", sum{i in 1..N, j in 1..N} (1/2 * Traffic[i,j] - 1/2 * Traffic[i,j] * sum{p in 1..N} edge_in_partition[i,j,p]);
for {p in 1..N} {
    printf "Partition %i : traffic in/out %i\n",p,
        (
            sum{i in 1..N, j in 1..N} (Traffic[i,j] * node_in_partition[i,p])) 
            - 1/2 * (sum{i in 1..N, j in 1..N} (Traffic[i,j] * edge_in_partition[i,j,p])
        );
    printf{i in 1..N : node_in_partition[i,p]!=0} "  noeud %i\n", i;
}

end;

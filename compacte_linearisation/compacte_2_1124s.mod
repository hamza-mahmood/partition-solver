param T;
param N;
param t{1..N,1..N}, default 0; #i,j

var x{i in 1..N,p in 1..N : p<=i}, binary;
var s{i in 1..N,p in 1..N : p<=i};
var y{i in 1..N,p in 1..N : p<=i};
param l_max{i in 1..N} := (sum{j in 1..N} t[i,j]); #lambda max

maximize obj: sum{i in 1..N, p in 1..N : p<=i} s[i,p];

ConstraintInitiale{i in 1..N}: sum{p in 1..N : p<=i} x[i,p] = 1;

Constraint1{i in 1..N, p in 1..N : p<=i}: (sum{j in 1..N : i<j} t[i,j] * x[j,p]) = y[i,p] + s[i,p];
Constraint2{p in 1..N}: sum{i in 1..N : p<=i} (l_max[i] * x[i,p] - s[i,p]) <= T;

Inequalitie1a{i in 1..N, p in 1..N : p<=i}: s[i,p] >= 0;
Inequalitie1b{i in 1..N, p in 1..N : p<=i}: s[i,p] <= l_max[i] * x[i,p];
Inequalitie2a{i in 1..N, p in 1..N : p<=i}: y[i,p] >= 0; # s<= l <-> y = l - s
#Inequalitie2b{i in 1..N, p in 1..N : p<=i}: y[i,p] <= l_max[i] * (1 - x[i,p]);

#ConstraintSymmetryBreak: x[1,1] = 1;

solve;
printf "Partitionnement sous contrainte de capacité\n";
printf "Traffic inter total : %i\n", 0.5 * (sum{i in 1..N, j in 1..N} t[i,j]) - sum{i in 1..N, p in 1..N : p<=i} s[i,p];

for {p in 1..N} {
    printf "Partition %i : traffic in/out %i\n",p, sum{i in 1..N : p<=i} (l_max[i] * x[i,p] - s[i,p]);
    printf{i in 1..N : p<=i and x[i,p]!=0} "  noeud %i\n", i;
}
end;

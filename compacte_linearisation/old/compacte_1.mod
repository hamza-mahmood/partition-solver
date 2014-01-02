param T;
param N;
param t{1..N,1..N}, default 0; #i,j

var x{1..N, 1..N}, binary;
var s{1..N, 1..N};
var y{1..N, 1..N};
param l_max{i in 1..N, p in 1..N} := (sum{j in 1..N} t[i,j]); #lambda max

minimize obj: 0.5 * (sum{i in 1..N, j in 1..N} t[i,j]) - 0.5 * (sum{i in 1..N, p in 1..N} s[i,p]);

ConstraintInitiale{i in 1..N}: sum{p in 1..N} x[i,p] = 1;

Constraint1{i in 1..N, p in 1..N}: (sum{j in 1..N} t[i,j] * x[j,p]) = y[i,p] + s[i,p];
Constraint2{p in 1..N}: sum{i in 1..N} (l_max[i,p] * x[i,p] - 0.5 * s[i,p]) <= T;
#Constraint2{p in 1..N}: sum{i in 1..N} (y[i,p] + 0.5 * s[i,p]) <= T;

Inequalitie1a{i in 1..N, p in 1..N}: s[i,p] >= 0;
Inequalitie1b{i in 1..N, p in 1..N}: s[i,p] <= l_max[i,p] * x[i,p];
Inequalitie2a{i in 1..N, p in 1..N}: y[i,p] >= 0;
Inequalitie2b{i in 1..N, p in 1..N}: y[i,p] <= l_max[i,p] * (1 - x[i,p]);

ConstraintSymmetryBreak: x[1,1] = 1;
ConstraintSymmetryBreak2{i in 1..N, p in 1..N: p>i}: x[i,p] = 0;
#ConstraintSymmetryBreak3{p1 in 1..N, p2 in 1..N: p1<p2}: (sum{i in 1..N} x[i,p1]) >=  (sum{i in 1..N} x[i,p2]);

solve;
printf "Partitionnement sous contrainte de capacité avec contrainte 2bis en commentaire\n";
printf "Traffic inter total : %i\n", sum{i in 1..N, j in 1..N} (1/2 * t[i,j] - 1/2 * t[i,j] * sum{p in 1..N} x[i,p]*x[j,p]);

for {p in 1..N} {
    printf "Partition %i : traffic in/out %i\n",p, (sum{i in 1..N, j in 1..N} t[i,j]*x[i,p]) -0.5* (sum{i in 1..N, j in 1..N} x[i,p]*t[i,j]*x[j,p]);
    printf{i in 1..N : x[i,p]!=0} "  noeud %i\n", i;
}
end;

Reasoning:
1. The decision variables are the teams for each week. Each team is a set of 4 scientists. The domain of each team is the set of all scientists.
2. The constraint is that no two scientists work in the same team more than once. This can be encoded by ensuring that for each pair of scientists, they are in the same team at most once.
3. The objective function is to maximize the number of weeks. This is an optimization problem.
4. A potential simplification is to model the problem as a graph, where each vertex represents a scientist and each edge represents a team. Then the problem becomes finding the maximum number of edge-disjoint complete subgraphs of size 4.

MiniZinc model:
```minizinc
% Number of scientists
int: n = 32;

% Number of teams per week
int: t = n div 4;

% Maximum number of weeks
int: w = n*(n-1) div (2*t);

% Scientists are numbered from 1 to n
set of int: Scientists = 1..n;

% Weeks are numbered from 1 to w
set of int: Weeks = 1..w;

% Teams are numbered from 1 to t
set of int: Teams = 1..t;

% Decision variable: team[i,j,k] is the k-th scientist in the j-th team in the i-th week
array[Weeks, Teams, 1..4] of var Scientists: team;

% Constraint: no two scientists work in the same team more than once
constraint forall(i in Weeks, j in Teams)(
  alldifferent([team[i,j,k] | k in 1..4])
);

constraint forall(i in Weeks, k in 1..4)(
  alldifferent([team[i,j,k] | j in Teams])
);

constraint forall(s1, s2 in Scientists where s1 < s2)(
  sum(i in Weeks, j in Teams, k in 1..4)(bool2int(team[i,j,k] = s1 /\ exists(k2 in 1..4)(team[i,j,k2] = s2))) <= 1
);

% Objective: maximize the number of weeks
var int: num_weeks = max(i in Weeks)(bool2int(exists(j in Teams, k in 1..4)(team[i,j,k] > 0)));
solve maximize num_weeks;

% Output the schedule
output [ if fix(team[i,j,k]) > 0 then "Week " ++ show(i) ++ ", Team " ++ show(j) ++ ": Scientist " ++ show(fix(team[i,j,k])) ++ "\n" else "" endif | i in Weeks, j in Teams, k in 1..4 ];
```
This model assumes that the number of scientists is a multiple of 4. If this is not the case, additional constraints would be needed to handle the remaining scientists.
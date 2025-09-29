Reasoning:

1. The park is a square, so it has a side length of `n` (a decision variable with domain `1..max_n`, where `max_n` is a reasonable upper bound for the park size).

2. Each zone is a square with an integer side length. We can represent the zones as an array `zones[1..max_zones]` of decision variables with domain `1..n`. The number of zones `num_zones` is also a decision variable with domain `1..max_zones`.

3. Constraint: The sum of the squares of the zone sizes must be equal to the square of the park size (to cover the whole park).

4. Constraint: All zone sizes must be different (no two zones can have the same size).

5. Constraint: No group of zones larger than one may be arranged together to form a rectangular block. This is a bit tricky to encode directly, but we can simplify it by saying that no zone size can be a multiple of another zone size. This ensures that we can't arrange multiple zones of size `a` and `b` to form a block of size `a*b`.

6. This is an optimization problem with the objective of minimizing the unused area, which is the difference between the square of the park size and the sum of the squares of the zone sizes.

MiniZinc model:

```minizinc
% Maximum park size and number of zones
int: max_n = 100;
int: max_zones = 100;

% Decision variables
var 1..max_n: n; % Park size
array[1..max_zones] of var 1..n: zones; % Zone sizes
var 1..max_zones: num_zones; % Number of zones

% Constraint: Cover the whole park
constraint sum([zones[i]^2 | i in 1..num_zones]) = n^2;

% Constraint: All zone sizes must be different
constraint alldifferent([zones[i] | i in 1..num_zones]);

% Constraint: No zone size can be a multiple of another zone size
constraint forall(i in 1..num_zones, j in i+1..num_zones) (
  zones[i] mod zones[j] != 0 /\ zones[j] mod zones[i] != 0
);

% Objective: Minimize unused area
var int: unused_area = n^2 - sum([zones[i]^2 | i in 1..num_zones]);
solve minimize unused_area;
```

Note: This model assumes that the park size `n` and the number of zones `num_zones` are decision variables. If they are given as input, you can replace `var 1..max_n: n;` and `var 1..max_zones: num_zones;` with `int: n = ...;` and `int: num_zones = ...;`, respectively, and remove `unused_area` from the objective function.
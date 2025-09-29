Reasoning:

1. Decision Variables:
   - The number of knapsacks to be made.
   - The number of accessories to be added to each knapsack.
   - The assignment of knapsacks to sewing stations.

2. Domains:
   - The number of knapsacks and accessories are integers and can range from 0 to the maximum capacity of the company.
   - The assignment of knapsacks to sewing stations is a binary decision (0 or 1).

3. Constraints:
   - Each sewing station can handle at most a certain percentage of knapsacks.
   - Some accessories cannot go together otherwise there won't be enough space left.
   - The total number of knapsacks assigned to a sewing station should not exceed its capacity.

4. Objective Function:
   - The objective is to maximize the amount of items each knapsack can contain with respect to its size.

5. Simplifications or Modeling Choices:
   - We can assume that the size of each accessory and the capacity of each knapsack are known.
   - We can also assume that the capacity of each sewing station and the percentage of knapsacks it can handle are known.

MiniZinc model:

```minizinc
% Number of knapsacks, accessories, and sewing stations
int: n_knapsacks; 
int: n_accessories; 
int: n_stations;

% Capacity of each knapsack and each sewing station
array[1..n_knapsacks] of int: knapsack_capacity;
array[1..n_stations] of int: station_capacity;

% Size of each accessory
array[1..n_accessories] of int: accessory_size;

% Percentage of knapsacks each station can handle
array[1..n_stations] of float: station_percentage;

% Decision variables
array[1..n_knapsacks, 1..n_accessories] of var 0..1: knapsack_accessories;
array[1..n_knapsacks, 1..n_stations] of var 0..1: knapsack_stations;

% Constraint: Each sewing station can handle at most a certain percentage of knapsacks
constraint forall(i in 1..n_stations)(
  sum(j in 1..n_knapsacks)(knapsack_stations[j, i]) <= station_capacity[i] * station_percentage[i]
);

% Constraint: Some accessories cannot go together otherwise there won't be enough space left
% This can be represented as a matrix where each row represents a knapsack and each column represents an accessory.
% If the value at a particular position is 1, it means that the accessory is added to the knapsack. If it is 0, it means that the accessory is not added.
constraint forall(i in 1..n_knapsacks)(
  sum(j in 1..n_accessories)(knapsack_accessories[i, j] * accessory_size[j]) <= knapsack_capacity[i]
);

% Objective: Maximize the amount of items each knapsack can contain with respect to its size
var int: total_items = sum(i in 1..n_knapsacks, j in 1..n_accessories)(knapsack_accessories[i, j]);
solve maximize total_items;

output ["Total items: ", show(total_items)];
```

This model assumes that the size of each accessory and the capacity of each knapsack are known. It also assumes that the capacity of each sewing station and the percentage of knapsacks it can handle are known. The model uses two decision variables: one to represent the number of accessories added to each knapsack and another to represent the assignment of knapsacks to sewing stations. The constraints ensure that each sewing station can handle at most a certain percentage of knapsacks and that some accessories cannot go together otherwise there won't be enough space left. The objective is to maximize the amount of items each knapsack can contain with respect to its size.
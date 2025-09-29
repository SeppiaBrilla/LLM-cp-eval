Reasoning:

1. Decision Variables: The sequence of cars to be produced. Each car can be represented as a binary vector where each element represents whether a particular option is included in the car or not. For example, if there are 3 options (air-conditioning, sun-roof, and automatic transmission), a car with air-conditioning and automatic transmission but without a sun-roof can be represented as [1, 0, 1].

2. Domains: The domain of each element in the binary vector is {0, 1}. The domain of the sequence is all possible permutations of the cars.

3. Constraints: 
   - Each station can handle at most a certain percentage of the cars passing along the assembly line. This can be represented as a constraint on the sum of the corresponding element in the binary vectors of the cars in the sequence.
   - The cars requiring a certain option must not be bunched together. This can be represented as a constraint on the maximum number of consecutive cars in the sequence that have a particular option.

4. This is a satisfaction problem as we are looking for a sequence that satisfies all the constraints.

5. Potential Simplifications or Modeling Choices: 
   - Instead of representing each car as a binary vector, we can represent it as an integer where each bit represents whether a particular option is included in the car or not. This can simplify the representation and the constraints.
   - Instead of considering all possible permutations of the cars, we can use a heuristic to generate the initial sequence and then use local search to improve it. This can significantly reduce the search space and the computation time.

MiniZinc model:

```minizinc
% Number of cars
int: n;

% Number of options
int: m;

% Maximum percentage of cars that each station can handle
array[1..m] of float: max_percentage;

% Binary representation of the cars
array[1..n, 1..m] of var 0..1: cars;

% Sequence of cars
array[1..n] of var 1..n: sequence;

% Each station can handle at most a certain percentage of the cars
constraint forall(i in 1..m) (
  sum(j in 1..n) (cars[sequence[j], i]) <= max_percentage[i] * n
);

% The cars requiring a certain option must not be bunched together
constraint forall(i in 1..m, j in 1..n-1) (
  cars[sequence[j], i] + cars[sequence[j+1], i] <= 1
);

solve satisfy;
```

This model assumes that the maximum number of consecutive cars that can have a particular option is 1. If this number is different for different options, it can be represented as an array and used in the second constraint.
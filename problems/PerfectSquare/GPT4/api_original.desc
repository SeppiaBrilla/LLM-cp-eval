Reasoning:

1. Decision Variables: 
   - The x and y coordinates of the bottom left corner of each square. These are integer variables.
   - The size of the packing square. This is an integer variable.

2. Domains: 
   - The x and y coordinates of each square are in the range 0..size of the packing square.
   - The size of the packing square is in the range of the sum of the areas of all squares to the square of the maximum dimension of a square.

3. Constraints: 
   - The squares must not overlap. This can be ensured by checking that for every pair of squares, one square's right edge is to the left of the other square's left edge, or one square's left edge is to the right of the other square's right edge, or one square's top edge is below the other square's bottom edge, or one square's bottom edge is above the other square's top edge.
   - The squares must be within the packing square. This can be ensured by checking that for each square, its right edge is not beyond the right edge of the packing square, its left edge is not beyond the left edge of the packing square, its top edge is not beyond the top edge of the packing square, and its bottom edge is not beyond the bottom edge of the packing square.
   - The sum of the areas of all squares is equal to the area of the packing square.

4. This is a satisfaction problem as we are looking for a feasible solution that satisfies all the constraints.

5. Potential Simplifications: 
   - We can sort the squares in decreasing order of their sizes. This can potentially reduce the search space as larger squares have fewer placement options.

MiniZinc model:

```minizinc
% Perfect Square Placement Problem

% Number of squares
int: n;

% Sizes of the squares
array[1..n] of int: sizes;

% Decision variables
array[1..n] of var 0..sum(sizes): x;
array[1..n] of var 0..sum(sizes): y;
var max(sizes)..sum(sizes): size;

% Squares must not overlap
constraint forall(i in 1..n, j in i+1..n) (
  x[i] + sizes[i] <= x[j] \/ x[j] + sizes[j] <= x[i] \/
  y[i] + sizes[i] <= y[j] \/ y[j] + sizes[j] <= y[i]
);

% Squares must be within the packing square
constraint forall(i in 1..n) (
  x[i] + sizes[i] <= size /\ y[i] + sizes[i] <= size
);

% The sum of the areas of all squares is equal to the area of the packing square
constraint sum(i in 1..n) (sizes[i]*sizes[i]) = size*size;

% Solve
solve satisfy;
```

This model assumes that the sizes of the squares are given as input. The x and y coordinates of the squares and the size of the packing square are the decision variables. The constraints ensure that the squares do not overlap and are within the packing square. The objective is to find a feasible solution that satisfies all the constraints.
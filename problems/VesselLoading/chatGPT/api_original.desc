Reasoning:

1. Decision Variables: The decision variables are the positions of the containers on the deck. For each container, we need two variables to represent its position (x, y) on the deck. 

2. Domains: The domain of the position variables is determined by the size of the deck. If the deck is of size (W, H), then the domain of x is 1..W and the domain of y is 1..H.

3. Constraints: There are several constraints that need to be encoded:
   - Each container must fit within the deck. This means that for each container, its x position plus its width must be less than or equal to the deck width, and its y position plus its height must be less than or equal to the deck height.
   - Containers cannot overlap. This means that for each pair of containers, either the x range of the first container does not overlap with the x range of the second container, or the y range of the first container does not overlap with the y range of the second container.
   - Certain classes of containers must be separated by minimum distances. This means that for each pair of containers of the same class, the distance between their x positions must be greater than or equal to the minimum distance, and the distance between their y positions must be greater than or equal to the minimum distance.

4. This is a satisfaction problem. The goal is to find a feasible arrangement of the containers on the deck, not to optimize any objective.

5. Potential Simplifications: If the containers are all of the same size, then the problem becomes a simpler bin packing problem. If there are no separation constraints, then the problem becomes a simpler rectangle packing problem.

MiniZinc model:

```minizinc
% Deck size
int: W;
int: H;

% Number of containers
int: N;

% Container sizes and classes
array[1..N] of int: widths;
array[1..N] of int: heights;
array[1..N] of int: classes;

% Minimum separation distances for each class
array[int] of int: min_distances;

% Position variables
array[1..N] of var 1..W: xs;
array[1..N] of var 1..H: ys;

% Each container must fit within the deck
constraint forall(i in 1..N) (
  xs[i] + widths[i] <= W + 1,
  ys[i] + heights[i] <= H + 1
);

% Containers cannot overlap
constraint forall(i in 1..N, j in i+1..N) (
  xs[i] + widths[i] <= xs[j] \/ xs[j] + widths[j] <= xs[i] \/
  ys[i] + heights[i] <= ys[j] \/ ys[j] + heights[j] <= ys[i]
);

% Separation constraints
constraint forall(i in 1..N, j in i+1..N) (
  if classes[i] = classes[j] then
    abs(xs[i] - xs[j]) >= min_distances[classes[i]] /\
    abs(ys[i] - ys[j]) >= min_distances[classes[i]]
  else
    true
  endif
);

solve satisfy;
```

This model assumes that the minimum separation distances are given for each class, and that the class of each container is known. The model also assumes that the containers are positioned with their bottom-left corner at the given position, and that the width and height of each container are known.
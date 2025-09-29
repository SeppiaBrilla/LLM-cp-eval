Reasoning:
1. The Nonogram grid is a square grid of size n x n. Each cell is a binary variable with domain 0..1, where 0 represents an unshaded cell and 1 represents a shaded cell.
2. The constraints are given as sequences of integers for each row and column. These sequences represent the lengths of consecutive blocks of shaded cells in the corresponding row or column.
3. Constraint: Each row and column must satisfy its given sequence of block lengths. This means that for each sequence, there must be a block of shaded cells of the corresponding length, separated by at least one unshaded cell.
4. This is a satisfaction problem (no objective function).

MiniZinc model:
```minizinc
% Nonogram solver
include "globals.mzn";

% Size of the grid
int: n;

% Sequences for rows and columns
array[1..n] of set of int: rowSeqs;
array[1..n] of set of int: colSeqs;

% Grid of cells
array[1..n, 1..n] of var 0..1: grid;

% Function to check if a row or column satisfies its sequence
function var bool: satisfiesSeq(array[int] of var int: cells, set of int: seq) =
  let {
    % Convert cells to blocks
    array[int] of var int: blocks = [ sum(i in lb..ub)(cells[i]) | lb, ub in index_sets(cells) where ub > lb /\ cells[lb] = 1 /\ (lb = index_set_min(cells) \/ cells[lb-1] = 0) /\ (ub = index_set_max(cells) \/ cells[ub+1] = 0) ];
  } in
  % Check if blocks match sequence
  increasing(blocks) /\ blocks = seq;

% Constraints for rows and columns
constraint forall(i in 1..n) (
  satisfiesSeq([grid[i, j] | j in 1..n], rowSeqs[i])
);
constraint forall(j in 1..n) (
  satisfiesSeq([grid[i, j] | i in 1..n], colSeqs[j])
);

solve satisfy;
```

Note: This model assumes that the sequences for rows and columns are given as sets of integers, which means that the order of blocks is not considered. If the order of blocks is important, the sequences should be given as arrays of integers, and the `satisfiesSeq` function should be modified to check the order of blocks.
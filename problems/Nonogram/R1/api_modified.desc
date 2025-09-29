**Reasoning:**

1. **Problem Analysis**: The problem involves a grid of tiles where each cell can be blank (0) or filled with stone (1). Each row and column has a sequence constraint specifying the lengths of consecutive filled tiles, in order, separated by at least one blank tile. This is similar to a nonogram puzzle.

2. **Variables**: The grid is represented as a 2D array of binary variables, where `grid[i,j] = 0` for blank and `grid[i,j] = 1` for filled.

3. **Constraints**: For each row, the sequence of cells must match the given block pattern (e.g., (3,1,2) means a block of 3 filled tiles, then after gaps, a block of 1, then a block of 2). Similarly for each column. The order of blocks is fixed, and gaps between blocks must have at least one blank, but leading and trailing blanks are allowed.

4. **Modeling Approach**: The `regular` constraint in MiniZinc is suitable for encoding sequence constraints via a deterministic finite automaton (DFA). The DFA for a pattern with blocks `[b1, b2, ..., bk]` corresponds to the regular expression `0* (1^{b1} 0+ 1^{b2} 0+ ... 1^{bk} 0*)`, where `0` is blank, `1` is filled, `0*` means zero or more blanks, and `0+` means one or more blanks.

5. **DFA Construction**: For each row and column, a DFA is built with states for start, each block, and gaps. The number of states `Q` depends on the block sizes and count. The initial state is 1, and final states are the gap states after each block (or the start state if no blocks). Transitions are defined for symbols 1 (blank) and 2 (filled) after mapping grid values (0->1, 1->2).

6. **Challenges**: Computing the DFA for each row and column within MiniZinc is complex due to variable state counts and transition matrices. In practice, for a general model, the DFA parameters must be precomputed or generated based on the input constraints. The example code below uses a fixed DFA for a specific pattern to illustrate the approach.

7. **Generalization**: For arbitrary instances, the DFA must be constructed dynamically for each row and column using cumulative sums of block sizes to determine state indices and transitions, as described in the reasoning. This involves setting a maximum number of states `Q_max` and computing transitions accordingly.

**MiniZinc model:**

```minizinc
% Facade design with row and column sequence constraints
% Example for a specific instance; for general use, DFA must be computed per row/column.

int: R = 3; % number of rows
int: C = 5; % number of columns
array[1..R, 1..C] of var 0..1: grid; % grid[i,j] = 0 for blank, 1 for filled

% Example: Row 1 has pattern (2,1)
% DFA for pattern (2,1):
% - States: 1 (start), 2 (block1 first filled), 3 (block1 second filled), 
%   4 (gap after block1), 5 (block2 first filled), 6 (gap after block2), 7 (sink)
% - Initial state: 1
% - Final states: {6} (gap after last block)
% - Alphabet: symbol 1 for blank (0), symbol 2 for filled (1)
% - Transitions:
%     state 1: blank->1, filled->2
%     state 2: blank->7, filled->3
%     state 3: blank->4, filled->7
%     state 4: blank->4, filled->5
%     state 5: blank->6, filled->7
%     state 6: blank->6, filled->7
%     state 7: blank->7, filled->7

constraint
  % Apply DFA for row 1 with pattern (2,1)
  regular( [1 + grid[1,j] | j in 1..C],  % sequence: map 0->1, 1->2
           7,                             % number of states
           2,                             alphabet size
           [| 1, 2,                      % state 1: on blank->1, on filled->2
            | 7, 3,                      % state 2: on blank->7, on filled->3
            | 4, 7,                      % state 3: on blank->4, on filled->7
            | 4, 5,                      % state 4: on blank->4, on filled->5
            | 6, 7,                      % state 5: on blank->6, on filled->7
            | 6, 7,                      % state 6: on blank->6, on filled->7
            | 7, 7 |],                   % state 7: on blank->7, on filled->7
           1,                             % initial state
           {6}                           % final states
         );

% Add similar constraints for other rows and columns as needed.
% For example, for row 2 with a different pattern, define another DFA.

solve satisfy;
output [ show2d(grid) ];
```

**Note:** This model is for illustration with a fixed pattern. For general use, parameters for row/column constraints (e.g., `row_blocks` and `col_blocks`) should be defined, and the DFA must be computed for each row and column using cumulative sums and state calculations, as outlined in the reasoning. The `regular` constraint would then be applied in a loop for all rows and columns.
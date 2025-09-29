**Reasoning:**

1. **Problem Understanding**: Nonograms require shading cells in a grid such that the sequences of consecutive shaded cells in each row and column match the given clues. Each clue is a list of integers representing the lengths of shaded blocks, which must be separated by at least one unshaded cell.

2. **Grid Representation**: The grid is modeled as a 2D array of Boolean variables, where `true` indicates a shaded cell and `false` indicates an unshaded cell.

3. **Constraints**:
   - For each row, the sequence of shaded/unshaded cells must satisfy the row clue.
   - For each column, the sequence must satisfy the column clue.
   - This is a satisfaction problem (no optimization objective).

4. **Modeling Approach**: Use the `regular` constraint to enforce the sequence patterns. The `regular` constraint relies on a deterministic finite automaton (DFA) that accepts only sequences matching the clue.

5. **Automaton Design for Clues**:
   - For a clue with `k` blocks and lengths `L`:
     - If `k = 0` (no shaded cells), the automaton has one state that only accepts sequences of all `false`.
     - If `k > 0`, the automaton has `Q = sum(L) + k + 1` states, including an initial state, states for counting shaded cells in each block, and gap states for separators. Transitions are defined to ensure blocks of consecutive `true` values of specified lengths, separated by `false` values.
   - The sequence values are mapped to integers: `false` → 1, `true` → 2 (since `regular` requires symbols 1..S).

6. **Parameters and Fixed Dimensions**: Since MiniZinc requires fixed array sizes, we assume maximum numbers of blocks per row and column are provided. Clues are given as 2D arrays with padding for rows with fewer blocks.

7. **Implementation Details**:
   - Compute the maximum number of states `M_r` and `M_c` for rows and columns to define fixed-size transition matrices.
   - For each row and column, compute its actual automaton parameters (number of states, transition matrix, final states) based on its clue.
   - Apply the `regular` constraint to each row and column sequence using their respective automata.

**MiniZinc Model:**

```minizinc
% Nonogram Solver
% Parameters: grid dimensions and clues
int: rows;
int: cols;
int: max_row_blk; % Maximum number of blocks per row
int: max_col_blk; % Maximum number of blocks per column
array[1..rows] of int: row_blk_count; % Number of blocks for each row
array[1..rows, 1..max_row_blk] of int: row_clues; % Row clues (padded with 0 if needed)
array[1..cols] of int: col_blk_count; % Number of blocks for each column
array[1..cols, 1..max_col_blk] of int: col_clues; % Column clues (padded with 0 if needed)

% Decision variables: grid of cells
array[1..rows, 1..cols] of var bool: grid;

% Compute maximum number of states for rows and columns
int: M_r = max(
    [if row_blk_count[i] == 0 then 1 
     else sum(j in 1..row_blk_count[i]) (row_clues[i,j]) + row_blk_count[i] + 1 
     endif | i in 1..rows]
);
int: M_c = max(
    [if col_blk_count[j] == 0 then 1 
     else sum(k in 1..col_blk_count[j]) (col_clues[j,k]) + col_blk_count[j] + 1 
     endif | j in 1..cols]
);

% Constraint for each row
constraint forall(i in 1..rows) (
    let {
        % Get the clue for row i
        int: k = row_blk_count[i],
        % Compute actual number of states for this row
        int: actual_Q = if k == 0 then 1 
                       else sum(j in 1..k) (row_clues[i,j]) + k + 1 
                       endif,
        % Define transition matrix d for this row (size M_r x 2)
        array[1..M_r, 1..2] of int: d = 
            if k == 0 then
                % Automaton for no blocks: only state 1
                array2d(1..M_r, 1..2, 
                    [if q == 1 then (if s == 1 then 1 else 0 endif) else 0 endif 
                    | q in 1..M_r, s in 1..2])
            else
                % Automaton for k blocks
                array2d(1..M_r, 1..2, 
                    [let {
                        % State definitions
                        int: start_1 = 2,
                        % Function to compute start_m for block m
                        function int: start_block(int: m) = 
                            1 + sum(j in 1..m-1) (row_clues[i,j]) + m,
                        function int: end_block(int: m) = 
                            start_block(m) + row_clues[i,m] - 1,
                        function int: gap_state(int: m) = 
                            end_block(m) + 1
                    } in
                    if q == 1 then
                        % Initial state
                        if s == 1 then 1 else 2 endif
                    else
                        % Check if q is in any block or gap
                        if q <= actual_Q then
                            % Check for block states
                            forall(m in 1..k) (
                                if q >= start_block(m) /\ q <= end_block(m) then
                                    % In block m
                                    if q < end_block(m) then
                                        if s == 2 then q+1 else 0 endif
                                    else
                                        if s == 1 then gap_state(m) else 0 endif
                                    endif
                                else
                                    false
                                endif
                            ) 
                            \/ 
                            % Check for gap states
                            forall(m in 1..k) (
                                if q == gap_state(m) then
                                    if m < k then
                                        if s == 1 then q else start_block(m+1) endif
                                    else
                                        if s == 1 then q else 0 endif
                                    endif
                                else
                                    false
                                endif
                            )
                        else
                            % States beyond actual_Q: no transitions
                            0
                        endif
                    endif | q in 1..M_r, s in 1..2]
                )
            endif,
        % Final state(s)
        set of int: F = {actual_Q}
    in
    regular([bool2int(grid[i,j]) + 1 | j in 1..cols], M_r, 2, d, 1, F)
);

% Constraint for each column
constraint forall(j in 1..cols) (
    let {
        % Get the clue for column j
        int: k = col_blk_count[j],
        % Compute actual number of states for this column
        int: actual_Q = if k == 0 then 1 
                       else sum(kk in 1..k) (col_clues[j,kk]) + k + 1 
                       endif,
        % Define transition matrix d for this column (size M_c x 2)
        array[1..M_c, 1..2] of int: d = 
            if k == 0 then
                % Automaton for no blocks: only state 1
                array2d(1..M_c, 1..2, 
                    [if q == 1 then (if s == 1 then 1 else 0 endif) else 0 endif 
                    | q in 1..M_c, s in 1..2])
            else
                % Automaton for k blocks
                array2d(1..M_c, 1..2, 
                    [let {
                        % State definitions
                        int: start_1 = 2,
                        % Function to compute start_m for block m
                        function int: start_block(int: m) = 
                            1 + sum(kk in 1..m-1) (col_clues[j,kk]) + m,
                        function int: end_block(int: m) = 
                            start_block(m) + col_clues[j,m] - 1,
                        function int: gap_state(int: m) = 
                            end_block(m) + 1
                    } in
                    if q == 1 then
                        % Initial state
                        if s == 1 then 1 else 2 endif
                    else
                        % Check if q is in any block or gap
                        if q <= actual_Q then
                            % Check for block states
                            forall(m in 1..k) (
                                if q >= start_block(m) /\ q <= end_block(m) then
                                    % In block m
                                    if q < end_block(m) then
                                        if s == 2 then q+1 else 0 endif
                                    else
                                        if s == 1 then gap_state(m) else 0 endif
                                    endif
                                else
                                    false
                                endif
                            ) 
                            \/ 
                            % Check for gap states
                            forall(m in 1..k) (
                                if q == gap_state(m) then
                                    if m < k then
                                        if s == 1 then q else start_block(m+1) endif
                                    else
                                        if s == 1 then q else 0 endif
                                    endif
                                else
                                    false
                                endif
                            )
                        else
                            % States beyond actual_Q: no transitions
                            0
                        endif
                    endif | q in 1..M_c, s in 1..2]
                )
            endif,
        % Final state(s)
        set of int: F = {actual_Q}
    in
    regular([bool2int(grid[i,j]) + 1 | i in 1..rows], M_c, 2, d, 1, F)
);

% Solve satisfy: find any valid shading
solve satisfy;

% Output the grid (optional)
output [if fix(grid[i,j]) then "X" else " " endif | i in 1..rows, j in 1..cols];
```

**Note:** This model assumes that the clues are provided with padding for rows/columns with fewer blocks. The transition matrices are computed for each row and column based on their clues, using the maximum state counts `M_r` and `M_c` to ensure fixed dimensions. The output displays the grid with "X" for shaded cells and spaces for unshaded cells.
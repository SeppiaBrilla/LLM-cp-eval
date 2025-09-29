**Reasoning:**

1. **Decision variables**: We need a 2D array representing the grid where each cell can be either shaded (1) or unshaded (0). Let's assume an n×m grid.

2. **Domains**: Each cell is binary: 0 (unshaded) or 1 (shaded).

3. **Constraints**: 
   - For each row, the sequence of consecutive shaded blocks must match the given constraint sequence
   - For each column, the sequence of consecutive shaded blocks must match the given constraint sequence
   - Between consecutive blocks, there must be at least one unshaded cell (gap)

4. **Modeling approach**: 
   - We need to encode that a sequence like [3,1,2] means exactly 3 consecutive 1s, then at least one 0, then exactly 1 consecutive 1, then at least one 0, then exactly 2 consecutive 1s
   - We can use regular expressions or create auxiliary variables to track block positions
   - A simpler approach is to use the `regular` constraint with finite automata that recognize valid patterns

5. **Problem type**: This is a constraint satisfaction problem (no optimization objective).

6. **Implementation considerations**: 
   - We'll need to convert each row/column constraint into a regular expression or automaton
   - The regular constraint in MiniZinc can handle this elegantly
   - We need to handle the case where constraints might be empty (no shaded blocks)

**MiniZinc model:**

```minizinc
% Nonogram solver
% Grid dimensions
int: rows;
int: cols;

% The grid: 0 = unshaded, 1 = shaded
array[1..rows, 1..cols] of var 0..1: grid;

% Row constraints - each row has a sequence of block lengths
array[1..rows] of var set of int: row_constraints;
array[1..cols] of var set of int: col_constraints;

% Helper function to create automaton for a sequence of blocks
function var int: create_block_automaton(array[int] of int: blocks, int: length) =
  let {
    % Create states for the automaton
    % State 0: initial state (can have leading zeros)
    % States 1..n: processing blocks
    % Final state: accepting state (can have trailing zeros)
    
    % For simplicity, we'll use a different approach with regular expressions
    % This is a placeholder - actual implementation would need more complex automaton
  } in 0;

% Constraint for each row
constraint forall(r in 1..rows) (
  let {
    array[int] of int: blocks = [i | i in row_constraints[r]];
    array[1..cols] of var 0..1: row_r = [grid[r,c] | c in 1..cols];
  } in
  % This constraint ensures the row matches the block pattern
  % Implementation depends on how constraints are specified
  true  % Placeholder - would need actual regular constraint
);

% Constraint for each column  
constraint forall(c in 1..cols) (
  let {
    array[int] of int: blocks = [i | i in col_constraints[c]];
    array[1..rows] of var 0..1: col_c = [grid[r,c] | r in 1..rows];
  } in
  % This constraint ensures the column matches the block pattern
  % Implementation depends on how constraints are specified  
  true  % Placeholder - would need actual regular constraint
);

% Example with concrete constraints for a 5x5 grid
% Uncomment and modify as needed:
/*
rows = 5;
cols = 5;

% Example row constraints: [2,1], [1,1], [3], [1], [2]
constraint regular([grid[1,c] | c in 1..cols], 
  "0*1{2}0+1{1}0*");  % Row 1: block of 2, gap, block of 1
constraint regular([grid[2,c] | c in 1..cols], 
  "0*1{1}0+1{1}0*");  % Row 2: block of 1, gap, block of 1
constraint regular([grid[3,c] | c in 1..cols], 
  "0*1{3}0*");        % Row 3: block of 3
constraint regular([grid[4,c] | c in 1..cols], 
  "0*1{1}0*");        % Row 4: block of 1
constraint regular([grid[5,c] | c in 1..cols], 
  "0*1{2}0*");        % Row 5: block of 2

% Example column constraints would be similar
*/

solve satisfy;

% Output formatting
output [
  if c = 1 then "\n" else "" endif ++
  if grid[r,c] = 1 then "█" else "·" endif
  | r in 1..rows, c in 1..cols
] ++ ["\n"];
```

Note: This model provides the framework but requires specific constraint data to be complete. The regular expressions would need to be properly constructed based on the actual block sequences for each row and column. For a complete implementation, you would replace the placeholder constraints with actual regular expressions or use a more sophisticated automaton-based approach to encode the nonogram rules.
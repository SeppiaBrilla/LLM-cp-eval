**Reasoning:**

1. **Decision Variables:**
   - Assignment of shoppers to outlets for visits
   - Timing of visits (which week each visit occurs)
   - Number of visits per shopper (3 or 4)

2. **Key Parameters:**
   - 19 outlets in 4 areas: Area 1 (outlets 1-5), Area 2 (outlets 6-10), Area 3 (outlets 11-15), Area 4 (outlets 16-19)
   - 35 total sales people across all outlets (1-4 per outlet)
   - 40 shoppers in 4 groups of 10 each
   - 140 total visits (35 sales people × 4 visits each)
   - 4-week fieldwork period

3. **Visit Distribution:**
   - In each group: 5 shoppers do 3 visits, 5 shoppers do 4 visits
   - Total visits per group: 5×3 + 5×4 = 35 visits
   - 4 groups × 35 visits = 140 total visits ✓

4. **Key Constraints:**
   - Each shopper visits exactly 1 outlet per area (4 areas total)
   - Each sales person gets visited by 4 different shoppers
   - Shoppers doing 4 visits: 2 visits in first 2 weeks, 2 in last 2 weeks
   - Shoppers doing 3 visits: 1-2 visits in first 2 weeks, remaining in last 2 weeks
   - Geographic distribution: shoppers should visit different areas

5. **Modeling Approach:**
   - Use binary variables for shopper-outlet-week assignments
   - Use integer variables for number of visits per shopper
   - Model the sales people distribution per outlet as a parameter
   - Ensure proper timing constraints for interim reporting

**MiniZinc model:**

```minizinc
% Cosmetic Company Sales Evaluation Scheduling Problem

% Parameters
int: num_outlets = 19;
int: num_areas = 4;
int: num_groups = 4;
int: shoppers_per_group = 10;
int: total_shoppers = num_groups * shoppers_per_group;
int: num_weeks = 4;
int: total_sales_people = 35;

% Outlet to area mapping
array[1..num_outlets] of int: outlet_area = 
  [1,1,1,1,1, 2,2,2,2,2, 3,3,3,3,3, 4,4,4,4];

% Number of sales people per outlet (must sum to 35)
array[1..num_outlets] of int: sales_people_per_outlet;
constraint sum(i in 1..num_outlets)(sales_people_per_outlet[i]) = total_sales_people;
constraint forall(i in 1..num_outlets)(sales_people_per_outlet[i] >= 1 /\ sales_people_per_outlet[i] <= 4);

% Shopper group assignment (shoppers 1-10 in group 1, 11-20 in group 2, etc.)
function int: shopper_group(int: s) = ((s-1) div shoppers_per_group) + 1;

% Decision Variables
% visits[s,o,w] = 1 if shopper s visits outlet o in week w
array[1..total_shoppers, 1..num_outlets, 1..num_weeks] of var 0..1: visits;

% Number of visits per shopper (3 or 4)
array[1..total_shoppers] of var 3..4: shopper_visit_count;

% Constraints

% 1. Each shopper does exactly their assigned number of visits
constraint forall(s in 1..total_shoppers)(
  sum(o in 1..num_outlets, w in 1..num_weeks)(visits[s,o,w]) = shopper_visit_count[s]
);

% 2. In each group: exactly 5 shoppers do 3 visits, 5 do 4 visits
constraint forall(g in 1..num_groups)(
  sum(s in ((g-1)*shoppers_per_group + 1)..(g*shoppers_per_group))(
    bool2int(shopper_visit_count[s] = 3)
  ) = 5
);

% 3. Each shopper visits exactly one outlet per area
constraint forall(s in 1..total_shoppers, a in 1..num_areas)(
  sum(o in 1..num_outlets where outlet_area[o] = a, w in 1..num_weeks)(
    visits[s,o,w]
  ) = 1
);

% 4. Each sales person gets visited by exactly 4 different shoppers
constraint forall(o in 1..num_outlets)(
  sum(s in 1..total_shoppers, w in 1..num_weeks)(visits[s,o,w]) = 
  sales_people_per_outlet[o] * 4
);

% 5. Each sales person visited exactly 2 times in first 2 weeks
constraint forall(o in 1..num_outlets)(
  sum(s in 1..total_shoppers, w in 1..2)(visits[s,o,w]) = 
  sales_people_per_outlet[o] * 2
);

% 6. Timing constraints for shoppers
% Shoppers doing 4 visits: exactly 2 in first 2 weeks
constraint forall(s in 1..total_shoppers where shopper_visit_count[s] = 4)(
  sum(o in 1..num_outlets, w in 1..2)(visits[s,o,w]) = 2
);

% Shoppers doing 3 visits: 1 or 2 in first 2 weeks
constraint forall(s in 1..total_shoppers where shopper_visit_count[s] = 3)(
  let var 1..2: first_half_visits = sum(o in 1..num_outlets, w in 1..2)(visits[s,o,w])
  in true
);

% 7. No shopper visits the same outlet twice
constraint forall(s in 1..total_shoppers, o in 1..num_outlets)(
  sum(w in 1..num_weeks)(visits[s,o,w]) <= 1
);

% 8. Each outlet visited by shoppers from different groups
constraint forall(o in 1..num_outlets)(
  forall(g in 1..num_groups)(
    sum(s in ((g-1)*shoppers_per_group + 1)..(g*shoppers_per_group), w in 1..num_weeks)(
      visits[s,o,w]
    ) >= 1
  )
);

% Example sales people distribution (must be adjusted based on actual data)
constraint sales_people_per_outlet = [2,2,2,2,2, 2,2,2,2,2, 2,2,2,2,2, 1,1,1,1];

solve satisfy;

% Output
output [
  "Shopper " ++ show(s) ++ " (Group " ++ show(shopper_group(s)) ++ 
  ", " ++ show(shopper_visit_count[s]) ++ " visits):\n" ++
  concat([
    if sum(w in 1..num_weeks)(visits[s,o,w]) > 0 then
      "  Week " ++ show(sum(w in 1..num_weeks)(w * visits[s,o,w])) ++ 
      ": Outlet " ++ show(o) ++ " (Area " ++ show(outlet_area[o]) ++ ")\n"
    else "" endif
    | o in 1..num_outlets
  ]) ++ "\n"
  | s in 1..total_shoppers
];
```
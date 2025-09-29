### Reasoning

1. **Problem Overview**: The problem involves scheduling visits from shoppers to sales people across 19 outlets in 4 geographic areas. The goal is to assign visits such that each sales person is visited by 4 different shoppers, with constraints on shopper groups, visit timing, and geographic distribution.

2. **Key Entities**:
   - **Outlets**: 19 outlets divided into 4 areas: Area 1 (outlets 1-5), Area 2 (6-10), Area 3 (11-15), Area 4 (16-19).
   - **Sales People**: 35 total, with 1-4 per outlet. Each must be visited by 4 different shoppers.
   - **Shoppers**: 40 shoppers divided into 4 groups of 10. Each group has 5 shoppers making 3 visits and 5 making 4 visits, totaling 140 visits.
   - **Weeks**: Fieldwork lasts 4 weeks, with constraints on visits in the first 2 weeks.

3. **Constraints**:
   - Each sales person must be visited by shoppers from 4 different groups.
   - Each shopper visits at most one outlet per geographic area.
   - Each sales person must be visited exactly twice in the first 2 weeks.
   - Shoppers making 4 visits must have exactly 2 visits in the first 2 weeks; those making 3 visits must have 1 or 2 visits in the first 2 weeks.
   - The assignment must respect the grouping of shoppers and outlets.

4. **Modeling Decisions**:
   - Use arrays to map outlets to areas and sales people to outlets as parameters.
   - Define decision variables for shopper assignments and week assignments per sales person visit.
   - Ensure alldifferent constraints for shoppers per sales person and groups per sales person.
   - Use sum constraints to enforce visit counts and weekly visit distributions.
   - For the area constraint, compute the number of distinct outlets per area per shopper and ensure it is at most 1.

5. **Simplifications**:
   - Assume parameters like `sales_outlet` and `shopper_visits` are provided and valid.
   - Use a satisfaction problem since no objective function is specified.

### MiniZinc Model

```minizinc
% Cosmetic Company Sales Evaluation Schedule
% Parameters defining the problem instance

% Number of outlets, sales people, shoppers, weeks, and groups
int: num_outlets = 19;
int: num_sales = 35;
int: num_shoppers = 40;
int: num_weeks = 4;
int: num_groups = 4;
set of int: OUTLETS = 1..num_outlets;
set of int: SALES = 1..num_sales;
set of int: SHOPPERS = 1..num_shoppers;
set of int: WEEKS = 1..num_weeks;
set of int: GROUPS = 1..num_groups;

% Area for each outlet (1-4). Example: outlets 1-5 in area 1, etc.
array[OUTLETS] of 1..num_groups: areas;

% Outlet for each sales person (1-19)
array[SALES] of OUTLETS: sales_outlet;

% Group for each shopper (1-4)
array[SHOPPERS] of GROUPS: shopper_group;

% Number of visits per shopper (3 or 4). Must satisfy: for each group, exactly 5 shoppers have 3 visits and 5 have 4 visits.
array[SHOPPERS] of 3..4: shopper_visits;

% Decision variables

% shopper_assignment[s, v] = shopper for the v-th visit to sales person s
array[SALES, 1..4] of var SHOPPERS: shopper_assignment;

% week_assignment[s, v] = week for the v-th visit to sales person s
array[SALES, 1..4] of var WEEKS: week_assignment;

% Constraints

% 1. Each sales person is visited by 4 different shoppers
constraint forall(s in SALES) (
    alldifferent([shopper_assignment[s, v] | v in 1..4])
);

% 2. Each shopper makes the required number of visits
constraint forall(sh in SHOPPERS) (
    sum(s in SALES, v in 1..4) (shopper_assignment[s, v] == sh) = shopper_visits[sh]
);

% 3. Each sales person is visited exactly twice in the first 2 weeks
constraint forall(s in SALES) (
    sum(v in 1..4) (week_assignment[s, v] <= 2) = 2
);

% 4. Shoppers with 4 visits have exactly 2 visits in first 2 weeks; those with 3 visits have 1 or 2
constraint forall(sh in SHOPPERS) (
    let {
        var int: visits_in_first2 = sum(s in SALES, v in 1..4) (
            shopper_assignment[s, v] == sh /\ week_assignment[s, v] <= 2
        )
    } in
    if shopper_visits[sh] == 4 then
        visits_in_first2 = 2
    else
        visits_in_first2 in 1..2
    endif
);

% 5. Each sales person is visited by shoppers from 4 different groups
constraint forall(s in SALES) (
    alldifferent([shopper_group[shopper_assignment[s, v]] | v in 1..4])
);

% 6. Each shopper visits at most one outlet per geographic area
constraint forall(sh in SHOPPERS, a in GROUPS) (
    sum(o in OUTLETS where areas[o] == a) (
        exists(s in SALES where sales_outlet[s] == o) (
            exists(v in 1..4)(shopper_assignment[s, v] == sh)
        )
    ) <= 1
);

% Solve satisfaction problem
solve satisfy;

% Output: Display assignments for each sales person
output [
    "Sales person ", show(s), " visited by shoppers ", 
    show([shopper_assignment[s, v] | v in 1..4]), 
    " in weeks ", show([week_assignment[s, v] | v in 1..4]), "\n"
    | s in SALES
];
```

**Note**: This model requires a data file to define the parameters `areas`, `sales_outlet`, `shopper_group`, and `shopper_visits`. For example, a data file might include:
```minizinc
areas = [1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4];
sales_outlet = [1,1,1,2,2,2,3,3,4,4,5,5,6,6,6,7,7,8,8,9,9,10,10,11,11,11,12,12,13,13,14,14,15,15,16]; % example assignment
shopper_group = [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4]; % example groups
shopper_visits = [3,3,3,3,3,4,4,4,4,4,3,3,3,3,3,4,4,4,4,4,3,3,3,3,3,4,4,4,4,4,3,3,3,3,3,4,4,4,4,4]; % example visits
```
select 
  x.user_id, 
  x.spend, 
  x.transaction_date 
from 
  (
    select 
      t.*, 
      row_number() over(
        partition by t.user_id 
        order by 
          t.transaction_date asc
      ) as rn 
    from 
      transactions t
  ) x 
where 
  x.rn = 3;



--------------------------------------------------------

with r as (
  SELECT 
    x.category, 
    x.product, 
    x.spend 
  from 
    (
      SELECT 
        ps.category, 
        ps.product, 
        ps.spend, 
        EXTRACT(
          YEAR 
          FROM 
            ps.transaction_date
        ) as year 
      FROM 
        product_spend ps
    ) x 
  where 
    x.year = 2022
) 
select 
  y.category, 
  y.product, 
  y.total_spend 
from 
  (
    select 
      x.category, 
      x.product, 
      x.tot_spend as total_spend, 
      row_number() over(
        PARTITION BY x.category 
        order by 
          x.tot_spend desc
      ) as rn 
    from 
      (
        SELECT 
          r.category, 
          r.product, 
          sum(r.spend) as tot_spend 
        from 
          r 
        group by 
          r.category, 
          r.product
      ) x
  ) y 
where 
  y.rn < 3;

------------------------------
-- get second highest salary, get NULL if there is no second highest
--salary
SELECT
   MAX(a.Salary) as SecondHighestSalary
  FROM Employee a
  JOIN Employee b
    ON a.Salary < b.Salary
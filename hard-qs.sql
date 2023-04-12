with fp as (
  select 
    x.user_id, 
    x.purchase_date 
  from 
    (
      select 
        up.*, 
        row_number() over(
          PARTITION BY up.user_id 
          order by 
            up.purchase_date
        ) as rn 
      from 
        user_purchases up
    ) x 
  where 
    x.rn = 1
), 
tot as (
  select 
    count(DISTINCT user_id) as tots 
  from 
    signups
) 
SELECT 
  round(
    (
      100.0 * count(DISTINCT fp.user_id)/(
        select 
          tots 
        from 
          tot
      )
    ), 
    2
  ) as same_week_purchases_pct 
from 
  fp 
  join signups sp on sp.user_id = fp.user_id 
where 
  extract(
    'days' 
    from 
      (
        fp.purchase_date - sp.signup_date
      )
  ) <= 7

-----------------------------------------------
with need as (
  select 
    x.user_id, 
    x.filing_date, 
    x.prod, 
    row_number() over(
      PARTITION BY x.user_id 
      order by 
        x.filing_date
    ) as rn 
  from 
    (
      select 
        *, 
        case when lower(product) like 't%' then 'T' else 'Q' end as prod 
      from 
        filed_taxes
    ) x
) 
select 
  DISTINCT a.user_id 
from 
  need a 
  join need b on b.user_id = a.user_id 
  and b.rn = a.rn + 1 
  join need c on c.user_id = b.user_id 
  and c.rn = b.rn + 1 
where 
  a.prod = 'T' 
  and b.prod = 'T' 
  and c.prod = 'T' 
order by 
  a.user_id;


-----------------------------------------




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



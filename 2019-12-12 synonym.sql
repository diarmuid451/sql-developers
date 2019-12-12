select * from sem.users;
select *
from jobs;
select * from user_tables;
-- 78 건 >> 79 건
select *from all_tables;

select *from PC01.FASTFOOD;
--sem.fastfood >> fastfood
create synonym fastfood for PC01.FASTFOOD;
drop synonym fastfood;
select * from fastfood;
	-- SHOW DATA --
select * from courses
select * from course_info
select * from educator

=====================================

-- STEP 1: CREATE TABLE TIMETALBE
create table time_schedule
	(
	re_code_module varchar,
	re_code_presentation varchar,
	re_module_name varchar,
	re_major varchar,
	re_id_education integer
	);

-- STEP 2: TAKE DATA
create or replace procedure scheduleArrangement() as 
$$ 
	declare 	
		cur cursor for -- tạo con trỏ cur chứa các thông tin cần thiết 
			select 
				c.code_module,
				c.code_presentation ,
				ci.module_name,
				ci.major
			from courses c left join course_info ci on c.code_module = ci.code_module;
		
		vCode_Module varchar;
		vCode_Presentation varchar;
		vModule_Name varchar;
		vMajor varchar;
	
	begin 		
		open cur;
		loop
			fetch next from cur into vCode_Module , vCode_Presentation , vModule_Name, vMajor ;
			exit when not found;
			
			insert into time_schedule values  
				(vCode_Module ,
				vCode_Presentation ,
				vModule_Name ,
				vMajor ,
				
				(select id_educator 
				from educator e left join course_info ci2 on e.major = ci2.major 
				where 
					e.major = vMajor and -- vMajor
					ci2.module_name = vModule_Name and
					id_educator not in 
						( -- Kiểm tra giáo viên chưa tồn tại trong bảng kết quả
						select re_id_education 
						from time_schedule
						where 
							re_major = vMajor and
							re_module_name = vModule_Name 
						)
				order by random() -- chọn ngẫu nhiên giáo viên phù hợp
				limit 1 ) );
		end loop;
		close cur;
	end;
$$
language plpgsql;


call scheduleArrangement();
select * from time_schedule  

==========================================================


-- TEST --
create or replace procedure scheduleArrangement() as 
$$ 
declare 
	cur cursor for 
		select 
			c.code_module,
			c.code_presentation ,
			ci.module_name,
			ci.major
		from courses c left join course_info ci on c.code_module = ci.code_module;
	vCode_Module varchar;
	vCode_Presentation varchar;
	vModule_Name varchar;
	vMajor varchar;

begin 
	-- 1. create a table storing results
	drop table if exists time_table;
	create temporary table time_table
		(
		re_code_module varchar,
		re_code_presentation varchar,
		re_module_name varchar,
		re_major varchar,
		re_id_education integer
		);

	-- 2. start processing
	open cur;
	loop
		fetch next from cur into vCode_Module , vCode_Presentation , vModule_Name, vMajor ;
		exit when not found;
		
		-- insert data into time_table
		insert into time_table values  
			(
			vCode_Module ,
			vCode_Presentation ,
			vModule_Name ,
			vMajor ,
			(
			select id_educator 
			from educator e left join course_info ci2 on e.major = ci2.major 
			where 
				e.major = vMajor and -- vMajor
				ci2.module_name = vModule_Name and
				id_educator not in 
					(
					select re_id_education 
					from time_table
					where 
						re_major = vMajor and
						re_module_name = vModule_Name 
					)
			order by random()
			limit 1
			)
		);
--		raise notice 'Code module: %', vCode_Module ;
	end loop;
	close cur;
end;
$$
language plpgsql;


call scheduleArrangement();
select * from time_table 


- test 1
select code_module 
from course_info
where code_module not in 
	(
	select code_module 
	from course_info
	where code_module in ('AAA','BBB')
	)

	
-- test 2
select 
	e.id_educator ,
	ci.module_name,
	ci.major 
from educator e left join course_info ci on e.major = ci.major 
where 
	e.major = 'Computer Science' and
--	ci.module_name = 'Computer Networks'
	ci.module_name = 'Data Minings'

	
	
where major like 'Business%' and
	id_educator not in (
		select id_educator
		from educator
		where 
			major like 'Business%' and
			id_educator between 1 and 10
	)
order by random() 
limit 3 


select * from time_table 


select 
	c.code_module,
	c.code_presentation ,
	ci.module_name,
	ci.major
from courses c left join course_info ci on c.code_module = ci.code_module;
	

CREATE OR REPLACE PROCEDURE task_enrichment_proc 
AS
x number :=0 ;
y number :=0 ;
BEGIN
   BEGIN
   select count(*) into y from user_tables where table_name=UPPER('task_enrichment');
		if y = 1 then 
			SELECT count(*) INTO x FROM task_enrichment;
			if (x = 0) then 
				execute immediate('truncate table task_enrichment_field_config');
			END IF;
		elsif y=0 then 
			execute immediate('truncate table task_enrichment_field_config');
		end if;
	end;	
END task_enrichment_proc;
/

begin
task_enrichment_proc;
end;
/

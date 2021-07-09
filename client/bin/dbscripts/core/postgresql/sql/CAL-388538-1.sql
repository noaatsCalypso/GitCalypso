CREATE OR REPLACE FUNCTION ERS_HIERARCHY_PERMISSION
()
RETURNS void LANGUAGE plpgsql
AS $BODY$
DECLARE
	c_groups CURSOR for 
			SELECT distinct group_name group_name 
							FROM 	group_access;
											
	ins_perm VARCHAR(200);
	group_name VARCHAR(200);
	ers_access_perm_count int;
	
begin
        select count(*) into ers_access_perm_count from group_access where access_id = 55;
        if ers_access_perm_count > 0 then
            return;
        end if;
		
        open c_groups;

        loop
                fetch c_groups into group_name;

                exit when not found;
               
               	INSERT INTO group_access(group_name, access_id, access_value,read_only_b) VALUES(group_name, 55, '__ALL__', 0);
        end loop;

        close c_groups;

END;

$BODY$
;

DO $$ begin
	perform ERS_HIERARCHY_PERMISSION();
end$$;

DROP FUNCTION ERS_HIERARCHY_PERMISSION()
;


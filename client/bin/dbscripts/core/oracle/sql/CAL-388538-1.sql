DECLARE
	CURSOR c_groups IS SELECT distinct group_name group_name 
							FROM 	group_access;
							
	ers_access_perm_count INT;
	ins_perm varchar(200);
	group_name varchar(200);
	
BEGIN
	SELECT COUNT(*) INTO ers_access_perm_count FROM group_access WHERE access_id = 55;
	IF ers_access_perm_count > 0
		THEN
			RETURN;
	END IF;

	ins_perm := 'INSERT INTO group_access(group_name, access_id, access_value,read_only_b) VALUES(:1, 55, ''__ALL__'', 0)';

  FOR g in c_groups
    LOOP
	 	EXECUTE IMMEDIATE ins_perm USING g.group_name;
    END LOOP;
END;
/


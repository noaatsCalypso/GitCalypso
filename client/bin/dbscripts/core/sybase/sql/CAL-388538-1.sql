CREATE OR REPLACE PROCEDURE ERS_HIERARCHY_PERMISSION AS
BEGIN
		DECLARE c_groups CURSOR FOR 
							SELECT distinct group_name group_name 
							FROM 	group_access o

		DECLARE @ers_access_perm_count  int
		DECLARE	@group_name VARCHAR(200)

		SELECT @ers_access_perm_count= count(*) FROM group_access WHERE access_id = 55
		if @ers_access_perm_count > 0
		begin
			return
		end

        OPEN c_groups
        FETCH c_groups into @group_name


        WHILE(@@sqlstatus = 0)
                BEGIN
					INSERT INTO group_access(group_name, access_id, access_value,read_only_b) VALUES(@group_name, 55, '__ALL__', 0)
					FETCH c_groups into @group_name
                END


    CLOSE c_groups
    DEALLOCATE c_groups
END
GO

EXEC ERS_HIERARCHY_PERMISSION
GO

DROP PROCEDURE ERS_HIERARCHY_PERMISSION
GO

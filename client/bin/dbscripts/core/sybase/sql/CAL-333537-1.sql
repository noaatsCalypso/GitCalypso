create or replace procedure upgrade_haircut_1 as
begin
		declare
			   c1 cursor for
			   SELECT name, sec_sd_filter from haircut order by name, sec_sd_filter

		open c1
		declare @cfg_name                varchar(255)
		declare @haircut_rule_seed_id     int
		declare @inc                     int
		declare @inc2                    int
		declare @inc_plus_one            int
		declare @sdf                     varchar(255)
		declare @previous_sdf            varchar(255)
		declare @previous_cfg            varchar(255)
		declare @exist_hr_seed int
		declare @haircut_rule_kv_cfg_count            int

		fetch c1 into @cfg_name, @sdf

		DELETE FROM haircut_rule_kv_cfg
		DELETE FROM haircut_rule_kv

		SELECT @exist_hr_seed = count(*) FROM calypso_seed WHERE seed_name = 'haircut_rule'
		if @exist_hr_seed = 0
			   begin
					   select @haircut_rule_seed_id = 1000000
					   INSERT INTO calypso_seed(last_id, seed_name, seed_alloc_size) VALUES (1000000, 'haircut_rule', 500)
			   end
		else
			   begin
					   SELECT @haircut_rule_seed_id = last_id FROM calypso_seed WHERE seed_name = 'haircut_rule'
			   end

		WHILE (@@sqlstatus = 0)
			   begin
						if @previous_cfg != @cfg_name
							   begin
									   select @inc2 = 0
									   select @haircut_rule_seed_id = @haircut_rule_seed_id + 500
									   INSERT haircut_rule_kv_cfg VALUES (@haircut_rule_seed_id, 0, @cfg_name, 'null')
									   select @inc = @haircut_rule_seed_id + 1
									   INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (@haircut_rule_seed_id, 'definitions', 'TYPE_LIST', CONVERT(VARCHAR(32), @inc))
									   INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (@haircut_rule_seed_id, 'TENOR_MATURITY_DATE_INCLUSIVE', 'TYPE_BOOLEAN', 'false')
									   INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (@haircut_rule_seed_id, 'TotalHCCalculation', 'TYPE_STRING', 'ADDITION')
							   end
					   
					    if (@previous_sdf != @sdf OR @previous_cfg != @cfg_name)
							   begin
									   select @inc_plus_one = @inc + @inc2 + 1
									   INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (@inc, CONVERT(VARCHAR(32), @inc2), 'TYPE_LIST', CONVERT(VARCHAR(32), @inc_plus_one))
									   INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (@inc_plus_one, '0', 'TYPE_STRING', 'Haircut rule')
									   INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (@inc_plus_one, '1', 'TYPE_STRING', @sdf)
							   end
						select @previous_cfg = @cfg_name
						select @inc2 = @inc2 +1
						select @previous_sdf = @sdf
						fetch c1 into @cfg_name, @sdf
			   end
		close c1
		deallocate cursor c1
end
go
exec upgrade_haircut_1
go
drop procedure upgrade_haircut_1
go

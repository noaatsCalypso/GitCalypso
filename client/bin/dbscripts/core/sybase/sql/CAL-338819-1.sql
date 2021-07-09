delete from calypso_seed where seed_name = 'PricingSheetStrategyInfo'
go
insert into calypso_seed (last_id,seed_name,seed_alloc_size) values (1000,'PricingSheetStrategyInfo',500)
go
create table temp_tk as SELECT * FROM trade_keyword  WHERE keyword_name = 'StrategyType' AND trade_id NOT IN (SELECT trade_id FROM ps_strategy_info)
go
create or replace procedure update_strategy_info as
	begin
		declare
			@s_keyword_value varchar(100),
			@nextid numeric
			declare c1 cursor for
				SELECT DISTINCT keyword_value FROM temp_tk
		begin
			SELECT @nextid = coalesce(max(last_id) + 1,1001)   FROM calypso_seed WHERE seed_name = 'PricingSheetStrategyInfo'
			open c1
				fetch c1 into @s_keyword_value
				while @@sqlstatus=0
					begin
						insert into ps_strategy_info (strategy_id,strategy_name,trade_id) select @nextid,substring(keyword_value,1, charindex(keyword_value,':',1)-1), trade_id from temp_tk  WHERE keyword_name = 'StrategyType' and keyword_value = @s_keyword_value AND trade_id  NOT IN (SELECT trade_id FROM ps_strategy_info)
						select @nextid = @nextid + 1
					end
			close c_keywords
			deallocate cursor c_keywords
		END
	END
GO

exec update_strategy_info
GO

drop procedure update_strategy_info
GO

update calypso_seed set last_id = (select coalesce(max(strategy_id) + 1,1001) from ps_strategy_info) WHERE seed_name = 'PricingSheetStrategyInfo'
go

drop table temp_tk
go
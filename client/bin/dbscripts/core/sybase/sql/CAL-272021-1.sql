
if not exists (select 1 from sysobjects where type='U' and name='official_pl_config')
begin
exec ('create table official_pl_config (pl_config_id numeric not null , 
	config_name varchar(126) not null, pricing_env_name varchar(32) not null, 
	instance_type varchar(32) not null, pl_time varchar(32) not null, 
	pl_unit varchar(32) not null, include_backdated_trade numeric not null, 
	methodology_config_name varchar(256), time_zone varchar(128), holidays varchar(256), 
	version numeric, book_id numeric, pl_type varchar(32) not null, 
	fx_rate_conversion varchar(32) not null, is_fxtranslation numeric not null, 
	funding_level varchar(32) not null, crystallization_level varchar(32) not null, 
	is_cost_of_funding_pl numeric not null, year_end_month varchar(126),
	pl_measures varchar(100),
	pricer_measures varchar(100),
	trade_attributes varchar(100),
	sell_off_measures varchar(100),
	fx_histo_rate_measures varchar(100),
	crystallized_measures varchar(100))')
end
go
select * into official_pl_config_bak from official_pl_config
go
add_column_if_not_exists 'official_pl_config','pl_measures','varchar(100) null'
go
add_column_if_not_exists 'official_pl_config','sell_off_measures','varchar(100)  null'
go 
add_column_if_not_exists 'official_pl_config','sell_off_measures','varchar(100) null'
go 
add_column_if_not_exists 'official_pl_config','pricer_measures','varchar(100) null'
go
add_column_if_not_exists 'official_pl_config','trade_attributes','varchar(100) null'
go
add_column_if_not_exists 'official_pl_config','fx_histo_rate_measures','varchar(100) null'
go
add_column_if_not_exists 'official_pl_config','crystallized_measures','varchar(100) null '
go

create unique index idx_pl_confg on official_pl_config_attr(pl_config_id,attr_type,attr_value,user_specified_order)
go

create procedure update_pl_config1
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @pl_config_id int,
	  @prd_seq numeric	,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT pl_config_id , 'plmeasure' as col_key, pl_measures  from official_pl_config where pl_measures is not null and LTRIM(RTRIM(pl_measures)) != ' ' 
open cur_main
  fetch cur_main into @pl_config_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @prd_seq = 0
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			select @prd_seq= @prd_seq + 1 
			INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 select @prd_seq = @prd_seq + 1
		     INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parse_out_val, @prd_seq)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	select @prd_seq= @prd_seq + 1 
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
			end
		  end
		  
		 
      fetch cur_main into @pl_config_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_pl_config1
go

drop procedure update_pl_config1
go
create procedure update_pl_config2
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @pl_config_id int,
	  @prd_seq numeric	,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT pl_config_id , 'sell_off_measure' as col_key, sell_off_measures from official_pl_config where sell_off_measures is not null and  LTRIM(RTRIM(sell_off_measures)) != ' '
open cur_main
  fetch cur_main into @pl_config_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @prd_seq = 0
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			select @prd_seq= @prd_seq + 1 
			INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 select @prd_seq = @prd_seq + 1
		     INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parse_out_val, @prd_seq)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	select @prd_seq= @prd_seq + 1 
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
			end
		  end
		  
		 
      fetch cur_main into @pl_config_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_pl_config2
go
drop procedure update_pl_config2
go
create procedure update_pl_config3
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @pl_config_id int,
	  @prd_seq numeric	,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT pl_config_id , 'crystallized_measure' as col_key, crystallized_measures  from official_pl_config where crystallized_measures is not null and LTRIM(RTRIM(crystallized_measures)) != ' '
open cur_main
  fetch cur_main into @pl_config_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @prd_seq = 0
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			select @prd_seq= @prd_seq + 1 
			INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 select @prd_seq = @prd_seq + 1
		     INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parse_out_val, @prd_seq)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	select @prd_seq= @prd_seq + 1 
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
			end
		  end
		  
		 
      fetch cur_main into @pl_config_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_pl_config3
go
drop procedure update_pl_config3
go

create procedure update_pl_config4
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @pl_config_id int,
	  @prd_seq numeric	,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT pl_config_id , 'trade_attribute' as col_key, trade_attributes  from official_pl_config where trade_attributes is not null and LTRIM(RTRIM(trade_attributes)) != ' '
open cur_main
  fetch cur_main into @pl_config_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @prd_seq = 0
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			select @prd_seq= @prd_seq + 1 
			INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 select @prd_seq = @prd_seq + 1
		     INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parse_out_val, @prd_seq)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	select @prd_seq= @prd_seq + 1 
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
			end
		  end
		  
		 
      fetch cur_main into @pl_config_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_pl_config4
go
drop procedure update_pl_config4
go
create procedure update_pl_config5
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @pl_config_id int,
	  @prd_seq numeric	,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT pl_config_id , 'pricer_measure' as col_key, pricer_measures  from official_pl_config where pricer_measures is not null and LTRIM(RTRIM(pricer_measures)) != ' '
 open cur_main
  fetch cur_main into @pl_config_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @prd_seq = 0
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			select @prd_seq= @prd_seq + 1 
			INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 select @prd_seq = @prd_seq + 1
		     INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parse_out_val, @prd_seq)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	select @prd_seq= @prd_seq + 1 
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
			end
		  end
		  
		 
      fetch cur_main into @pl_config_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_pl_config5
go
drop procedure update_pl_config5
go
create procedure update_pl_config6
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @pl_config_id int,
	  @prd_seq numeric	,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT pl_config_id , 'fxHistoRate_measure' as col_key, fx_histo_rate_measures  from official_pl_config where fx_histo_rate_measures is not null and LTRIM(RTRIM(fx_histo_rate_measures)) != ' '

open cur_main
  fetch cur_main into @pl_config_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @prd_seq = 0
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			select @prd_seq= @prd_seq + 1 
			INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 select @prd_seq = @prd_seq + 1
		     INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parse_out_val, @prd_seq)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	select @prd_seq= @prd_seq + 1 
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (@pl_config_id, @col_key, @parseval, @prd_seq)
			end
		  end
		  
		 
      fetch cur_main into @pl_config_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_pl_config6
go
drop procedure update_pl_config6
go
alter table official_pl_config drop pl_measures 
go
alter table official_pl_config drop pricer_measures 
go
alter table official_pl_config drop trade_attributes
go
alter table official_pl_config drop sell_off_measures
go
alter table official_pl_config drop fx_histo_rate_measures
go
alter table official_pl_config drop crystallized_measures
go

add_column_if_not_exists 'risk_config_item','timestamp_format','varchar(32) null'
go
update risk_config_item set timestamp_format = 'NoTimestamp' where append_timestamp_b = 0 and timestamp_format is null
go
 
UPDATE calypso_info
    SET major_version=14,
        minor_version=3,
        sub_version=0,
        patch_version='001',
        version_date='20150529'
go 

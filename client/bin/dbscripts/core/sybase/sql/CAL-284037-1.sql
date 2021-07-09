insert into scenario_quoted_product (product_name, pricer_params,pricer_measure) values ('ListedFRA','NPV_FROM_QUOTE','INSTRUMENT_SPREAD') 
go


update commodity_leg SET cashflow_locks =  case convert(bigint, cashflow_locks) & convert(bigint,power( 2.0,48.0)) 
when 281474976710656 then  cashflow_locks + 8725724278030340 
end
go

update commodity_leg SET cashflow_changed =  case convert(bigint, cashflow_changed) & convert(bigint,power( 2.0,48.0)) 
when 281474976710656 then  cashflow_changed + 8725724278030340 
end
go

update commodity_leg2 SET cashflow_locks =  case convert(bigint, cashflow_locks) & convert(bigint,power( 2.0,48.0)) 
when 281474976710656 then  cashflow_locks + 8725724278030340 
end
go

update commodity_leg2 SET cashflow_changed =  case convert(bigint, cashflow_changed) & convert(bigint,power( 2.0,48.0)) 
when 281474976710656 then  cashflow_changed + 8725724278030340 
end
go
if not exists (select 1 from sysobjects where name ='pk_config_ccypair_exp_owner' and type='U')
begin
exec ('create table pk_config_ccypair_exp_owner(
        primary_ccy varchar(128) not null,
        quoting_ccy varchar(32) not null,
        exposure_type varchar(128) not null,
		risk_category varchar(128) not null,
		operating_zone varchar(128) not null,
        salience numeric not null,
        is_exp_owner_book numeric not null,
        exp_owner_id numeric not null,
        exp_owner_name varchar(255) not null)')
end
go
if not exists (select 1 from sysobjects where name ='pk_config_riskyccy_exp_owner' and type='U')
begin
exec ('create table pk_config_riskyccy_exp_owner(risky_ccy  varchar(128) not null,
exposure_type varchar(128) not null,
risk_category varchar(128) not null,
operating_zone varchar(128) not null,
salience numeric not null,
is_exp_owner_book numeric not null ,
exp_owner_id numeric not null,
exp_owner_name varchar(255) not null)')
end
go

if not exists (select 1 from sysobjects where name ='pk_config_ccyfunding_exp_owner' and type='U')
begin
exec ('create table pk_config_ccyfunding_exp_owner(ccy_ccypair varchar(128) not null,
exposure_type varchar(128) not null,
risk_category varchar(128) not null,
operating_zone varchar(128) not null,
salience numeric not null,
is_exp_owner_book numeric not null,
exp_owner_id numeric not null,
exp_owner_name varchar(255) not null)')
end
go


CREATE PROCEDURE update_pk_configs_owner_ids AS
begin
declare 
@var_book_id int,
@var_cptpty_id int,
@ownername_in_cur varchar(100),
@ccypair_book varchar(100),
@exp_owner_name varchar(200)

declare  cur_ccypair_book CURSOR
	for
		select distinct exp_owner_name from
		pk_config_ccypair_exp_owner
		where is_exp_owner_book=1
		and exp_owner_id = 0

declare  cur_riskyccy_book cursor
	for
		select distinct exp_owner_name from
		pk_config_riskyccy_exp_owner
		where is_exp_owner_book=1
		and exp_owner_id = 0

declare  cur_ccyfunding_book cursor
	for
		select distinct exp_owner_name from
		pk_config_ccyfunding_exp_owner
		where is_exp_owner_book=1
		and exp_owner_id = 0


declare  cur_ccyfunding_ctpty cursor
	for
		select distinct exp_owner_name from
		pk_config_ccyfunding_exp_owner
		where is_exp_owner_book=0
		and exp_owner_id = 0


begin
	
	select @var_book_id = 0
	select @var_cptpty_id = 0
  
	open cur_ccypair_book
    fetch cur_ccypair_book into @exp_owner_name
 while (@@sqlstatus=0)
 begin
			select @ownername_in_cur=@exp_owner_name
	
			begin
				select @var_book_id=book_id from book where book_name=@ownername_in_cur
			end
      
			if @var_book_id > 0 
				begin
					update pk_config_ccypair_exp_owner
					set exp_owner_id=@var_book_id
					where is_exp_owner_book=1
					and @exp_owner_name=@ownername_in_cur
				end
			
		end
	   fetch cur_ccypair_book into @exp_owner_name
 End
 close cur_ccypair_book
deallocate cursor cur_ccypair_book

begin
	select @var_book_id = 0
	select @ownername_in_cur = ''
			
	open cur_riskyccy_book
    fetch cur_riskyccy_book into @exp_owner_name
 while (@@sqlstatus=0)
begin
select @ownername_in_cur=@exp_owner_name
			begin
				select @var_book_id = book_id  from book where book_name=@ownername_in_cur
			end
      
			if @var_book_id > 0 
				begin
					update pk_config_riskyccy_exp_owner
					set exp_owner_id=@var_book_id
					where is_exp_owner_book=1
					and @exp_owner_name=@ownername_in_cur
				
				end
			end 
		  fetch cur_riskyccy_book into @exp_owner_name
 End
 close cur_riskyccy_book
deallocate cursor cur_riskyccy_book 
	
begin	
	select @var_book_id = 0
	select @ownername_in_cur = ''

open cur_ccyfunding_book
	fetch cur_ccyfunding_book into @exp_owner_name
 while (@@sqlstatus=0)
begin
select 	@ownername_in_cur =@exp_owner_name
	
			begin
				select @var_book_id = book_id  from book where book_name=@ownername_in_cur
			end
      
			if @var_book_id > 0 
			begin
					update pk_config_ccyfunding_exp_owner
					set exp_owner_id=@var_book_id
					where is_exp_owner_book=1
					and @exp_owner_name=@ownername_in_cur
					
				end
			end 
		fetch cur_ccyfunding_book into @exp_owner_name
 End
 close cur_ccyfunding_book
deallocate cursor cur_ccyfunding_book 
	
begin
	select @var_cptpty_id = 0
	select @ownername_in_cur = ''

	open cur_ccyfunding_ctpty
	fetch cur_ccyfunding_ctpty into @exp_owner_name
 while (@@sqlstatus=0)
begin
	select @ownername_in_cur=@exp_owner_name
	
	begin
		select @var_cptpty_id = legal_entity_id  from legal_entity where short_name=@ownername_in_cur and le_status='enabled'
	end
	if @var_cptpty_id > 0 
				begin
					update pk_config_ccyfunding_exp_owner
					set exp_owner_id=@var_cptpty_id
					where is_exp_owner_book=0
					and @exp_owner_name=@ownername_in_cur
					
				end
end 
		fetch cur_ccyfunding_ctpty into @exp_owner_name
 End
 close cur_ccyfunding_ctpty
deallocate cursor cur_ccyfunding_ctpty

		
end 
go

exec update_pk_configs_owner_ids
go

drop procedure update_pk_configs_owner_ids
go

UPDATE calypso_info
    SET major_version=15,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date='20160701'
go 


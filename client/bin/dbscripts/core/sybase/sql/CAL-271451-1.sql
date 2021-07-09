add_domain_values 'scheduledTask', 'CHAIN', '' 
go

if not exists (select 1 from sysobjects where type='U' and name='scenario_quoted_product')
begin
exec ('create table scenario_quoted_product (product_name varchar(64) not null, pricer_params varchar(128) null,pricer_measure  varchar(128) not null)')
end
go
UPDATE scenario_quoted_product SET pricer_measure='VOLATILITY_SPREAD' WHERE product_name='Warrant'
go

add_column_if_not_exists 'pl_position','max_settle_date','datetime null'
go

add_column_if_not_exists 'inv_secposition','total_pth_in', 'FLOAT DEFAULT 0 NULL'
go
add_column_if_not_exists 'inv_secposition','daily_pth_in', 'FLOAT DEFAULT 0 NULL'
go
add_column_if_not_exists 'inv_secposition','total_pth_out', 'FLOAT DEFAULT 0 NULL'
go
add_column_if_not_exists 'inv_secposition','daily_pth_out', 'FLOAT DEFAULT 0 NULL'
go
add_column_if_not_exists 'inv_secpos_hist','total_pth_in', 'FLOAT DEFAULT 0 NULL'
go
add_column_if_not_exists 'inv_secpos_hist','daily_pth_in', 'FLOAT DEFAULT 0 NULL'
go
add_column_if_not_exists 'inv_secpos_hist','total_pth_out', 'FLOAT DEFAULT 0 NULL'
go
add_column_if_not_exists 'inv_secpos_hist','daily_pth_out', 'FLOAT DEFAULT 0 NULL'
go

add_column_if_not_exists 'product_cap_floor','reset_date_roll', 'VARCHAR(16) null'
go
add_column_if_not_exists 'inv_secposition','total_loaned_auto', 'FLOAT null'
go

add_column_if_not_exists 'inv_secposition','total_hold_in','float null'
go
add_column_if_not_exists 'inv_secposition','daily_hold_in','float null'
go
add_column_if_not_exists 'inv_secposition','total_hold_out','float null'
go
add_column_if_not_exists 'inv_secposition','daily_hold_out','float null'
go
add_column_if_not_exists 'inv_secposition','account_id','numeric null'
go
add_column_if_not_exists 'inv_secposition','daily_repo_track_in','float null'
go
add_column_if_not_exists 'inv_secposition','total_repo_track_in','float null'
go

add_column_if_not_exists 'inv_secpos_hist','total_hold_in','float null'
go
add_column_if_not_exists 'inv_secpos_hist','daily_hold_in','float null'
go
add_column_if_not_exists 'inv_secpos_hist','total_hold_out','float null'
go
add_column_if_not_exists 'inv_secpos_hist','daily_hold_out','float null'
go
add_column_if_not_exists 'inv_secpos_hist','account_id','numeric null'
go
add_column_if_not_exists 'inv_secpos_hist','daily_repo_track_in','float null'
go
add_column_if_not_exists 'inv_secpos_hist','total_repo_track_in','float null'
go
add_column_if_not_exists 'inv_secpos_hist','daily_loaned_auto', 'float null'
go
add_column_if_not_exists 'inv_secpos_hist','daily_borrowed_auto', 'float null'
go
add_column_if_not_exists 'inv_secpos_hist','total_loaned_auto', 'float null'
go
add_column_if_not_exists 'inv_secpos_hist','total_borrowed_auto', 'float null'
go

add_column_if_not_exists 'inv_secposition','daily_repo_track_out', 'float null'
go
add_column_if_not_exists 'inv_secposition','total_repo_track_out', 'float null'
go
add_column_if_not_exists 'inv_secposition','daily_loaned_auto', 'float null'
go
add_column_if_not_exists 'inv_secposition','daily_borrowed_auto', 'float null'
go
add_column_if_not_exists 'inv_secposition','total_loaned_auto', 'float null'
go
add_column_if_not_exists 'inv_secposition','total_borrowed_auto', 'float null'
go

/* CAL-188642 migrate inventory data model BEGIN */

/* drop tables created ahead of migration date, because migration script was committed too early  */

/* merge live and history tables */
select 
internal_external,position_type,date_type,agent_id,account_id,position_date,security_id,book_id,config_id,
total_security,
daily_security,
total_borrowed,
daily_borrowed,
t_bor_not_avl,
d_bor_not_avl,
total_borrowed_ca,
total_loaned,
daily_loaned,
t_loan_not_avl,
d_loan_not_avl,
total_loaned_ca,
total_coll_in,
daily_coll_in,
t_coll_in_not_avl,
d_coll_in_not_avl,
total_coll_in_ca,
total_coll_out,
daily_coll_out,
t_coll_out_not_avl,
d_coll_out_not_avl,
total_coll_out_ca,
total_pledged_in,
daily_pledged_in,
total_pledged_out,
daily_pledged_out,
daily_coll_out_ca,
daily_coll_in_ca,
total_unavail,
daily_unavail,
total_repo_track_in,
daily_repo_track_in,
total_repo_track_out,
daily_repo_track_out,
total_borrowed_auto,
daily_borrowed_auto,
total_loaned_auto,
daily_loaned_auto,
total_pth_in,
daily_pth_in,
total_pth_out,
daily_pth_out
into migrate_sec_all 
from inv_secposition
union all 
select 
internal_external,position_type,date_type,agent_id,account_id,position_date,security_id,book_id,config_id,
total_security,
daily_security,
total_borrowed,
daily_borrowed,
t_bor_not_avl,
d_bor_not_avl,
total_borrowed_ca,
total_loaned,
daily_loaned,
t_loan_not_avl,
d_loan_not_avl,
total_loaned_ca,
total_coll_in,
daily_coll_in,
t_coll_in_not_avl,
d_coll_in_not_avl,
total_coll_in_ca,
total_coll_out,
daily_coll_out,
t_coll_out_not_avl,
d_coll_out_not_avl,
total_coll_out_ca,
total_pledged_in,
daily_pledged_in,
total_pledged_out,
daily_pledged_out,
daily_coll_out_ca,
daily_coll_in_ca,
total_unavail,
daily_unavail,
total_repo_track_in,
daily_repo_track_in,
total_repo_track_out,
daily_repo_track_out,
total_borrowed_auto,
daily_borrowed_auto,
total_loaned_auto,
daily_loaned_auto,
total_pth_in,
daily_pth_in,
total_pth_out,
daily_pth_out
from inv_secpos_hist
go

/* sum up daily (across old live/history). */
/* the convert to float is there since otherwise the columns will have type number,       */
/* and executesql would then attempt to alter to float. and that would cause an error  */
/* in oracle.                                                                          */


insert  into  inv_sec_movement (internal_external,position_type,date_type,agent_id,account_id,position_date,security_id,book_id,config_id,
 daily_security,daily_borrowed,d_bor_not_avl,
 daily_borrowed_ca,daily_loaned ,d_loan_not_avl,daily_coll_in,
 d_coll_in_not_avl,daily_loaned_ca,daily_coll_out,d_coll_out_not_avl,
 daily_pledged_in,daily_pledged_out,daily_coll_out_ca,
 daily_coll_in_ca,daily_unavail,daily_repo_track_in,
 daily_repo_track_out,daily_borrowed_auto,daily_loaned_auto,daily_pth_in,daily_pth_out,version) 
 select 
internal_external,position_type,date_type,agent_id,account_id,position_date,security_id,book_id,config_id,
convert(float,sum(daily_security)) as daily_security,
convert(float,sum(daily_borrowed)) as daily_borrowed,
convert(float,sum(d_bor_not_avl)) as d_bor_not_avl,
convert(float,0 ) as daily_borrowed_ca,
convert(float,sum(daily_loaned)) as daily_loaned,
convert(float,sum(d_loan_not_avl)) as d_loan_not_avl,
convert(float,sum(daily_coll_in)) as daily_coll_in,
convert(float,sum(d_coll_in_not_avl)) as d_coll_in_not_avl,
convert(float,0 ) as daily_loaned_ca,
convert(float,sum(daily_coll_out)) as daily_coll_out,
convert(float,sum(d_coll_out_not_avl)) as d_coll_out_not_avl,
convert(float,sum(daily_pledged_in)) as daily_pledged_in,
convert(float,sum(daily_pledged_out)) as daily_pledged_out,
convert(float,sum(daily_coll_out_ca)) as daily_coll_out_ca,
convert(float,sum(daily_coll_in_ca)) as daily_coll_in_ca,
convert(float,sum(daily_unavail)) as daily_unavail,
convert(float,sum(daily_repo_track_in)) as daily_repo_track_in,
convert(float,sum(daily_repo_track_out)) as daily_repo_track_out,
convert(float,sum(daily_borrowed_auto)) as daily_borrowed_auto,
convert(float,sum(daily_loaned_auto)) as daily_loaned_auto,
convert(float,sum(daily_pth_in)) as daily_pth_in,
convert(float,sum(daily_pth_out)) as daily_pth_out,
convert(int,0) as version
from migrate_sec_all
group by 
internal_external,position_type,date_type,agent_id,account_id,position_date,security_id,book_id,config_id
go

/* find the most recent position date per position. we initialize the total table from that date's entry */

select  internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id, 
 max(position_date) as total_mig_date
into migrate_sec_bal_date
from migrate_sec_all
where position_date <= getdate() 
group by internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id
go


/* extra case for positions with only future balances */ 
insert into migrate_sec_bal_date(internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id, total_mig_date)
select internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id, min(position_date) 
from migrate_sec_all t1
where not exists (select 1 from migrate_sec_bal_date t2 where 
  t1.internal_external=t2.internal_external
  and t1.position_type=t2.position_type
  and t1.date_type=t2.date_type
  and t1.agent_id=t2.agent_id
  and t1.account_id=t2.account_id
  and t1.security_id=t2.security_id
  and t1.book_id=t2.book_id
  and t1.config_id=t2.config_id) 
group by internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id
go

insert into inv_sec_balance (internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id, position_date,
total_security,
total_borrowed,
t_bor_not_avl,
total_borrowed_ca,
total_loaned,
t_loan_not_avl,
total_loaned_ca,
total_coll_in,
t_coll_in_not_avl,
total_coll_in_ca,
total_coll_out,
t_coll_out_not_avl,
total_coll_out_ca,
total_pledged_in,
total_pledged_out,
total_unavail,
total_repo_track_in,
total_repo_track_out,
total_borrowed_auto,
total_loaned_auto,
total_pth_in,
total_pth_out,
version)
select internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id, position_date,
total_security,
total_borrowed,
t_bor_not_avl,
total_borrowed_ca,
total_loaned,
t_loan_not_avl,
total_loaned_ca,
total_coll_in,
t_coll_in_not_avl,
total_coll_in_ca,
total_coll_out,
t_coll_out_not_avl,
total_coll_out_ca,
total_pledged_in,
total_pledged_out,
total_unavail,
total_repo_track_in,
total_repo_track_out,
total_borrowed_auto,
total_loaned_auto,
total_pth_in,
total_pth_out,
0 as version
from migrate_sec_all t1
where exists (select 1 from migrate_sec_bal_date t2 where 
  t1.internal_external=t2.internal_external
  and t1.position_type=t2.position_type
  and t1.date_type=t2.date_type
  and t1.agent_id=t2.agent_id
  and t1.account_id=t2.account_id
  and t1.security_id=t2.security_id
  and t1.book_id=t2.book_id
  and t1.config_id=t2.config_id
  and t1.position_date = t2.total_mig_date)
go
  
  
/*  ================================================== */
/* now handle cash positions */


select 
internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id,
total_amount,
daily_change
into migrate_cash_all 
from inv_cashposition
union all 
select 
internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id,
total_amount,
daily_change
from inv_cashpos_hist
go

insert into  inv_cash_movement(internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id,
daily_change,version) 
select 
internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id,
convert(float,sum(daily_change) ) as daily_change,
convert(int,0) as version
from migrate_cash_all
group by 
internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id
go

select  internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, 
 max(position_date) as total_mig_date
into migrate_cash_bal_date
from migrate_cash_all
where position_date <= getdate() 
group by internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id
go

insert into migrate_cash_bal_date (internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, total_mig_date )
select internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, min(position_date) 
from migrate_cash_all t1
where not exists (select 1 from migrate_cash_bal_date t2 where 
  t1.internal_external=t2.internal_external
  and t1.position_type=t2.position_type
  and t1.date_type=t2.date_type
  and t1.agent_id=t2.agent_id
  and t1.account_id=t2.account_id
  and t1.currency_code=t2.currency_code
  and t1.book_id=t2.book_id
  and t1.config_id=t2.config_id) 
group by internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id
go

insert into inv_cash_balance (internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, position_date,
total_amount,version) 
select internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, position_date,
total_amount,
0 as version
from migrate_cash_all t1
where exists (select 1 from migrate_cash_bal_date t2 where 
  t1.internal_external=t2.internal_external
  and t1.position_type=t2.position_type
  and t1.date_type=t2.date_type
  and t1.agent_id=t2.agent_id
  and t1.account_id=t2.account_id
  and t1.currency_code=t2.currency_code
  and t1.book_id=t2.book_id
  and t1.config_id=t2.config_id
  and t1.position_date = t2.total_mig_date)
go

drop table migrate_sec_all
go

drop table migrate_cash_all
go

drop table migrate_sec_bal_date
go

drop table migrate_cash_bal_date
go
add_column_if_not_exists 'inv_sec_balance','mcc_id','numeric default 0 null'
go
update inv_sec_balance set mcc_id = config_id, config_id = 0 where (mcc_id is null or mcc_id = 0) and config_id <> 0 and internal_external = 'MARGIN_CALL'
go
add_column_if_not_exists 'inv_cash_balance','mcc_id','numeric default 0 null'
go
update inv_cash_balance set mcc_id = config_id, config_id = 0 where (mcc_id is null or mcc_id = 0) and config_id <> 0 and internal_external = 'MARGIN_CALL'
go
add_column_if_not_exists 'inv_sec_movement','mcc_id','numeric default 0 null'
go
update inv_sec_movement set mcc_id = config_id, config_id = 0 where (mcc_id is null or mcc_id = 0) and config_id <> 0 and internal_external = 'MARGIN_CALL'
go
add_column_if_not_exists 'inv_cash_movement','mcc_id','numeric default 0 null'
go
update inv_cash_movement set mcc_id = config_id, config_id = 0 where (mcc_id is null or mcc_id = 0) and config_id <> 0 and internal_external = 'MARGIN_CALL'
go
begin
declare @cnt int
begin
  select @cnt = count(*) from domain_values where name='EngineServer.instances'
  if( @cnt = 0 ) 
	insert into domain_values (name,value,description) values ('EngineServer.instances','engineserver','Default engine server instance')
	insert into engine_param (engine_name,param_name,param_value) values ('TransferEngine','CLASS_NAME','com.calypso.engine.payment.TransferEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('TransferEngine','DISPLAY_NAME','Transfer Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('TransferEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('TransferEngine','STARTUP','true')

	insert into engine_param (engine_name,param_name,param_value) values ('MessageEngine','CLASS_NAME','com.calypso.engine.advice.MessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('MessageEngine','DISPLAY_NAME','Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('MessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('MessageEngine','STARTUP','true')

	insert into engine_param (engine_name,param_name,param_value) values ('SenderEngine','CLASS_NAME','com.calypso.engine.advice.SenderEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('SenderEngine','DISPLAY_NAME','Sender Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('SenderEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('SenderEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','DISPLAY_NAME','Swift Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','config','Swift')

	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','DISPLAY_NAME','BONY Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','config','GSCC')

	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','DISPLAY_NAME','GSCC Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','config','GSCC')

	insert into engine_param (engine_name,param_name,param_value) values ('PositionEngine','CLASS_NAME','com.calypso.engine.position.PositionEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('PositionEngine','DISPLAY_NAME','Position Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('PositionEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('PositionEngine','STARTUP','true')

	insert into engine_param (engine_name,param_name,param_value) values ('BillingEngine','CLASS_NAME','com.calypso.engine.billing.BillingEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('BillingEngine','DISPLAY_NAME','Billing Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('BillingEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('BillingEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('TaskEngine','CLASS_NAME','com.calypso.engine.task.TaskEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('TaskEngine','DISPLAY_NAME','Task Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('TaskEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('TaskEngine','STARTUP','true')

	insert into engine_param (engine_name,param_name,param_value) values ('MatchableBuilderEngine','CLASS_NAME','com.calypso.engine.matching.MatchableBuilderEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('MatchableBuilderEngine','DISPLAY_NAME','MatchableBuilder Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('MatchableBuilderEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('MatchableBuilderEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('MatchingEngine','CLASS_NAME','com.calypso.engine.matching.MatchingEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('MatchingEngine','DISPLAY_NAME','Matching Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('MatchingEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('MatchingEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('ReutersDssEngine','CLASS_NAME','com.calypso.engine.reutersdss.ReutersDSSEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('ReutersDssEngine','DISPLAY_NAME','ReutersDSS Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('ReutersDssEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('ReutersDssEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('BloombergEngine','CLASS_NAME','com.calypso.engine.bloomberg.BloombergEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergEngine','DISPLAY_NAME','Bloomberg Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','CLASS_NAME','com.calypso.tk.engine.UploadImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','DISPLAY_NAME','Uploader Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','config','Uploader')

	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','CLASS_NAME','com.calypso.tk.engine.DSMatchImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','DISPLAY_NAME','DS Match Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','config','DSMatchFX')

	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','CLASS_NAME','com.calypso.tk.engine.DataUploaderEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','DISPLAY_NAME','DataUploader Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','config','datauploader.properties')

	insert into engine_param (engine_name,param_name,param_value) values ('UploaderPublishEngine','CLASS_NAME','com.calypso.tk.engine.UploaderPublishEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderPublishEngine','DISPLAY_NAME','UploaderPublish Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderPublishEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderPublishEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','CLASS_NAME','com.calypso.tk.engine.ICELinkEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','DISPLAY_NAME','ICELink Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','config','icelink.properties')

	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','CLASS_NAME','com.calypso.engine.bloombergsapi.BloombergSAPIEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','DISPLAY_NAME','BloombergSAPI Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','config','BloombergSAPI')

	insert into engine_param (engine_name,param_name,param_value) values ('ExchangeFeedBridgeEngine','CLASS_NAME','com.calypso.tk.engine.ExchangeFeedBridgeEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('ExchangeFeedBridgeEngine','DISPLAY_NAME','ExchangeFeedBridge Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('ExchangeFeedBridgeEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('ExchangeFeedBridgeEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('SwapswireTradeEngine','CLASS_NAME','com.calypso.engine.advice.SwapswireTradeEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('SwapswireTradeEngine','DISPLAY_NAME','Swapswire Trade Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('SwapswireTradeEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('SwapswireTradeEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','CLASS_NAME','com.calypso.tk.engine.DataUploaderEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','DISPLAY_NAME','TRUploader Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','config','truploader.properties')

	insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','CLASS_NAME','com.calypso.engine.ftp.FTPEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','DISPLAY_NAME','FTP Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('LifeCycleEngine','CLASS_NAME','com.calypso.engine.lifecycle.LifeCycleEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('LifeCycleEngine','DISPLAY_NAME','LifeCycle Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('LifeCycleEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('LifeCycleEngine','STARTUP','true')

	insert into engine_param (engine_name,param_name,param_value) values ('HedgeRelationshipEngine','CLASS_NAME','com.calypso.engine.hedgeRelationship.HedgeRelationshipEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('HedgeRelationshipEngine','DISPLAY_NAME','Hedge Relationship Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('HedgeRelationshipEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('HedgeRelationshipEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('TraxEngine','CLASS_NAME','com.calypso.engine.advice.TraxEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('TraxEngine','DISPLAY_NAME','Trax Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('TraxEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('TraxEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','DISPLAY_NAME','DTCC DS Match Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','config','DTCC')

	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','DISPLAY_NAME','DTCC GTR Rates Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','config','DTCCGTRIntRate')

	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','DISPLAY_NAME','DTCC GTR Credit Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','config','DTCCGTRCredit')

	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','DISPLAY_NAME','DTCC GTR FX Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','config','DTCCGTRFX')

	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','DISPLAY_NAME','CLS Import Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','config','CLS')

	insert into engine_param (engine_name,param_name,param_value) values ('IntexEngine','CLASS_NAME','com.calypso.engine.intex.IntexEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('IntexEngine','DISPLAY_NAME','Intex Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('IntexEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('IntexEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','CLASS_NAME','com.calypso.engine.risk.MarketConformityEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','DISPLAY_NAME','Market Conformity Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','pricingenv','INTRADAY')

	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','CLASS_NAME','com.calypso.engine.risk.IntradayMarketDataEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','DISPLAY_NAME','Intraday Market Data Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','STARTUP','false')
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','pricingenv','INTRADAY')
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','feed','ReutersRFA')

	insert into engine_param (engine_name,param_name,param_value) values ('AccountingEngine','CLASS_NAME','com.calypso.engine.accounting.AccountingEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('AccountingEngine','DISPLAY_NAME','Accounting Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('AccountingEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('AccountingEngine','STARTUP','true')

	insert into engine_param (engine_name,param_name,param_value) values ('BalanceEngine','CLASS_NAME','com.calypso.engine.balance.BalanceEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('BalanceEngine','DISPLAY_NAME','Balance Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('BalanceEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('BalanceEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('CreEngine','CLASS_NAME','com.calypso.engine.accounting.CreEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('CreEngine','DISPLAY_NAME','Cre Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('CreEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('CreEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('CreSenderEngine','CLASS_NAME','com.calypso.engine.accounting.CreSenderEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('CreSenderEngine','DISPLAY_NAME','Cre Sender Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('CreSenderEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('CreSenderEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('PostingSenderEngine','CLASS_NAME','com.calypso.engine.accounting.PostingSenderEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('PostingSenderEngine','DISPLAY_NAME','Posting Sender Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('PostingSenderEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('PostingSenderEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('SenderAccountingEngine','CLASS_NAME','com.calypso.engine.accounting.SenderAccountingEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('SenderAccountingEngine','DISPLAY_NAME','Sender Accounting Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('SenderAccountingEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('SenderAccountingEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('DiaryEngine','CLASS_NAME','com.calypso.engine.diary.DiaryEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('DiaryEngine','DISPLAY_NAME','Diary Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('DiaryEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('DiaryEngine','STARTUP','true')

	insert into engine_param (engine_name,param_name,param_value) values ('InventoryEngine','CLASS_NAME','com.calypso.engine.inventory.InventoryEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('InventoryEngine','DISPLAY_NAME','Inventory Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('InventoryEngine','INSTANCE_NAME','engineserver'	)
	insert into engine_param (engine_name,param_name,param_value) values ('InventoryEngine','STARTUP','true')

	insert into engine_param (engine_name,param_name,param_value) values ('LiquidationEngine','CLASS_NAME','com.calypso.engine.position.LiquidationEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('LiquidationEngine','DISPLAY_NAME','Liquidation Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('LiquidationEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('LiquidationEngine','STARTUP','TRUE')


	insert into engine_param (engine_name,param_name,param_value) values ('PositionKeepingPersistenceEngine','CLASS_NAME','com.calypso.tk.positionkeeping.processing.engine.PositionKeepingPersistenceEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('PositionKeepingPersistenceEngine','DISPLAY_NAME','Position Keeping Persistence Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('PositionKeepingPersistenceEngine','INSTANCE_NAME','positionkeepingserver')
	insert into engine_param (engine_name,param_name,param_value) values ('PositionKeepingPersistenceEngine','STARTUP','true')

	insert into engine_param (engine_name,param_name,param_value) values ('MutationEngine','CLASS_NAME','com.calypso.engine.mutation.MutationEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('MutationEngine','DISPLAY_NAME','Mutation Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('MutationEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('MutationEngine','STARTUP','false')

	insert into engine_param (engine_name,param_name,param_value) values ('IncomingEngine','CLASS_NAME','com.calypso.engine.advice.IncomingMessageEngine')
	insert into engine_param (engine_name,param_name,param_value) values ('IncomingEngine','DISPLAY_NAME','Incoming Message Engine')
	insert into engine_param (engine_name,param_name,param_value) values ('IncomingEngine','INSTANCE_NAME','engineserver')
	insert into engine_param (engine_name,param_name,param_value) values ('IncomingEngine','STARTUP','false')
	
	insert into engine_param (engine_name,param_name,param_value) values ('RelationshipManagerEngine','CLASS_NAME','com.calypso.engine.hedgeaccounting.RelationshipManagerEngine')
    insert into engine_param (engine_name,param_name,param_value) values ('RelationshipManagerEngine','DISPLAY_NAME','Relationship Manager Engine')
    insert into engine_param (engine_name,param_name,param_value) values ('RelationshipManagerEngine','INSTANCE_NAME','engineserver')
    insert into engine_param (engine_name,param_name,param_value) values ('RelationshipManagerEngine','STARTUP','false')
	
	 select @cnt = count(*) from engine_config where engine_name='MarginCallPositionEngine'
	 
	if( @cnt > 0 ) 
		insert into engine_param (engine_name,param_name,param_value) values ('MarginCallPositionEngine','CLASS_NAME','com.calypso.engine.inventory.MarginCallEngine')
		insert into engine_param (engine_name,param_name,param_value) values ('MarginCallPositionEngine','DISPLAY_NAME','Margin Call Engine')
		insert into engine_param (engine_name,param_name,param_value) values ('MarginCallPositionEngine','INSTANCE_NAME','engineserver')
		insert into engine_param (engine_name,param_name,param_value) values ('MarginCallPositionEngine','STARTUP','false')
		
	select @cnt = count(*) from engine_config where engine_name='LiquidityPositionPersistenceEngine'
	 
	if( @cnt > 0 ) 
		insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','CLASS_NAME','com.calypso.tk.liquidity.positionkeeping.processing.engine.LiquidityPositionPersistenceEngine')
		insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','DISPLAY_NAME','Liquidity Server Connector')
		insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','INSTANCE_NAME','liquidityserver')
		insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','STARTUP','false')			
end 

end
go


if not exists (select 1 from domain_values where name = 'PositionKeepingServer.instances')
begin
	INSERT INTO domain_values ( name, value,description ) values ('PositionKeepingServer.instances','positionkeepingserver','')
	INSERT INTO domain_values ( name, value,description ) values ('PositionKeepingServer.instances','liquidityserver','')
end
go



delete from engine_config where engine_name = 'ImportMessageEngine'
go
delete from domain_values  where value = 'ImportMessageEngine' and name ='applicationName'
go
delete from domain_values where value = 'ImportMessageEngine' and name='engineName'
go
delete from engine_param where engine_name = 'ImportMessageEngine'
go
delete from ps_event_config where engine_name ='ImportMessageEngine'
go

delete from engine_config where engine_name = 'LimitEngine'
go
delete from domain_values  where value = 'LimitEngine' and name ='applicationName'
go
delete from domain_values where value = 'LimitEngine' and name='engineName'
go
delete from engine_param where engine_name = 'LimitEngine'
go
delete from ps_event_config where engine_name ='LimitEngine'
go

begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='TaskEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'TaskEngine','Task Engine' )
end
end
go

begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='LiquidityPositionPersistenceEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'LiquidityPositionPersistenceEngine','Liquidity Server Connector' )
end
end
go 

/* changed insert to update */
      
update referring_object set rfg_tbl_name='quartz_sched_task' ,rfg_obj_window='apps.scheduling.ScheduledTaskListWindow' 
where rfg_tbl_name='sched_task'
go
       
insert into report_win_def (win_def_id,def_name,use_book_hrchy,use_pricing_env, use_color) values (3550,'OfficialPLMark',0,0,0)
go

delete from domain_values where name='function' and value='AdmSaveEngineThread'
go

delete from group_access where access_value ='AdmSaveEngineThread'
go

/*  CAL-219349 */
add_domain_values  'keyword.TerminationReason.IslamicMM','Manual',''
go
add_domain_values  'keyword.TerminationReason.IslamicMM','BoughtBack',''
go
add_domain_values  'productTypeReportStyle','IslamicMM','IslamicMM ReportStyle'
go
add_domain_values  'productTypeReportStyle','IslamicUnderlying','IslamicUnderlying ReportStyle'
go
add_domain_values  'MESSAGE.Templates','islamicmm.html',''
go
add_domain_values  'domainName','IslamicMM.UnderlyingName','Underlying names for IslamicMM'
go
add_domain_values  'domainName','IslamicMM.LoanName','Names for IslamicMM loan'
go
add_domain_values  'IslamicMM.LoanName','Tawaruq','Default name for IslamicMM loan'
go
add_domain_values  'IslamicMM.LoanName','Murabaha',''
go
add_domain_values  'domainName','IslamicMM.DepositName','Names for IslamicMM deposit'
go
add_domain_values  'IslamicMM.DepositName','Isra','Default name for IslamicMM deposit'
go
add_domain_values  'IslamicMM.DepositName','Murabaha',''
go
  
select * into main_entry_prop_bak141 from main_entry_prop
go

update main_entry_prop set property_value = 'am.structure.FundWindow' where property_value = 'fund.FundWindow'
go

if exists (Select 1 from sysobjects where name ='mainent_schd' and type='P')
begin
exec ('drop proc mainent_schd')
end
go

create  procedure mainent_schd as 
begin
declare
  c1 cursor for 
  select property_name, user_name,substring(property_name,1,charindex('Action',property_name)-1),
  property_value from main_entry_prop where (property_value = 'util.EventConfigWindow' or property_value = 'Event...' or property_value ='refdata.EngineConfigWindow' or property_value = 'Engine...')
  and charindex('Action',property_name)>0
 
OPEN c1
declare   @prefix_code varchar(16)
declare   @prop_value varchar(256)
declare   @user_name varchar(255)
declare   @property_name varchar(255)

fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

WHILE (@@sqlstatus = 0)

begin

    delete from main_entry_prop where property_name like   
	@prefix_code+'%' and user_name =@user_name and ( property_value='util.EventConfigWindow' or property_value = 'Event...' or property_value ='refdata.EngineConfigWindow' or property_value = 'Engine...')
    
fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

end
close c1
deallocate cursor c1
end
go
exec mainent_schd
go
drop proc mainent_schd
go

add_column_if_not_exists 'cds_settlement_matrix','isda_agreement' ,'varchar(32) null'
go

update cds_settlement_matrix set isda_agreement='2003' where isda_agreement is null
go		

if exists (select 1 from sysindexes  
           where id = object_id('model_calibration_instrument') and name like '%ct_primarykey%')
begin 
     execute ('ALTER TABLE model_calibration_instrument DROP CONSTRAINT ct_primarykey')
end
go 
if exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'model_calibration_instrument' and syscolumns.name = 'underlying')
begin
exec ('alter table model_calibration_instrument modify underlying NULL')
end
go
	
if not exists (select 1 from sysobjects where name='trade_open_qty' and type='U')
begin
exec ('create table trade_open_qty (
trade_id numeric not null,
product_id numeric not null,
settle_date datetime not null,
trade_date datetime not null,
quantity float null,
open_quantity float null,
price float null,
accrual float null,
open_repo_quantity float null,
book_id numeric null,
product_family varchar(32) null,
product_type varchar(32) null,
sign numeric null,
is_liquidable numeric null,
is_return numeric null,
return_date datetime null,
entered_date datetime null,
ca_id numeric null,
yield float null,
liq_agg_id numeric null,
position_id numeric null,
trade_version numeric null,
liq_config_id numeric null)')
end
go

if not exists (select 1 from sysobjects where name='trade_openqty_snap' and type='U')
begin
exec ('create table trade_openqty_snap (trade_id numeric null,
       product_id numeric null,
       settle_date datetime null,
       trade_date datetime null,
       quantity float null,
       open_quantity float null,
       price float null,
       accrual float null,
       open_repo_quantity float null,
       book_id numeric null,
       product_family  varchar(32) null,
       product_type  varchar(32) null,
       sign numeric null,
       is_liquidable  numeric null,
       is_return  numeric null,
       return_date datetime null,
       entered_date datetime null,
       ca_id numeric null,
       yield float null,
       liq_agg_id numeric null,
       position_id numeric null,
       trade_version numeric null ,
       liq_config_id numeric null ,
	   snapshot_date datetime null)')
end
go

if not exists (select 1 from sysobjects where name='pl_position_snap' and type='U')
begin
exec ('create table pl_position_snap (product_id  numeric  null,
       book_id  numeric  null,
       realized float null,
       unrealized float null,
       last_liq_date datetime null,
       last_average_price float null,
       current_avg_price float null,
       last_liq_id numeric null,
       liq_buy_quantity float null,
       liq_sell_quantity float null,
       liq_buy_amount float null,
       liq_sell_amount float null,
       liq_buy_accrual float null,
       liq_sell_accrual float null,
       total_interest float null,
       last_archive_id numeric  null,
       last_arch_date datetime null,
       version_num numeric  null,
       liq_agg_id  numeric  null,
       position_id  numeric  null,
       total_prem_disc float null,
       total_prem_disc_yield float null,
       total_principal float null,
       last_trade_date datetime null,
       incep_trade_date datetime null,
       entered_date datetime null,
       liq_config_id  numeric  null,
		last_settle_date datetime null,
       max_settle_date datetime null,
       last_updated_time datetime null,
	   snapshot_date datetime null)')
end
go
 
update trade_open_qty
set book_id = pl_position.book_id from pl_position where pl_position.position_id=trade_open_qty.position_id and 
trade_open_qty.book_id IS NULL or trade_open_qty.book_id = 0
go
update liq_position
set book_id = pl_position.book_id from pl_position where pl_position.position_id=liq_position.position_id and 
liq_position.book_id IS NULL or liq_position.book_id = 0
go
update trade_openqty_hist
set book_id = pl_position_hist.book_id from pl_position_hist where pl_position_hist.position_id=trade_openqty_hist.position_id and 
trade_openqty_hist.book_id IS NULL or trade_openqty_hist.book_id = 0
go
update liq_position_hist
set book_id = pl_position_hist.book_id from pl_position_hist where pl_position_hist.position_id=liq_position_hist.position_id and 
liq_position_hist.book_id IS NULL or liq_position_hist.book_id = 0
go
update trade_openqty_snap
set book_id = pl_position_snap.book_id from pl_position_snap where pl_position_snap.position_id=trade_openqty_snap.position_id and 
trade_openqty_snap.book_id IS NULL or trade_openqty_snap.book_id = 0
go

/* diff starts here */

if not exists (select 1 from sysobjects where type='U' and name='sql_blacklist_properties')
begin
exec ('create table sql_blacklist_properties (name varchar(255) not null, value varchar(255) not null)')
end
go

INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('Benchmark','apps.risk.BenchmarkJideViewer',0 )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('OfficialPL','apps.risk.OfficialPLAnalysisReportFrameworkViewer',0 )
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('OfficialPL Treatment','Indicates whether this book is included or excluded from the Official PL. By default book is included.' )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'markdata',500 )
go
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.reporting.PositionTypeDefinitionDialog' )
go
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.refdata.WorkFlowJFrame' )
go
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.refdata.WorkflowGraphJFrame' )
go
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (12,'LimitEngine','' )
go
 
add_domain_values  'domainName','ExcludePriceFixingsProduct','Products that will skip PL Explain Price Fixing Reset Effect.' 
go
add_domain_values  'ExcludePriceFixingsProduct','Equity','' 
go
add_domain_values  'ExcludePriceFixingsProduct','ADR','' 
go
add_domain_values  'ExcludePriceFixingsProduct','Warrant','' 
go
add_domain_values  'ExcludePriceFixingsProduct','Certificate','' 
go
add_domain_values  'ExcludePriceFixingsProduct','CFD','' 
go
add_domain_values  'ExcludePriceFixingsProduct','BondExoticNote','' 
go
add_domain_values  'ExcludePriceFixingsProduct','FutureOptionEquity','' 
go
add_domain_values  'ExcludePriceFixingsProduct','FutureOptionEquityIndex','' 
go
add_domain_values  'ExcludePriceFixingsProduct','FutureOptionVolatility','' 
go
add_domain_values  'ExcludePriceFixingsProduct','FutureOptionDividend','' 
go
add_domain_values  'ExcludePriceFixingsProduct','FutureEquity','' 
go
add_domain_values  'ExcludePriceFixingsProduct','FutureEquityIndex','' 
go
add_domain_values  'ExcludePriceFixingsProduct','FutureVolatility','' 
go
add_domain_values  'ExcludePriceFixingsProduct','FutureDividend','' 
go
add_domain_values  'ExcludePriceFixingsProduct','ETOEquity','' 
go
add_domain_values  'ExcludePriceFixingsProduct','ETOEquityIndex','' 
go
add_domain_values  'ExcludePriceFixingsProduct','ETOVolatility','' 
go
add_domain_values  'ExcludePriceFixingsProduct','CorrelationSwap','' 
go
add_domain_values  'ExcludePriceFixingsProduct','ScriptableOTCProduct','' 
go
add_domain_values  'ExcludePriceFixingsProduct','EquityStructuredOption','' 
go
add_domain_values  'ExcludePriceFixingsProduct','EquityLinkedSwap','' 
go
add_domain_values  'ExcludePriceFixingsProduct','VarianceSwap','' 
go
add_domain_values  'ExcludePriceFixingsProduct','VarianceOption','' 
go
add_domain_values  'ExcludePriceFixingsProduct','EquityForward','' 
go
add_domain_values  'creditEventType','GOVERNMENT INTERVENTION','' 
go
add_domain_values  'isdaCDSAgreement','2014','' 
go
add_domain_values  'cdsAdditionalProvisions','Financial Reference Entity Terms','' 
go
add_domain_values  'cdsAdditionalProvisions','2014 CoCo Supplement to the 2014 ISDA Credit Derivatives Defs','' 
go
add_domain_values  'cdsAdditionalProvisions','Subordinated European Insurance Terms','' 
go
add_domain_values  'cdsAdditionalProvisions','2014 Asset Package Delivery','' 
go
add_domain_values  'cdsPmtLagType','As per Section 8.6 of the 2003 Definitions','' 
go
add_domain_values  'cdsPmtLagType','Section 8.6 2003goNot to exceed thirty business days','' 
go
add_domain_values  'cdsPmtLagType','As per Section 8.19 of the 2014 Definitions','' 
go
add_domain_values  'cdsPmtLagType','Section 8.19 2014goNot to exceed thirty business days','' 
go
add_domain_values  'domainName','FutureOptionEquity.Pricer','Pricers for FutureOptionEquity' 
go
add_domain_values  'domainName','FutureOptionEquityIndex.Pricer','Pricers for FutureOptionEquityIndex' 
go
add_domain_values  'domainName','SubscripRedemp.subtype','Types of Subscription Redemption' 
go
add_domain_values  'domainName','ContribWithdraw.subtype','Types of Contribution Withdrawal' 
go
add_domain_values  'domainName','ModelCalibrator','Model Calibrator' 
go
add_domain_values  'ModelCalibrator','LMM','Libor Market Model Calibrator' 
go
add_domain_values  'ModelCalibrator','LMMMultiCurrency','Libor Market Model Calibrator for multi-ccy model' 
go
add_domain_values  'PositionBasedProducts','ShareClass','Share Class product' 
go
add_domain_values  'PositionBasedProducts','Series','Series product' 
go
add_domain_values  'classAuditMode','ShareClass','' 
go
add_domain_values  'classAuditMode','Series','' 
go
add_domain_values  'classAuditMode','Mandate','' 
go
add_domain_values  'classAuditMode','SubscripRedemp','' 
go
add_domain_values  'classAuditMode','ContribWithdraw','' 
go
add_domain_values  'keywords2CopyUponExercise','CCPCollateralPolicy','All keywords specified for this domain name will be copied over to the resulting trade when an option is exercised' 
go
add_domain_values  'productType','ShareClass','' 
go
add_domain_values  'productType','Series','' 
go
add_domain_values  'productType','Mandate','' 
go
add_domain_values  'productType','SubscripRedemp','' 
go
add_domain_values  'productType','ContribWithdraw','' 
go
add_domain_values 'domainName','bookAttribute.OfficialPL Treatment','' 
go
add_domain_values 'bookAttribute.OfficialPL Treatment','Exclude','' 
go
add_domain_values  'tradeKeyword','OfficialPL Treatment','Indicates whether this OTC trade is included or excluded from the Official PL. By default trade is included.' 
go
add_domain_values  'domainName','keyword.OfficialPL Treatment','' 
go
add_domain_values  'keyword.OfficialPL Treatment','Unrealized Only','' 
go
add_domain_values  'keyword.OfficialPL Treatment','Exclude','' 
go
add_domain_values  'FutureOptionEquityIndex.Pricer','PricerBlack1FAnalyticDiscreteVanilla','Analytic Black-Scholes pricer for european options using discrete (escrowed dividend or continuous yield' 
go
add_domain_values  'FutureOptionEquityIndex.Pricer','PricerBlack1FFiniteDifference','Finite difference pricer for american or european options' 
go
add_domain_values  'FutureOptionEquity.Pricer','PricerBlack1FAnalyticDiscreteVanilla','European Analytic Pricer following the Black-Scholes model' 
go
add_domain_values  'FutureOptionEquity.Pricer','PricerBlack1FFiniteDifference','Finite Difference Pricer for single asset european or american or bermudan option' 
go
add_domain_values  'SubscripRedemp.subtype','Subscription','Subscription' 
go
add_domain_values  'SubscripRedemp.subtype','Redemption','Redemption' 
go
add_domain_values  'ContribWithdraw.subtype','Contribution','Contribution' 
go
add_domain_values  'ContribWithdraw.subtype','Withdrawal','Withdrawal' 
go
add_domain_values  'engineName','LimitEngine','' 
go
add_domain_values  'eventClass','PSEventRiskOutputChange','' 
go
add_domain_values  'riskAnalysis','Benchmark','Benchmark Analysis' 
go
add_domain_values  'riskAnalysis','WhatIf','WhatIf Analysis' 
go
add_domain_values  'scheduledTask','AM_UPDATE_SR_TRADES_FX_EXPOSURE','' 
go
add_domain_values  'applicationName','ImportMessageEngine','ImportMessageEngine' 
go
add_domain_values  'riskPresenter','Benchmark','Benchmark Analysis' 
go
add_domain_values  'MTMFeeType','CASH_SETTLE_FEE','' 
go
add_domain_values  'domainName','engineserver.types','Different types of engine servers' 
go
add_domain_values  'domainName','engineserver.unmanaged.types','Different types of unmanaged engine servers' 
go
add_domain_values  'domainName','EngineServer.instances','Instances for each engineserver' 
go
add_domain_values  'domainName','PositionKeepingServer.instances','Specific engines which can only be ran on positionkeepingserver' 
go
add_domain_values  'domainName','PositionKeepingServer.engines','Specific engines which can only be ran on positionkeepingserver' 
go
add_domain_values  'engineParam','CLASS_NAME','Class name for a given engine' 
go
add_domain_values  'engineParam','INSTANCE_NAME','Instance which an engine should belong to' 
go
add_domain_values  'engineParam','STARTUP','Whether an engine should start on a given instance' 
go
add_domain_values  'engineParam','DISPLAY_NAME','The name which an engine should be displayed with on the engine manager' 
go
add_domain_values  'engineserver.types','EngineServer','Default location of all engines' 
go
add_domain_values  'engineserver.types','PositionKeepingServer','Engines dealing with keeping positions' 
go
add_domain_values  'engineserver.unmanaged.types','PositionKeepingServer','Engines dealing with keeping positions' 
go
add_domain_values  'engineParam','config','Configuration for engines' 
go
add_domain_values  'PositionKeepingServer.engines','PositionKeepingPersistenceEngine','' 
go
/* diff from other modules */

add_domain_values  'PositionKeepingServer.engines','LiquidityPositionPersistenceEngine','' 
go
add_domain_values  'scheduledTask','UNLOAD_SAVED_CALCULATIONSERVER','pre-saved analysis output on calculation server'
go

add_domain_values  'domainName','DTCCGTR_Collateral_Version','The DTCC collateral module version (to be include in message sent to DTCC)' 
go

add_domain_values  'DTCCGTR_Collateral_Version','Coll1.0','The DTCC collateral module version (to be include in message sent to DTCC)'
go

add_domain_values  'REPORT.Types','DTCCGTRCollateralLink','' 
go

add_domain_values  'REPORT.Types','DTCCGTRCollateralValue','' 
go
add_domain_values  'REPORT.Types','DTCCGTRCollateralAggregatedValue','' 
go
add_domain_values  'DTCCGTR.Templates','CDSIndexTranche_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSNthLoss_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSNthLoss_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CreditDefaultIndex_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CreditDefaultSwap_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CreditDefaultIndex_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSNthDefault_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CreditDefaultSwap_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSIndexTranche_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSNthDefault_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FRA_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','IRSwap_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','IRSwap_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CapFloor_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','IRSExotic_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FRA_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','Swaption_NovationTrade_PET.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CapFloor_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','IRSExotic_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','Swaption_NovationTrade_Confirm.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FXO_Exotic_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FX_SingleLeg_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FX_Option_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CreditDefaultIndex_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSNthDefault_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CreditDefaultSwap_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSNthLoss_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSIndexTranche_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','Swaption_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CapFloor_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FRA_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','IRSwap_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','IRSExotic_Amendment_RT.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FX_SingleLeg_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FX_Option_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FXO_Exotic_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSNthDefault_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CreditDefaultIndex_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSNthLoss_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CreditDefaultSwap_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CDSIndexTranche_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','Swaption_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','FRA_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','IRSExotic_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','IRSwap_Amendment_Snapshot.xml','' 
go
add_domain_values  'DTCCGTR.Templates','CapFloor_Amendment_Snapshot.xml','' 
go
add_domain_values  'workflowRuleTrade','DTCCGTRSetDFAReportingParty','sets the ReportingParty keyword on the trade' 
go
add_domain_values  'workflowRuleTrade','DTCCGTRSetDFANovationFeeReportingParty','sets the NovationFeeReportingParty keyword on the trade' 
go
add_domain_values  'workflowRuleTrade','DTCCGTRSetUTI','sets the UTI keywords on the trade' 
go
add_domain_values  'workflowRuleTrade','DTCCGTRSetEmirUTIGeneratingParty','sets the EMIR UTI Generating Party' 
go
add_domain_values  'workflowRuleTrade','DTCCGTRSetEmirReportingRegime','sets the EMIR reporting regime if not already set' 
go
add_domain_values  'workflowRuleTrade','DTCCGTRSetReportingRegimes','sets the EMIR and Dodd-Frank reporting regimes if not already set' 
go
add_domain_values  'workflowRuleTrade','DTCCGTRSetNovationChildType','sets the type of novations children trades' 
go
add_domain_values  'workflowRuleTrade','DTCCGTRRetract','Used to RETRACT from a TERMINATION, EXERCISE, EXPIRATION or CANCELATION' 
go
add_domain_values  'domainName','DTCCGTRRemoveSubActionMessageRule','This domain lists the static data filters that must be validated for triggering the message rule DTCCGTRRemoveSubAction' 
go
add_domain_values  'CustomStaticDataFilter','DTCCGTR','Static Data Filter specific to DTCCGTR' 
go
add_domain_values  'DTCC-GTR-RelevantJurisdictionsByPurpose','RT','CFTC' 
go
add_domain_values  'DTCC-GTR-RelevantJurisdictionsByPurpose','PET','CFTC' 
go
add_domain_values  'DTCC-GTR-RelevantJurisdictionsByPurpose','Confirm','CFTC' 
go
add_domain_values  'DTCC-GTR-RelevantJurisdictionsByPurpose','Snapshot','CFTC,ESMA' 
go
add_domain_values  'DTCC-GTR-RelevantJurisdictionsByPurpose','RT-PET','CFTC' 
go
add_domain_values  'DTCC-GTR-RelevantJurisdictionsByPurpose','PET-Confirm','CFTC' 
go
add_domain_values  'DTCC-GTR-RelevantJurisdictionsByPurpose','RT-PET-Confirm','CFTC' 
go
add_domain_values  'DTCC-GTR-TradeRetractableStatus','CANCELED','' 
go
add_domain_values  'multiMessageFormatType','DTCCGTR','DTCCGTR must generate multiple messages for FXSwap' 
go
add_domain_values  'domainName','InventorySecBucketFactory','' 
go
add_domain_values  'InventorySecBucketFactory','ProductSubtypePersistent','New position balance types driven by trade subtypes' 
go
add_domain_values  'scheduledTask','EOD_OFFICIALPL','End of day OfficialPLAnalysis Marking.' 
go
add_domain_values  'scheduledTask','OFFICIALPLBOOTSTRAP','BootStrap process marking.' 
go
add_domain_values  'scheduledTask','OFFICIALPLCORRECTIONS','OfficialPLAnalysis Marking Corrections.' 
go
add_domain_values  'scheduledTask','OFFICIALPLPURGEMARKS','OfficialPLAnalysis Purge Marks.' 
go
add_domain_values  'scheduledTask','OFFICIALPLEXPORT','OfficialPLAnalysis Export Report.' 
go
add_domain_values  'scheduledTask','PL_GREEKS_INPUT','Scheduled task to create greeks for Live PL.' 
go
add_domain_values  'riskAnalysis','OfficialPL','' 
go
add_domain_values  'reportWindowPlugins:tradeBrowser','SecFinanceTradeReportExtension','' 
go
add_domain_values  'riskPresenter','OfficialPL','OfficialPL Analysis' 
go
add_domain_values  'function','CreateModifyOfficialPLConfig','Allow User to Add/Modify/delete OfficialPLConfig' 
go
add_domain_values  'function','ViewOfficialPLConfig','Allow User to view any OfficialPLConfig' 
go
add_domain_values  'function','RemoveResetPLConfig','Allow User to delete OfficialPLConfig Marks' 
go
add_domain_values  'function','ViewResetPLConfig','Allow User to view ResetPLConfig' 
go
add_domain_values  'plMeasure','Unrealized_MTM_PnL','' 
go
add_domain_values  'plMeasure','Unrealized_Accrual_PnL','' 
go
add_domain_values  'plMeasure','Unrealized_Accretion_PnL','' 
go
add_domain_values  'plMeasure','Unrealized_Other_PnL','' 
go
add_domain_values  'plMeasure','Realized_MTM_PnL','' 
go
add_domain_values  'plMeasure','Realized_Accrual_PnL','' 
go
add_domain_values  'plMeasure','Realized_Other_PnL','' 
go
add_domain_values  'plMeasure','Unrealized_PnL_Base','' 
go
add_domain_values  'plMeasure','Realized_PnL_Base','' 
go
add_domain_values  'plMeasure','Unrealized_MTM_PnL_Base','' 
go
add_domain_values  'plMeasure','Unrealized_Accrual_PnL_Base','' 
go
add_domain_values  'plMeasure','Unrealized_Accretion_PnL_Base',''
go
add_domain_values  'plMeasure','Unrealized_Other_PnL_Base',''
go
add_domain_values  'plMeasure','Realized_MTM_PnL_Base',''
go
add_domain_values  'plMeasure','Realized_Accrual_PnL_Base',''
go
add_domain_values  'plMeasure','Realized_Accretion_PnL_Base',''
go
add_domain_values  'plMeasure','Realized_Other_PnL_Base',''
go
add_domain_values  'PricerMeasurePnlAllEOD','UnrealizedMTM',''
go
add_domain_values  'PricerMeasurePnlAllEOD','UnrealizedAccrual',''
go
add_domain_values  'PricerMeasurePnlAllEOD','UnrealizedAccretion',''
go
add_domain_values  'PricerMeasurePnlAllEOD','UnrealizedOther',''
go
add_domain_values  'PricerMeasurePnlAllEOD','RealizedMTM',''
go
add_domain_values  'PricerMeasurePnlAllEOD','RealizedAccrual',''
go
add_domain_values  'PricerMeasurePnlAllEOD','RealizedAccretion',''
go
add_domain_values  'PricerMeasurePnlAllEOD','RealizedOther',''
go
add_domain_values  'engineserver.types','ERSLimitServer','ERS Limit Server Engine Container'
go
add_domain_values  'engineserver.types','ERSRiskServer','ERS Risk Server Engine Container'
go
add_domain_values  'CollateralExposure.subtype','PAI',''
go
add_domain_values  'CollateralExposure.subtype','Maintenance Fee',''
go
add_domain_values  'CollateralExposure.subtype','Swap Exposure',''
go
add_domain_values  'tradeKeyword','VM_CASH_OFFSET',''
go
add_domain_values  'tradeKeyword','CET_Subtype',''
go
add_domain_values  'tradeKeyword','optimizationConfig',''
go
add_domain_values  'legalAgreementType','VM',''
go
add_domain_values  'legalAgreementType','IM',''
go
add_domain_values  'eventClass','PSEventCollateralEngineCommand',''
go
add_domain_values  'classAuthMode','LiabilityGroupContext',''
go
add_domain_values  'classAuditMode','LiabilityGroupContext',''
go
add_domain_values  'classAuthMode','CollateralConfig',''
go
add_domain_values  'classAuditMode','CollateralConfig',''
go
add_domain_values  'function','RemoveMarginCallCreditRating','Access permission to remove MarginCallCreditRating'
go
add_domain_values  'function','CreateMarginCallCreditRating','Access permission to create MarginCallCreditRating'
go
add_domain_values  'function','AuthorizeCollateralConfig','Access permission to authorize Collateral Config'
go
add_domain_values  'function','ModifyCollateralConfig','Access permission to modify Collateral Config'
go
add_domain_values  'function','CreateCollateralConfig','Access permission to create Collateral Config'
go
add_domain_values  'function','RemoveCollateralConfig','Access permission to remove Collateral Config'
go
add_domain_values  'mccAdditionalField','ACCOUNT_NAME','Contains the account name'
go
add_domain_values  'domainName','mccAdditionalField.EXCLUDE_SECLENDING_INTEREST',''
go
add_domain_values  'mccAdditionalField.EXCLUDE_SECLENDING_INTEREST','True',''
go
add_domain_values  'mccAdditionalField.EXCLUDE_SECLENDING_INTEREST','False',''
go
add_domain_values  'domainName','CollateralContext.DEFAULT_LOAD_METHOD',''
go
add_domain_values  'CollateralContext.DEFAULT_LOAD_METHOD','LOAD_METHOD_SIMPLE',''
go
add_domain_values  'CollateralContext.DEFAULT_LOAD_METHOD','LOAD_METHOD_REFRESH_SIMPLE',''
go
add_domain_values  'CollateralContext.DEFAULT_LOAD_METHOD','LOAD_METHOD_FULL',''
go
add_domain_values  'CollateralContext.DEFAULT_LOAD_METHOD','LOAD_METHOD_REFRESH_FULL',''
go
add_domain_values  'domainName','Collateral.Pool.Constraint',''
go
add_domain_values  'Collateral.Optimization.AllocationRule','Collateral-Source',''
go
add_domain_values  'Collateral.Optimization.Constraint','CollateralPool',''
go
add_domain_values  'Collateral.Optimization.Constraint','Source',''
go
add_domain_values  'Collateral.Pool.Constraint','Coupon',''
go
add_domain_values  'Collateral.Pool.Constraint','Dividend',''
go
add_domain_values  'Collateral.Pool.Constraint','MaximumUsage',''
go
add_domain_values  'Collateral.Pool.Constraint','SDFilter',''
go
add_domain_values  'Collateral.Pool.Constraint','Volatility',''
go
add_domain_values  'domainName','NPVFlows','MTM flows that, among other things, require different transfer available date logic '
go
add_domain_values  'NPVFlows','NPV_ADJUSTED',''
go
add_domain_values  'securityCode','SFR-8A','A value of  True  designates this fund to SFR-8A column.'
go
add_domain_values  'securityCode','SFR-8B','A value of  True  designates this fund to SFR-8B column.'
go
add_domain_values  'securityCode','Collateral Investment','A value of  False  designates this fund to SFR-8C column.'
go
add_domain_values  'FundAttributes','SFR-8A','A value of  True  designates this fund to SFR-8A column.'
go
add_domain_values  'FundAttributes','SFR-8B','A value of  True  designates this fund to SFR-8B column.'
go
add_domain_values  'FundAttributes','Collateral Investment','A value of  False  designates this fund to SFR-8C column.'
go
add_domain_values  'domainName','SFR7BMovementType','Inventory movement types to be considered when computing the SFR 7B'
go
add_domain_values  'domainName','SFR7CMovementType','Inventory movement types to be considered when computing the SFR 7C'
go
add_domain_values  'domainName','SFR7CBookType','Book types to be considered when computing the SFR 7C' 
go
add_domain_values  'classAuthMode','ClientOnboardingData','' 
go
add_domain_values  'function','CreateModifyOnboardingTemplate','' 
go
add_domain_values  'function','ModifyOnboardingTemplate','' 
go
add_domain_values  'function','CreateOnboardingObjects','' 
go
add_domain_values  'function','AuthorizeClientOnboardingData','Access Permissions function for authorizing ClientOnboardingData objects' 
go
add_domain_values  'domainName','NPVReversalFlows','Reversal equivalents of NPVFlows' 
go
add_domain_values  'tradeKeyword','CCPSegregationAccount','' 
go
add_domain_values  'MirrorKeywords','CCPSegregationAccount','' 
go
add_domain_values  'leAttributeType','LCHCVRSenderCode','' 
go
add_domain_values  'leAttributeType','CFTCReporting','' 
go
add_domain_values  'accountProperty','Description','' 
go
add_domain_values  'accountProperty.Description','Clearing','' 
go
add_domain_values  'accountProperty.Description','Cash','' 
go
add_domain_values  'accountProperty.Description','Internal','' 
go
add_domain_values  'accountProperty.ClearingCashAccount','True','' 
go
add_domain_values  'accountProperty.ClearingCashAccount','False','' 
go
add_domain_values  'currencyDefaultAttribute','ClearingTransferSettleLag','' 
go
add_domain_values  'currencyDefaultAttribute','ClearingTransferSettleLag','' 
go
add_domain_values  'domainName','ClearingEligible','' 
go
add_domain_values  'currencyDefaultAttribute','ClearingEligible','' 
go
add_domain_values  'ClearingEligible','True','' 
go
add_domain_values  'ClearingEligible','False','' 
go
add_domain_values  'domainName','Clearing.Settlement.Ignore105','' 
go
add_domain_values  'scheduledTask','CLEARING_MCC_CCY_UPGRADE','' 
go
add_domain_values  'scheduledTask','CLEARING_ETD_VM','' 
go
add_domain_values  'eventType','EX_CLEARING_MCC_CCY_UPGRADE','' 
go
add_domain_values  'eventType','EX_CLEARING_MCC_CCY_UPGRADE_WARNING','' 
go
add_domain_values  'eventType','EX_CLEARING_INTRADAY_MARGIN_WARNING','' 
go
add_domain_values  'eventType','EX_CLEARING_INTRADAY_SETTLEMENT_WARNING','' 
go
add_domain_values  'eventType','EX_CLEARING_IMPORT_MARKET_DATA_WARNING','' 
go
add_domain_values  'eventType','EX_CLEARING_IMPORT_SCENARIO_SHIFTS_WARNING','' 
go
add_domain_values  'eventType','EX_CLEARING_INITIALIZE_TENORS_TABLE','' 
go
add_domain_values  'eventType','EX_CLEARING_INITIALIZE_TENORS_TABLE_WARNING','' 
go
add_domain_values  'eventType','EX_CLEARING_EXPORT_CVR_WORKSHEET_WARNING','' 
go
add_domain_values  'eventType','EX_CLEARING_IM_ACCT_UPGRADE_WARNING','' 
go
add_domain_values  'eventType','EX_CLEARING_EXCEPTION','' 
go
add_domain_values  'eventType','EX_CLEARING_INFO','' 
go
add_domain_values  'exceptionType','CLEARING_INTRADAY_SETTLEMENT_WARNING','' 
go
add_domain_values  'exceptionType','CLEARING_MCC_CCY_UPGRADE','' 
go
add_domain_values  'exceptionType','CLEARING_MCC_CCY_UPGRADE_WARNING','' 
go
add_domain_values  'exceptionType','CLEARING_IMPORT_MARKET_DATA_WARNING','' 
go
add_domain_values  'exceptionType','CLEARING_EXPORT_CVR_WORKSHEET_WARNING','' 
go
add_domain_values  'exceptionType','CLEARING_IMPORT_SCENARIO_SHIFTS_WARNING','' 
go
add_domain_values  'exceptionType','CLEARING_INITIALIZE_TENORS_TABLE_WARNING','' 
go
add_domain_values  'exceptionType','CLEARING_EXCEPTION','' 
go
add_domain_values  'exceptionType','CLEARING_INFO','' 
go
add_domain_values  'measuresForAdjustment','OTE','' 
go
add_domain_values  'measuresForAdjustment','OTE_REV','' 
go
add_domain_values  'measuresForAdjustment','REALIZED_PL','' 
go
add_domain_values  'measuresForAdjustment','REALIZED_PL_REV','' 
go
add_domain_values  'REPORT.Types','UnderMarginedAccount','' 
go
add_domain_values  'mccAdditionalField.SEPARATE_VM_SETTLEMENT','True','' 
go
add_domain_values  'mccAdditionalField.SEPARATE_VM_SETTLEMENT','False','' 
go
add_domain_values  'mccAdditionalField.PRODUCT_TYPE','CDX','' 
go
add_domain_values  'mccAdditionalField.PRODUCT_TYPE','ETD','' 
go
add_domain_values  'mccAdditionalField.IM_IMPORT_CURRENCY','Converted','' 
go
add_domain_values  'mccAdditionalField.IM_IMPORT_CURRENCY','Native','' 
go
add_domain_values  'domainName','leAttributeType.LCHRemoteFolderStructure','' 
go
add_domain_values  'leAttributeType.LCHRemoteFolderStructure','Dynamic','' 
go
add_domain_values  'leAttributeType.LCHRemoteFolderStructure','Static','' 
go
add_domain_values  'MsgAttributes','CVRWorksheetExportedAdviceDocumentID','' 
go
add_domain_values  'MsgAttributes','CVRWorksheetOriginalID','' 
go
add_domain_values  'MsgAttributes','CVRWorksheetResponseDescription','' 
go
add_domain_values  'MsgAttributes','CVRWorksheetResponseAction','' 
go
add_domain_values  'MsgAttributes','CVRWorksheetResponseMessageID','' 
go
add_domain_values  'MsgAttributes','CVRWorksheetAckMessageID','' 
go
add_domain_values  'MsgAttributes','CVRWorksheetExternalResponseMessageID','' 
go
add_domain_values  'MsgAttributes','CVRWorksheetExternalSentBy','' 
go
add_domain_values  'MsgAttributes','CVRWorksheetExternalSentTo','' 
go
add_domain_values  'workflowRuleMessage','PrepareCVRForSend','Enriches the CVR_WORKSHEET message with information to be sent to the CCP' 
go
add_domain_values  'workflowRuleMessage','MatchCollateralAllocationResponse','Processes an incoming collateral allocation message and matches it to an existing CVR_WORKSHEET one' 
go
add_domain_values  'messageStatus','ACCEPTED','' 
go
add_domain_values  'addressMethod','LCHCVR','' 
go
add_domain_values  'domainName','Clearing.Statement.resourceLocations','Collection of Spring resource locations to configure the Clearing Statement' 
go
add_domain_values  'Clearing.Statement.resourceLocations','classpath:config/ClearingStatementFactory.xml','' 
go
add_domain_values  'domainName','Clearing.Statement.profiling','Set it to true to activate some basic profiling characteristics. If set to false, or to multiple values, or empty, it is taken as false' 
go

add_domain_values  'domainName','transferSettledStatus','' 
go
add_domain_values  'transferStatus','SETTLED','' 
go
add_domain_values  'eventFilter','IgnoreProductsForTransferEventFilter',' filter for Sender Engine' 
go
add_domain_values  'domainName','Clearing.Transfer.ignoreProducts','Product names to be ignored by the TransferEngine and other downstream processes' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureEquityIndex','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionEquityIndex','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureCDSIndex','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureEquity','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionBond','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureSwap','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureFX','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionFX','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureCommodity','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionEquity','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionVolatility','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionIndex','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureMM','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionSwap','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureDividend','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureStructuredFlows','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionMM','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureVolatility','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionDividend','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureOptionCommodity','' 
go
add_domain_values  'Clearing.Transfer.ignoreProducts','FutureBond','' 
go
add_domain_values  'tradeKeyword','ClearingMirroringBehavior','' 
go
add_domain_values  'MirrorKeywords','ClearingMirroringBehavior','' 
go
add_domain_values  'domainName','keyword.ClearingMirroringBehavior','' 
go
add_domain_values  'keyword.ClearingMirroringBehavior','MirroredAccount','Default value (OTC style)' 
go
add_domain_values  'keyword.ClearingMirroringBehavior','SingleAccount','Single account (ETD style)' 
go
add_domain_values  'NPVFlows','OTE','Open Trade Equity' 
go
add_domain_values  'NPVReversalFlows','OTE_REV','Open Trade Equity Reversal' 
go
add_domain_values  'domainName','Clearing.CDML.producerNames','List of available CDML producer names' 
go
add_domain_values  'domainName','DTCC-GTR-NotReportingPartyRole','' 
go
add_domain_values  'domainName','DTCC-GTR-ESMA-CorporateSectors','List of available regulatory corporate sectors for EMIR' 
go
add_domain_values  'domainName','DTCC-GTR-ReportingAdapter','Setup of Calypso Base Reporting Adapter' 
go
add_domain_values  'leAttributeType','EMIR-Eligible','Boolean that can force an non-EEA entity to be EMIR eligible' 
go
add_domain_values  'leAttributeType','DFA-Eligible','Boolean that can force an non-US entity to be DFA eligible' 
go
add_domain_values  'leAttributeType','DTCCGTR-ReportingAgent','Short name of the legal entity which is the reporting agent for current legal entity (which must be a PO)' 
go
add_domain_values  'leAttributeType','EMIR-ReportingDelegation','When set to Full, indicates that the legal entity (with role counterparty) gives a full delegation of reporting to PO' 
go
add_domain_values  'leAttributeType','DFA-Counterparty-Masking','Boolean that indicates if this legal entity (with role counterparty) should be masked to Dodd-Frank regulators' 
go
add_domain_values  'leAttributeType','EMIR-Counterparty-Masking','Boolean that indicates if this legal entity (with role counterparty) should be masked to ESMA' 
go
add_domain_values  'leAttributeType','EMIR-UTIGeneratingParty-Agreement','Indicates an UTI generating party agreement between PO and the given legal entity. If set to ProcessingOrg, PO will always be generating party, if set to Counterparty, the counterparty will always be generating party' 
go
add_domain_values  'leAttributeType','ESMA-CorporateSector','Provides the corporate sector of legal entity for ESMA' 
go
add_domain_values  'leAttributeType','ESMA-ExceedsClearingThreshold','Boolean that indicates whether a non-financial entity has exceeded its clearing threshold' 
go
add_domain_values  'exceptionType','DTCC_FATAL','' 
go
add_domain_values  'eventType','EX_DTCC_FATAL','' 
go
add_domain_values  'exceptionType','DTCC_ERROR','' 
go
add_domain_values  'eventType','EX_DTCC_ERROR','' 
go
add_domain_values  'exceptionType','DTCC_WARNING','' 
go
add_domain_values  'eventType','EX_DTCC_WARNING','' 
go
add_domain_values  'exceptionType','DTCC_INFORMATION','' 
go
add_domain_values  'eventType','EX_DTCC_INFORMATION','' 
go
add_domain_values  'DTCC-GTR-ESMA-CorporateSectors','AlternativeInvestmentFund','' 
go
add_domain_values  'DTCC-GTR-ESMA-CorporateSectors','AssuranceUndertaking','' 
go
add_domain_values  'DTCC-GTR-ESMA-CorporateSectors','CreditInstitution','' 
go
add_domain_values  'DTCC-GTR-ESMA-CorporateSectors','InstitutionForOccupationalRetirementProvision','' 
go
add_domain_values  'DTCC-GTR-ESMA-CorporateSectors','InsuranceUndertaking','' 
go
add_domain_values  'DTCC-GTR-ESMA-CorporateSectors','InvestmentFirm','' 
go
add_domain_values  'DTCC-GTR-ESMA-CorporateSectors','ReinsuranceUndertaking','' 
go
add_domain_values  'DTCC-GTR-ESMA-CorporateSectors','UCITS','' 
go
add_domain_values  'leAttributeType','NFA_ID','Provides the NFA (National Future Association) identifier assigned to the legal entity' 
go
add_domain_values  'leAttributeType','ANONYMOUS_DTCC_LE_ID','Provides a to identifier for a counterparty that we do not want to disclose to DTCC GTR' 
go
add_domain_values  'DTCC-GTR-NotReportingPartyRole','DoddFrank','' 
go
add_domain_values  'tradeKeyword','AmendmentTradeDatetime','' 
go
add_domain_values  'tradeKeyword','AmendmentEffectiveDate','' 
go
add_domain_values  'tradeKeyword','Novation_ChildType','' 
go
add_domain_values  'CountryAttributes','EEARegion','' 
go
add_domain_values 'domainName','ERSLimitServer.engines','' 
go
add_domain_values 'domainName','ERSRiskServer.engines','' 
go
add_domain_values 'domainName','ERSLimitServer.instances','' 
go
add_domain_values 'domainName','ERSRiskServer.instances','' 
go
add_domain_values 'engineserver.types','ERSLimitServer','ERS Limit Server Engine Container' 
go
add_domain_values 'engineserver.types','ERSRiskServer','ERS Risk Server Engine Container' 
go
add_domain_values 'ERSLimitServer.engines','ERSLimitEngine','' 
go
add_domain_values 'ERSLimitServer.engines','ERSCreditEngine','' 
go
add_domain_values 'ERSRiskServer.engines','RiskEngineBroker','' 
go
add_domain_values 'ERSLimitServer.engines','DataWarehouseEngine','' 
go
add_domain_values 'ERSRiskServer.engines','DataWareHouseRiskEngine','' 
go


/* diff ends here */

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='004',
        version_date='20140903'
go

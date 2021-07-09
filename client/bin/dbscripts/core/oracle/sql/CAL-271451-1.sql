 

update scenario_quoted_product set pricer_measure = 'VOLATILITY_SPREAD' where product_name not like '%Dividend%' and pricer_measure = 'IMPLIEDVOLATILITY'
;
update scenario_quoted_product set pricer_measure = 'PLXG' where product_name='PerformanceSwap' or product_name='BondOption'
;

 

begin 
add_domain_values( 'scheduledTask', 'CHAIN', '' );
end;
/



/* CAL-188642 migrate inventory data model BEGIN */

declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('TRADE_OPENQTY_SNAP') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'CREATE TABLE TRADE_OPENQTY_SNAP (TRADE_ID NUMBER(*,0) NOT NULL ENABLE, PRODUCT_ID NUMBER(*,0) NOT NULL ENABLE, 
SETTLE_DATE TIMESTAMP (6) NOT NULL ENABLE, TRADE_DATE TIMESTAMP (6) NOT NULL ENABLE, QUANTITY FLOAT(126), 
OPEN_QUANTITY FLOAT(126), PRICE FLOAT(126), ACCRUAL FLOAT(126), OPEN_REPO_QUANTITY FLOAT(126), BOOK_ID NUMBER(*,0) NOT NULL ENABLE, 
PRODUCT_FAMILY VARCHAR2(32), PRODUCT_TYPE VARCHAR2(32), SIGN NUMBER(*,0) NOT NULL ENABLE, IS_LIQUIDABLE NUMBER(*,0) NOT NULL ENABLE, 
IS_RETURN NUMBER(*,0) NOT NULL ENABLE, RETURN_DATE TIMESTAMP (6), ENTERED_DATE TIMESTAMP (6), CA_ID NUMBER(*,0), YIELD FLOAT(126),
 LIQ_AGG_ID NUMBER(*,0) NOT NULL ENABLE, POSITION_ID NUMBER(*,0) NOT NULL ENABLE, TRADE_VERSION NUMBER(*,0) NOT NULL ENABLE, 
 LIQ_CONFIG_ID NUMBER(*,0) NOT NULL ENABLE, SNAPSHOT_DATE TIMESTAMP (6) NOT NULL ENABLE)';
 
END IF;
End ;
/

declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('PL_POSITION_SNAP') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'CREATE TABLE PL_POSITION_SNAP (PRODUCT_ID NUMBER(*,0) NOT NULL ENABLE, BOOK_ID NUMBER(*,0) NOT NULL ENABLE, REALIZED FLOAT(126), 
UNREALIZED FLOAT(126), LAST_LIQ_DATE TIMESTAMP (6), LAST_AVERAGE_PRICE FLOAT(126), CURRENT_AVG_PRICE FLOAT(126), 
LAST_LIQ_ID NUMBER(*,0), LIQ_BUY_QUANTITY FLOAT(126), LIQ_SELL_QUANTITY FLOAT(126), LIQ_BUY_AMOUNT FLOAT(126), 
LIQ_SELL_AMOUNT FLOAT(126), LIQ_BUY_ACCRUAL FLOAT(126), LIQ_SELL_ACCRUAL FLOAT(126), TOTAL_INTEREST FLOAT(126), 
LAST_ARCHIVE_ID NUMBER(*,0), LAST_ARCH_DATE TIMESTAMP (6), VERSION_NUM NUMBER(*,0), LIQ_AGG_ID NUMBER(*,0) NOT NULL ENABLE, 
POSITION_ID NUMBER(*,0) NOT NULL ENABLE, TOTAL_PREM_DISC FLOAT(126), TOTAL_PREM_DISC_YIELD FLOAT(126), TOTAL_PRINCIPAL FLOAT(126), 
LAST_TRADE_DATE TIMESTAMP (6), INCEP_TRADE_DATE TIMESTAMP (6), ENTERED_DATE TIMESTAMP (6), LIQ_CONFIG_ID NUMBER(*,0) NOT NULL ENABLE,
SNAPSHOT_DATE TIMESTAMP (6) NOT NULL ENABLE, LAST_SETTLE_DATE TIMESTAMP (6), MAX_SETTLE_DATE TIMESTAMP (6), 
LAST_UPDATED_TIME TIMESTAMP (6))';
 
END IF;
End ;
/
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('INV_SECPOSITION') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'CREATE TABLE INV_SECPOSITION (INTERNAL_EXTERNAL VARCHAR2(32) NOT NULL ENABLE, POSITION_TYPE VARCHAR2(16) NOT NULL ENABLE, 
DATE_TYPE VARCHAR2(16) NOT NULL ENABLE, AGENT_ID NUMBER(*,0) NOT NULL ENABLE, 
ACCOUNT_ID NUMBER(*,0) NOT NULL ENABLE, POSITION_DATE TIMESTAMP (6) NOT NULL ENABLE, SECURITY_ID NUMBER(*,0) NOT NULL ENABLE, 
BOOK_ID NUMBER(*,0) NOT NULL ENABLE, CONFIG_ID NUMBER(*,0) NOT NULL ENABLE, TOTAL_SECURITY FLOAT(126),
 DAILY_SECURITY FLOAT(126), TOTAL_BORROWED FLOAT(126), DAILY_BORROWED FLOAT(126), T_BOR_NOT_AVL FLOAT(126), 
 D_BOR_NOT_AVL FLOAT(126), TOTAL_BORROWED_CA FLOAT(126), TOTAL_LOANED FLOAT(126), DAILY_LOANED FLOAT(126),
 T_LOAN_NOT_AVL FLOAT(126), D_LOAN_NOT_AVL FLOAT(126), TOTAL_LOANED_CA FLOAT(126), TOTAL_COLL_IN FLOAT(126), 
 DAILY_COLL_IN FLOAT(126), T_COLL_IN_NOT_AVL FLOAT(126), D_COLL_IN_NOT_AVL FLOAT(126), TOTAL_COLL_IN_CA FLOAT(126), 
 TOTAL_COLL_OUT FLOAT(126), DAILY_COLL_OUT FLOAT(126), T_COLL_OUT_NOT_AVL FLOAT(126), D_COLL_OUT_NOT_AVL FLOAT(126), 
 TOTAL_COLL_OUT_CA FLOAT(126), TOTAL_PLEDGED_IN FLOAT(126), DAILY_PLEDGED_IN FLOAT(126), TOTAL_PLEDGED_OUT FLOAT(126), 
 DAILY_PLEDGED_OUT FLOAT(126), DAILY_COLL_OUT_CA FLOAT(126), DAILY_COLL_IN_CA FLOAT(126), 
 TOTAL_UNAVAIL FLOAT(126), DAILY_UNAVAIL FLOAT(126), TOTAL_REPO_TRACK_IN FLOAT(126), DAILY_REPO_TRACK_IN FLOAT(126), 
 TOTAL_REPO_TRACK_OUT FLOAT(126), DAILY_REPO_TRACK_OUT FLOAT(126), TOTAL_BORROWED_AUTO FLOAT(126),
 DAILY_BORROWED_AUTO FLOAT(126), TOTAL_LOANED_AUTO FLOAT(126), DAILY_LOANED_AUTO FLOAT(126), TOTAL_PTH_IN FLOAT(126),
 DAILY_PTH_IN FLOAT(126), TOTAL_PTH_OUT FLOAT(126), DAILY_PTH_OUT FLOAT(126))' ;
 
EXECUTE IMMEDIATE 'CREATE TABLE inv_secpos_hist (INTERNAL_EXTERNAL VARCHAR2(32) NOT NULL ENABLE, POSITION_TYPE VARCHAR2(16) NOT NULL ENABLE, 
DATE_TYPE VARCHAR2(16) NOT NULL ENABLE, AGENT_ID NUMBER(*,0) NOT NULL ENABLE, 
ACCOUNT_ID NUMBER(*,0) NOT NULL ENABLE, POSITION_DATE TIMESTAMP (6) NOT NULL ENABLE, SECURITY_ID NUMBER(*,0) NOT NULL ENABLE, 
BOOK_ID NUMBER(*,0) NOT NULL ENABLE, CONFIG_ID NUMBER(*,0) NOT NULL ENABLE, TOTAL_SECURITY FLOAT(126),
 DAILY_SECURITY FLOAT(126), TOTAL_BORROWED FLOAT(126), DAILY_BORROWED FLOAT(126), T_BOR_NOT_AVL FLOAT(126), 
 D_BOR_NOT_AVL FLOAT(126), TOTAL_BORROWED_CA FLOAT(126), TOTAL_LOANED FLOAT(126), DAILY_LOANED FLOAT(126),
 T_LOAN_NOT_AVL FLOAT(126), D_LOAN_NOT_AVL FLOAT(126), TOTAL_LOANED_CA FLOAT(126), TOTAL_COLL_IN FLOAT(126), 
 DAILY_COLL_IN FLOAT(126), T_COLL_IN_NOT_AVL FLOAT(126), D_COLL_IN_NOT_AVL FLOAT(126), TOTAL_COLL_IN_CA FLOAT(126), 
 TOTAL_COLL_OUT FLOAT(126), DAILY_COLL_OUT FLOAT(126), T_COLL_OUT_NOT_AVL FLOAT(126), D_COLL_OUT_NOT_AVL FLOAT(126), 
 TOTAL_COLL_OUT_CA FLOAT(126), TOTAL_PLEDGED_IN FLOAT(126), DAILY_PLEDGED_IN FLOAT(126), TOTAL_PLEDGED_OUT FLOAT(126), 
 DAILY_PLEDGED_OUT FLOAT(126), DAILY_COLL_OUT_CA FLOAT(126), DAILY_COLL_IN_CA FLOAT(126), 
 TOTAL_UNAVAIL FLOAT(126), DAILY_UNAVAIL FLOAT(126), TOTAL_REPO_TRACK_IN FLOAT(126), DAILY_REPO_TRACK_IN FLOAT(126), 
 TOTAL_REPO_TRACK_OUT FLOAT(126), DAILY_REPO_TRACK_OUT FLOAT(126), TOTAL_BORROWED_AUTO FLOAT(126),
 DAILY_BORROWED_AUTO FLOAT(126), TOTAL_LOANED_AUTO FLOAT(126), DAILY_LOANED_AUTO FLOAT(126), TOTAL_PTH_IN FLOAT(126),
 DAILY_PTH_IN FLOAT(126), TOTAL_PTH_OUT FLOAT(126), DAILY_PTH_OUT FLOAT(126))' ;
END IF;
End ;
/
 
begin

add_column_if_not_exists('inv_secposition','TOTAL_BORROWED_AUTO', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secposition','DAILY_BORROWED_AUTO', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secposition','TOTAL_LOANED_AUTO', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secposition','DAILY_LOANED_AUTO', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secposition','total_pth_in', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secposition','daily_pth_in', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secposition','total_pth_out', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secposition','daily_pth_out', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secpos_hist','TOTAL_BORROWED_AUTO', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secpos_hist','DAILY_BORROWED_AUTO', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secpos_hist','TOTAL_LOANED_AUTO', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secpos_hist','DAILY_LOANED_AUTO', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secpos_hist','total_pth_in', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secpos_hist','daily_pth_in', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secpos_hist','total_pth_out', 'FLOAT DEFAULT 0 NULL');
add_column_if_not_exists('inv_secpos_hist','daily_pth_out', 'FLOAT DEFAULT 0 NULL');
end;
/

begin
add_column_if_not_exists('inv_secposition','total_hold_in','float');
add_column_if_not_exists('inv_secposition','daily_hold_in','float');
add_column_if_not_exists('inv_secposition','total_hold_out','float');
add_column_if_not_exists('inv_secposition','daily_hold_out','float');
add_column_if_not_exists('inv_secposition','account_id','number');
add_column_if_not_exists('inv_secposition','daily_repo_track_in','float');
add_column_if_not_exists('inv_secposition','total_repo_track_in','float');
end;
/

begin
add_column_if_not_exists('inv_secpos_hist','total_hold_in','float');
add_column_if_not_exists('inv_secpos_hist','daily_hold_in','float');
add_column_if_not_exists('inv_secpos_hist','total_hold_out','float');
add_column_if_not_exists('inv_secpos_hist','daily_hold_out','float');
add_column_if_not_exists('inv_secpos_hist','account_id','number');
add_column_if_not_exists('inv_secpos_hist','daily_repo_track_in','float');
add_column_if_not_exists('inv_secpos_hist','total_repo_track_in','float');
end;
/
begin
add_column_if_not_exists('product_cap_floor','reset_date_roll', 'varchar2(16)');
end;
/

begin
add_column_if_not_exists('inv_secposition','DAILY_REPO_TRACK_OUT', 'FLOAT(126)');
end;
/
begin
add_column_if_not_exists('inv_secposition','TOTAL_REPO_TRACK_OUT', 'FLOAT(126)');
end;
/
/* this profits from a "alter session enable parallel dml" */
/*  on a 57m row inv_secpotion table, below sql statements can run in minute for the parallel ones, 3 minutes for the non-parallel alter table  */

/* merge live and history tables */

create table migrate_sec_all parallel nologging as 
select /*+ parallel(inv_secposition,8) append */
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
from inv_secposition
union all 
select /*+ parallel(inv_secpos_hist,8) append */
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
/

/* sum up daily (across old live/history). */
/* the cast to float is there since otherwise the columns will have type number,       */
/* and executesql would then attempt to alter to float. and that would cause an error  */
/* in oracle.                                                                          */

alter table inv_sec_movement parallel nologging
/

insert into inv_sec_movement (internal_external,position_type,date_type,agent_id,account_id,position_date,security_id,book_id,config_id,
 daily_security,daily_borrowed,d_bor_not_avl,
 daily_borrowed_ca,daily_loaned ,d_loan_not_avl,daily_coll_in,
 d_coll_in_not_avl,daily_loaned_ca,daily_coll_out,d_coll_out_not_avl,
 daily_pledged_in,daily_pledged_out,daily_coll_out_ca,
 daily_coll_in_ca,daily_unavail,daily_repo_track_in,
 daily_repo_track_out,daily_borrowed_auto,daily_loaned_auto,daily_pth_in,daily_pth_out,version) 
 select /*+ parallel(migrate_sec_all,8) append */
internal_external,position_type,date_type,agent_id,account_id,position_date,security_id,book_id,config_id,
cast(sum(daily_security)as float) as daily_security,
cast(sum(daily_borrowed)as float) as daily_borrowed,
cast(sum(d_bor_not_avl)as float) as d_bor_not_avl,
cast(0 as float) as daily_borrowed_ca,
cast(sum(daily_loaned)as float) as daily_loaned,
cast(sum(d_loan_not_avl)as float) as d_loan_not_avl,
cast(sum(daily_coll_in)as float) as daily_coll_in,
cast(sum(d_coll_in_not_avl)as float) as d_coll_in_not_avl,
cast(0 as float) as daily_loaned_ca,
cast(sum(daily_coll_out)as float) as daily_coll_out,
cast(sum(d_coll_out_not_avl)as float) as d_coll_out_not_avl,
cast(sum(daily_pledged_in)as float) as daily_pledged_in,
cast(sum(daily_pledged_out)as float) as daily_pledged_out,
cast(sum(daily_coll_out_ca)as float) as daily_coll_out_ca,
cast(sum(daily_coll_in_ca)as float) as daily_coll_in_ca,
cast(sum(daily_unavail)as float) as daily_unavail,
cast(sum(daily_repo_track_in)as float) as daily_repo_track_in,
cast(sum(daily_repo_track_out)as float) as daily_repo_track_out,
cast(sum(daily_borrowed_auto)as float) as daily_borrowed_auto,
cast(sum(daily_loaned_auto)as float) as daily_loaned_auto,
cast(sum(daily_pth_in)as float) as daily_pth_in,
cast(sum(daily_pth_out)as float) as daily_pth_out,
cast(0 as int) as version
from migrate_sec_all
group by 
internal_external,position_type,date_type,agent_id,account_id,position_date,security_id,book_id,config_id
/

/* find the most recent position date per position. we initialize the total table from that date's entry */
create table migrate_sec_bal_date parallel nologging as
select /*+ parallel(migrate_sec_all,8) append */ 
internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id, 
 max(position_date) as total_mig_date
from migrate_sec_all
where position_date <= current_date 
group by internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id
/


/* extra case for positions with only future balances */ 
insert into migrate_sec_bal_date (internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id, total_mig_date) 
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
/

alter table inv_sec_balance parallel nologging
/

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
select /*+ parallel(t1,8) append */ 
internal_external,position_type,date_type,agent_id,account_id,security_id,book_id,config_id, position_date,
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
/
  
/* now handle cash positions */

create table migrate_cash_all parallel nologging as 
select /*+ parallel(inv_cashposition,8) append */
internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id,
total_amount,
daily_change
from inv_cashposition
union all 
select /*+ parallel(inv_cashpos_hist,8) append */
internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id,
total_amount,
daily_change
from inv_cashpos_hist
/

alter table inv_cash_movement parallel nologging
/

insert into inv_cash_movement (internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id,
daily_change,version)
select /*+ parallel(migrate_cash_all,8) append */
internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id,
cast(sum(daily_change) as float) as daily_change,
cast(0 as int) as version
from migrate_cash_all
group by 
internal_external,position_type,date_type,agent_id,account_id,position_date,currency_code,book_id,config_id
/

create table  migrate_cash_bal_date parallel nologging as 
select /*+ parallel(migrate_cash_all,8) append */  
internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, 
 max(position_date) as total_mig_date
from migrate_cash_all
where position_date <= current_date 
group by internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id
/

insert into migrate_cash_bal_date (internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, total_mig_date )
select /*+ parallel(migrate_cash_all,8) append */  
internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, min(position_date) 
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
/

alter table inv_cash_balance parallel nologging
/

insert into inv_cash_balance (internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, position_date,
total_amount,version) 
select /*+ parallel(migrate_cash_all,8) append */ 
internal_external,position_type,date_type,agent_id,account_id,currency_code,book_id,config_id, position_date,
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
/

/* CAL-199363 */

begin
add_column_if_not_exists ('inv_sec_balance','mcc_id','number default 0');
end;
/
update /*+ parallel(8) */ inv_sec_balance set mcc_id = config_id, config_id = 0 where (mcc_id is null or mcc_id = 0) and config_id <> 0 and internal_external = 'MARGIN_CALL'
/
begin
add_column_if_not_exists ('inv_cash_balance','mcc_id','number default 0');
end;
/
update /*+ parallel(8) */ inv_cash_balance set mcc_id = config_id, config_id = 0 where (mcc_id is null or mcc_id = 0) and config_id <> 0 and internal_external = 'MARGIN_CALL'
/
begin
add_column_if_not_exists ('inv_sec_movement','mcc_id','number default 0');
end;
/
update /*+ parallel(8) */ inv_sec_movement set mcc_id = config_id, config_id = 0 where (mcc_id is null or mcc_id = 0) and config_id <> 0 and internal_external = 'MARGIN_CALL'
/
begin
add_column_if_not_exists ('inv_cash_movement','mcc_id','number default 0');
end;
/
update /*+ parallel(8) */ inv_cash_movement set mcc_id = config_id, config_id = 0 where (mcc_id is null or mcc_id = 0) and config_id <> 0 and internal_external = 'MARGIN_CALL'
/

/* 181 seconds (doesn't run in parallel in this form) */ 
alter table inv_cash_balance noparallel logging
/
alter table inv_cash_movement noparallel logging
/
alter table inv_sec_balance noparallel logging
/
alter table inv_sec_movement noparallel logging
/

drop table migrate_sec_all
/
drop table migrate_sec_bal_date
/
drop table migrate_cash_all
/
drop table migrate_cash_bal_date
/



declare 
cnt number;
begin
  select count(*) into cnt from domain_values where name='EngineServer.instances';
  if( cnt = 0 ) then 
	insert into domain_values (name,value,description) values ('EngineServer.instances','engineserver','Default engine server instance');
	insert into engine_param (engine_name,param_name,param_value) values ('TransferEngine','CLASS_NAME','com.calypso.engine.payment.TransferEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('TransferEngine','DISPLAY_NAME','Transfer Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('TransferEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('TransferEngine','STARTUP','true');

	insert into engine_param (engine_name,param_name,param_value) values ('MessageEngine','CLASS_NAME','com.calypso.engine.advice.MessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('MessageEngine','DISPLAY_NAME','Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('MessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('MessageEngine','STARTUP','true');

	insert into engine_param (engine_name,param_name,param_value) values ('SenderEngine','CLASS_NAME','com.calypso.engine.advice.SenderEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('SenderEngine','DISPLAY_NAME','Sender Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('SenderEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('SenderEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','DISPLAY_NAME','Swift Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('SwiftImportMessageEngine','config','Swift');

	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','DISPLAY_NAME','BONY Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('BONYImportMessageEngine','config','GSCC');

	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','DISPLAY_NAME','GSCC Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('GSCCImportMessageEngine','config','GSCC');

	insert into engine_param (engine_name,param_name,param_value) values ('PositionEngine','CLASS_NAME','com.calypso.engine.position.PositionEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('PositionEngine','DISPLAY_NAME','Position Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('PositionEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('PositionEngine','STARTUP','true');

	insert into engine_param (engine_name,param_name,param_value) values ('BillingEngine','CLASS_NAME','com.calypso.engine.billing.BillingEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('BillingEngine','DISPLAY_NAME','Billing Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('BillingEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('BillingEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('TaskEngine','CLASS_NAME','com.calypso.engine.task.TaskEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('TaskEngine','DISPLAY_NAME','Task Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('TaskEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('TaskEngine','STARTUP','true');

	insert into engine_param (engine_name,param_name,param_value) values ('MatchableBuilderEngine','CLASS_NAME','com.calypso.engine.matching.MatchableBuilderEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('MatchableBuilderEngine','DISPLAY_NAME','MatchableBuilder Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('MatchableBuilderEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('MatchableBuilderEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('MatchingEngine','CLASS_NAME','com.calypso.engine.matching.MatchingEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('MatchingEngine','DISPLAY_NAME','Matching Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('MatchingEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('MatchingEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('ReutersDssEngine','CLASS_NAME','com.calypso.engine.reutersdss.ReutersDSSEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('ReutersDssEngine','DISPLAY_NAME','ReutersDSS Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('ReutersDssEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('ReutersDssEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('BloombergEngine','CLASS_NAME','com.calypso.engine.bloomberg.BloombergEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergEngine','DISPLAY_NAME','Bloomberg Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','CLASS_NAME','com.calypso.tk.engine.UploadImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','DISPLAY_NAME','Uploader Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderImportMessageEngine','config','Uploader');

	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','CLASS_NAME','com.calypso.tk.engine.DSMatchImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','DISPLAY_NAME','DS Match Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('DSMatchImportMessageEngine','config','DSMatchFX');

	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','CLASS_NAME','com.calypso.tk.engine.DataUploaderEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','DISPLAY_NAME','DataUploader Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('DataUploaderEngine','config','datauploader.properties');

	insert into engine_param (engine_name,param_name,param_value) values ('UploaderPublishEngine','CLASS_NAME','com.calypso.tk.engine.UploaderPublishEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderPublishEngine','DISPLAY_NAME','UploaderPublish Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderPublishEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('UploaderPublishEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','CLASS_NAME','com.calypso.tk.engine.ICELinkEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','DISPLAY_NAME','ICELink Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('ICELinkEngine','config','icelink.properties');

	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','CLASS_NAME','com.calypso.engine.bloombergsapi.BloombergSAPIEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','DISPLAY_NAME','BloombergSAPI Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('BloombergSAPIEngine','config','BloombergSAPI');

	insert into engine_param (engine_name,param_name,param_value) values ('ExchangeFeedBridgeEngine','CLASS_NAME','com.calypso.tk.engine.ExchangeFeedBridgeEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('ExchangeFeedBridgeEngine','DISPLAY_NAME','ExchangeFeedBridge Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('ExchangeFeedBridgeEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('ExchangeFeedBridgeEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('SwapswireTradeEngine','CLASS_NAME','com.calypso.engine.advice.SwapswireTradeEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('SwapswireTradeEngine','DISPLAY_NAME','Swapswire Trade Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('SwapswireTradeEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('SwapswireTradeEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','CLASS_NAME','com.calypso.tk.engine.DataUploaderEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','DISPLAY_NAME','TRUploader Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('TRUploaderEngine','config','truploader.properties');

	insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','CLASS_NAME','com.calypso.engine.ftp.FTPEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','DISPLAY_NAME','FTP Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('LifeCycleEngine','CLASS_NAME','com.calypso.engine.lifecycle.LifeCycleEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('LifeCycleEngine','DISPLAY_NAME','LifeCycle Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('LifeCycleEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('LifeCycleEngine','STARTUP','true');

	insert into engine_param (engine_name,param_name,param_value) values ('HedgeRelationshipEngine','CLASS_NAME','com.calypso.engine.hedgeRelationship.HedgeRelationshipEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('HedgeRelationshipEngine','DISPLAY_NAME','Hedge Relationship Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('HedgeRelationshipEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('HedgeRelationshipEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('TraxEngine','CLASS_NAME','com.calypso.engine.advice.TraxEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('TraxEngine','DISPLAY_NAME','Trax Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('TraxEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('TraxEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','DISPLAY_NAME','DTCC DS Match Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCDSMatchImportMessageEngine','config','DTCC');

	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','DISPLAY_NAME','DTCC GTR Rates Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRRatesImportMessageEngine','config','DTCCGTRIntRate');

	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','DISPLAY_NAME','DTCC GTR Credit Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRCreditImportMessageEngine','config','DTCCGTRCredit');

	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','DISPLAY_NAME','DTCC GTR FX Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('DTCCGTRFXImportMessageEngine','config','DTCCGTRFX');

	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','CLASS_NAME','com.calypso.engine.advice.ImportMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','DISPLAY_NAME','CLS Import Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('CLSImportMessageEngine','config','CLS');

	insert into engine_param (engine_name,param_name,param_value) values ('IntexEngine','CLASS_NAME','com.calypso.engine.intex.IntexEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('IntexEngine','DISPLAY_NAME','Intex Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('IntexEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('IntexEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','CLASS_NAME','com.calypso.engine.risk.MarketConformityEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','DISPLAY_NAME','Market Conformity Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('MarketConformityEngine','pricingenv','INTRADAY');

	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','CLASS_NAME','com.calypso.engine.risk.IntradayMarketDataEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','DISPLAY_NAME','Intraday Market Data Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','STARTUP','false');
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','pricingenv','INTRADAY');
	insert into engine_param (engine_name,param_name,param_value) values ('IntradayMarketDataEngine','feed','ReutersRFA');

	insert into engine_param (engine_name,param_name,param_value) values ('AccountingEngine','CLASS_NAME','com.calypso.engine.accounting.AccountingEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('AccountingEngine','DISPLAY_NAME','Accounting Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('AccountingEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('AccountingEngine','STARTUP','true');

	insert into engine_param (engine_name,param_name,param_value) values ('BalanceEngine','CLASS_NAME','com.calypso.engine.balance.BalanceEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('BalanceEngine','DISPLAY_NAME','Balance Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('BalanceEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('BalanceEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('CreEngine','CLASS_NAME','com.calypso.engine.accounting.CreEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('CreEngine','DISPLAY_NAME','Cre Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('CreEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('CreEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('CreSenderEngine','CLASS_NAME','com.calypso.engine.accounting.CreSenderEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('CreSenderEngine','DISPLAY_NAME','Cre Sender Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('CreSenderEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('CreSenderEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('PostingSenderEngine','CLASS_NAME','com.calypso.engine.accounting.PostingSenderEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('PostingSenderEngine','DISPLAY_NAME','Posting Sender Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('PostingSenderEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('PostingSenderEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('SenderAccountingEngine','CLASS_NAME','com.calypso.engine.accounting.SenderAccountingEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('SenderAccountingEngine','DISPLAY_NAME','Sender Accounting Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('SenderAccountingEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('SenderAccountingEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('DiaryEngine','CLASS_NAME','com.calypso.engine.diary.DiaryEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('DiaryEngine','DISPLAY_NAME','Diary Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('DiaryEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('DiaryEngine','STARTUP','true');

	insert into engine_param (engine_name,param_name,param_value) values ('InventoryEngine','CLASS_NAME','com.calypso.engine.inventory.InventoryEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('InventoryEngine','DISPLAY_NAME','Inventory Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('InventoryEngine','INSTANCE_NAME','engineserver'	);
	insert into engine_param (engine_name,param_name,param_value) values ('InventoryEngine','STARTUP','true');

	insert into engine_param (engine_name,param_name,param_value) values ('LiquidationEngine','CLASS_NAME','com.calypso.engine.position.LiquidationEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('LiquidationEngine','DISPLAY_NAME','Liquidation Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('LiquidationEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('LiquidationEngine','STARTUP','TRUE');

	insert into engine_param (engine_name,param_name,param_value) values ('PositionKeepingPersistenceEngine','CLASS_NAME','com.calypso.tk.positionkeeping.processing.engine.PositionKeepingPersistenceEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('PositionKeepingPersistenceEngine','DISPLAY_NAME','Position Keeping Persistence Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('PositionKeepingPersistenceEngine','INSTANCE_NAME','positionkeepingserver');
	insert into engine_param (engine_name,param_name,param_value) values ('PositionKeepingPersistenceEngine','STARTUP','true');

	insert into engine_param (engine_name,param_name,param_value) values ('MutationEngine','CLASS_NAME','com.calypso.engine.mutation.MutationEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('MutationEngine','DISPLAY_NAME','Mutation Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('MutationEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('MutationEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('IncomingEngine','CLASS_NAME','com.calypso.engine.advice.IncomingMessageEngine');
	insert into engine_param (engine_name,param_name,param_value) values ('IncomingEngine','DISPLAY_NAME','Incoming Message Engine');
	insert into engine_param (engine_name,param_name,param_value) values ('IncomingEngine','INSTANCE_NAME','engineserver');
	insert into engine_param (engine_name,param_name,param_value) values ('IncomingEngine','STARTUP','false');

	insert into engine_param (engine_name,param_name,param_value) values ('RelationshipManagerEngine','CLASS_NAME','com.calypso.engine.hedgeaccounting.RelationshipManagerEngine');
    insert into engine_param (engine_name,param_name,param_value) values ('RelationshipManagerEngine','DISPLAY_NAME','Relationship Manager Engine');
    insert into engine_param (engine_name,param_name,param_value) values ('RelationshipManagerEngine','INSTANCE_NAME','engineserver');
    insert into engine_param (engine_name,param_name,param_value) values ('RelationshipManagerEngine','STARTUP','false');
	
	select count(*) into cnt from engine_config where engine_name='MarginCallPositionEngine';
		if( cnt != 0 ) then 
			insert into engine_param (engine_name,param_name,param_value) values ('MarginCallPositionEngine','CLASS_NAME','com.calypso.engine.inventory.MarginCallEngine');
			insert into engine_param (engine_name,param_name,param_value) values ('MarginCallPositionEngine','DISPLAY_NAME','Margin Call Engine');
			insert into engine_param (engine_name,param_name,param_value) values ('MarginCallPositionEngine','INSTANCE_NAME','engineserver');
			insert into engine_param (engine_name,param_name,param_value) values ('MarginCallPositionEngine','STARTUP','false');
end if;
		
	select count(*) into cnt from engine_config where engine_name='LiquidityPositionPersistenceEngine';
		if( cnt != 0 ) then 
			insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','CLASS_NAME','com.calypso.tk.liquidity.positionkeeping.processing.engine.LiquidityPositionPersistenceEngine');
			insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','DISPLAY_NAME','Liquidity Server Connector');
			insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','INSTANCE_NAME','liquidityserver');
			insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','STARTUP','false');
		end if;		
end if;
end;
/

declare 
cnt number;
begin
  select count(*) into cnt from domain_values where name='PositionKeepingServer.instances';
  if( cnt = 0 ) then 
	INSERT INTO domain_values ( name, value,description ) values ('PositionKeepingServer.instances','positionkeepingserver','');
	INSERT INTO domain_values ( name, value,description ) values ('PositionKeepingServer.instances','liquidityserver','');	 
  end if;
end;

/

delete from engine_config where engine_name = 'ImportMessageEngine'
;
delete from domain_values domain_values where value = 'ImportMessageEngine' and name ='applicationName'
;
delete from domain_values where value = 'ImportMessageEngine' and name='engineName'
;
delete from engine_param where engine_name = 'ImportMessageEngine'
;
delete from ps_event_config where engine_name ='ImportMessageEngine'
;

delete from engine_config where engine_name = 'LimitEngine'
;
delete from domain_values where value = 'LimitEngine' and name ='applicationName'
;
delete from domain_values where value = 'LimitEngine' and name='engineName'
;
delete from engine_param where engine_name = 'LimitEngine'
;
delete from ps_event_config where engine_name ='LimitEngine'
;

declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='TaskEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'TaskEngine','Task Engine' );
end if;
end;
/


declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='LiquidityPositionPersistenceEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'LiquidityPositionPersistenceEngine','Liquidity Server Connector' );
end if;
end;
/

update referring_object set rfg_tbl_name='quartz_sched_task' ,rfg_obj_window='apps.scheduling.ScheduledTaskListWindow' 
where rfg_tbl_name='sched_task'
;
       
insert into report_win_def (win_def_id,def_name,use_book_hrchy,use_pricing_env, use_color) values (3550,'OfficialPLMark',0,0,0)
;

delete from domain_values where name='function' and value='AdmSaveEngineThread'
;
delete from group_access where access_value= 'AdmSaveEngineThread'
;

create table main_entry_prop_back141 as select * from main_entry_prop
;
update main_entry_prop set property_value = 'am.structure.FundWindow' where property_value = 'fund.FundWindow'
;
create or replace procedure mainent_schd
as 
  begin
  declare
  v_sql varchar2(512);

  v_prefix_code varchar(16);
  cursor c1 is
  select property_name, user_name,substr(property_name,1,instr(property_name, 'Action')-1),
  property_value from main_entry_prop where property_value = 'util.EventConfigWindow' or property_value = 'Event...'or property_value ='refdata.EngineConfigWindow' or property_value = 'Engine...'; 
  begin
  for c1_rec in c1 LOOP
v_prefix_code := substr(c1_rec.property_name,1,instr(c1_rec.property_name,'Action')-1);
v_sql := 'delete from main_entry_prop 
      where user_name = '||chr(39)||c1_rec.user_name||chr(39)||' and property_name like '||chr(39)||chr(37)||v_prefix_code||chr(37)||chr(39)|| ' and property_value = '||chr(39)||'util.EventConfigWindow'||chr(39)||' 
						or property_value = '||chr(39)||'Event...'||chr(39)||' or property_value ='||chr(39)||'refdata.EngineConfigWindow'||chr(39)||' or property_value = '||chr(39)||'Engine...'||chr(39); 
                                
execute immediate v_sql;           
                
end loop;
end;
end;
/

begin
mainent_schd;
end;
/

drop procedure mainent_schd
;

begin
add_column_if_not_exists ('cds_settlement_matrix','isda_agreement' ,'varchar2(32) null');
end;
/
update cds_settlement_matrix set isda_agreement='2003' where isda_agreement is null
;
/* CAL-219349 */
begin
add_domain_values('keyword.TerminationReason.IslamicMM','Manual','');
end;
/
begin
add_domain_values('keyword.TerminationReason.IslamicMM','BoughtBack','');
end;
/
	
begin
add_domain_values('productTypeReportStyle','IslamicMM','IslamicMM ReportStyle');
end;
/	
	
begin
add_domain_values('productTypeReportStyle','IslamicUnderlying','IslamicUnderlying ReportStyle');
end;
/
begin
add_domain_values('MESSAGE.Templates','islamicmm.html','');
end;
/      
begin
add_domain_values('domainName','IslamicMM.UnderlyingName','Underlying names for IslamicMM');
end;
/ 		
begin
add_domain_values('domainName','IslamicMM.LoanName','Names for IslamicMM loan');
end;
/ 		
begin
add_domain_values('IslamicMM.LoanName','Tawaruq','Default name for IslamicMM loan');
end;
/ 
begin
add_domain_values('IslamicMM.LoanName','Murabaha','');
end;
/ 
begin
add_domain_values('domainName','IslamicMM.DepositName','Names for IslamicMM deposit');
end;
/ 
begin
add_domain_values('IslamicMM.DepositName','Isra','Default name for IslamicMM deposit');
end;
/ 
begin
add_domain_values('IslamicMM.DepositName','Murabaha','');
end;
/ 

 
begin
drop_pk_if_exists('model_calibration_instrument');
end;
/

declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('model_calibration_instrument') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 1 THEN
EXECUTE IMMEDIATE 'alter table model_calibration_instrument modify underlying NULL' ;
END IF;
End ;
/

update trade_open_qty
set book_id = (select pl_position.book_id from pl_position where pl_position.position_id=trade_open_qty.position_id)
where book_id IS NULL or book_id = 0
;
update liq_position
set book_id = (select pl_position.book_id from pl_position where pl_position.position_id=liq_position.position_id)
where book_id IS NULL or book_id = 0
;
update trade_openqty_hist
set book_id = (select pl_position_hist.book_id from pl_position_hist where pl_position_hist.position_id=trade_openqty_hist.position_id)
where book_id IS NULL or book_id = 0
;
update liq_position_hist
set book_id = (select pl_position_hist.book_id from pl_position_hist where pl_position_hist.position_id=liq_position_hist.position_id)
where book_id IS NULL or book_id = 0
;
update trade_openqty_snap
set book_id = (select pl_position_snap.book_id from pl_position_snap where pl_position_snap.position_id=trade_openqty_snap.position_id)
where book_id IS NULL or book_id = 0
;

/* diff starts here */

declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('sql_blacklist_properties') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table sql_blacklist_properties (name varchar2(255) not null, value varchar2(255) not null, constraint pk_sqlbp primary key (name,value)) ' ;
END IF;
End ;
/
  
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('Benchmark','apps.risk.BenchmarkJideViewer',0 )
/
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('OfficialPL','apps.risk.OfficialPLAnalysisReportFrameworkViewer',0 )
/
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('OfficialPL Treatment','Indicates whether this book is included or excluded from the Official PL. By default book is included.' )
/

INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'markdata',500 )
/
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.reporting.PositionTypeDefinitionDialog' )
/
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.refdata.WorkFlowJFrame' )
/
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.refdata.WorkflowGraphJFrame' )
/
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (12,'LimitEngine','' )
/
 
begin
add_domain_values('domainName','ExcludePriceFixingsProduct','Products that will skip PL Explain Price Fixing Reset Effect.' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','Equity','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','ADR','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','Warrant','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','Certificate','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','CFD','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','BondExoticNote','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','FutureOptionEquity','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','FutureOptionEquityIndex','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','FutureOptionVolatility','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','FutureOptionDividend','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','FutureEquity','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','FutureEquityIndex','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','FutureVolatility','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','FutureDividend','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','ETOEquity','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','ETOEquityIndex','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','ETOVolatility','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','CorrelationSwap','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','ScriptableOTCProduct','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','EquityStructuredOption','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','EquityLinkedSwap','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','VarianceSwap','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','VarianceOption','' );
end;
/
begin
add_domain_values('ExcludePriceFixingsProduct','EquityForward','' );
end;
/
begin
add_domain_values('creditEventType','GOVERNMENT INTERVENTION','' );
end;
/
begin
add_domain_values('isdaCDSAgreement','2014','' );
end;
/
begin
add_domain_values('cdsAdditionalProvisions','Financial Reference Entity Terms','' );
end;
/
begin
add_domain_values('cdsAdditionalProvisions','2014 CoCo Supplement to the 2014 ISDA Credit Derivatives Defs','' );
end;
/
begin
add_domain_values('cdsAdditionalProvisions','Subordinated European Insurance Terms','' );
end;
/
begin
add_domain_values('cdsAdditionalProvisions','2014 Asset Package Delivery','' );
end;
/
begin
add_domain_values('cdsPmtLagType','As per Section 8.6 of the 2003 Definitions','' );
end;
/
begin
add_domain_values('cdsPmtLagType','Section 8.6 2003/Not to exceed thirty business days','' );
end;
/
begin
add_domain_values('cdsPmtLagType','As per Section 8.19 of the 2014 Definitions','' );
end;
/
begin
add_domain_values('cdsPmtLagType','Section 8.19 2014/Not to exceed thirty business days','' );
end;
/
begin
add_domain_values('domainName','FutureOptionEquity.Pricer','Pricers for FutureOptionEquity' );
end;
/
begin
add_domain_values('domainName','FutureOptionEquityIndex.Pricer','Pricers for FutureOptionEquityIndex' );
end;
/
begin
add_domain_values('domainName','SubscripRedemp.subtype','Types of Subscription Redemption' );
end;
/
begin
add_domain_values('domainName','ContribWithdraw.subtype','Types of Contribution Withdrawal' );
end;
/
begin
add_domain_values('domainName','ModelCalibrator','Model Calibrator' );
end;
/
begin
add_domain_values('ModelCalibrator','LMM','Libor Market Model Calibrator' );
end;
/
begin
add_domain_values('ModelCalibrator','LMMMultiCurrency','Libor Market Model Calibrator for multi-ccy model' );
end;
/
begin
add_domain_values('PositionBasedProducts','ShareClass','Share Class product' );
end;
/
begin
add_domain_values('PositionBasedProducts','Series','Series product' );
end;
/
begin
add_domain_values('classAuditMode','ShareClass','' );
end;
/
begin
add_domain_values('classAuditMode','Series','' );
end;
/
begin
add_domain_values('classAuditMode','Mandate','' );
end;
/
begin
add_domain_values('classAuditMode','SubscripRedemp','' );
end;
/
begin
add_domain_values('classAuditMode','ContribWithdraw','' );
end;
/
begin
add_domain_values('keywords2CopyUponExercise','CCPCollateralPolicy','All keywords specified for this domain name will be copied over to the resulting trade when an option is exercised' );
end;
/
begin
add_domain_values('productType','ShareClass','' );
end;
/
begin
add_domain_values('productType','Series','' );
end;
/
begin
add_domain_values('productType','Mandate','' );
end;
/
begin
add_domain_values('productType','SubscripRedemp','' );
end;
/
begin
add_domain_values('productType','ContribWithdraw','' );
end;
/
begin
add_domain_values('domainName','bookAttribute.OfficialPL Treatment','' );
end;
/
begin
add_domain_values('bookAttribute.OfficialPL Treatment','Exclude','' );
end;
/
begin
add_domain_values('tradeKeyword','OfficialPL Treatment','Indicates whether this OTC trade is included or excluded from the Official PL. By default trade is included.' );
end;
/
begin
add_domain_values('domainName','keyword.OfficialPL Treatment','' );
end;
/
begin
add_domain_values('keyword.OfficialPL Treatment','Unrealized Only','' );
end;
/
begin
add_domain_values('keyword.OfficialPL Treatment','Exclude','' );
end;
/
begin
add_domain_values('FutureOptionEquityIndex.Pricer','PricerBlack1FAnalyticDiscreteVanilla','Analytic Black-Scholes pricer for european options using discrete (escrowed) dividend or continuous yield' );
end;
/
begin
add_domain_values('FutureOptionEquityIndex.Pricer','PricerBlack1FFiniteDifference','Finite difference pricer for american or european options' );
end;
/
begin
add_domain_values('FutureOptionEquity.Pricer','PricerBlack1FAnalyticDiscreteVanilla','European Analytic Pricer following the Black-Scholes model' );
end;
/
begin
add_domain_values('FutureOptionEquity.Pricer','PricerBlack1FFiniteDifference','Finite Difference Pricer for single asset european or american or bermudan option' );
end;
/
begin
add_domain_values('SubscripRedemp.subtype','Subscription','Subscription' );
end;
/
begin
add_domain_values('SubscripRedemp.subtype','Redemption','Redemption' );
end;
/
begin
add_domain_values('ContribWithdraw.subtype','Contribution','Contribution' );
end;
/
begin
add_domain_values('ContribWithdraw.subtype','Withdrawal','Withdrawal' );
end;
/
begin
add_domain_values('engineName','LimitEngine','' );
end;
/
begin
add_domain_values('eventClass','PSEventRiskOutputChange','' );
end;
/
begin
add_domain_values('riskAnalysis','Benchmark','Benchmark Analysis' );
end;
/
begin
add_domain_values('riskAnalysis','WhatIf','WhatIf Analysis' );
end;
/
begin
add_domain_values('scheduledTask','AM_UPDATE_SR_TRADES_FX_EXPOSURE','' );
end;
/
begin
add_domain_values('applicationName','ImportMessageEngine','ImportMessageEngine' );
end;
/
begin
add_domain_values('riskPresenter','Benchmark','Benchmark Analysis' );
end;
/
begin
add_domain_values('MTMFeeType','CASH_SETTLE_FEE','' );
end;
/
begin
add_domain_values('domainName','engineserver.types','Different types of engine servers' );
end;
/
begin
add_domain_values('domainName','engineserver.unmanaged.types','Different types of unmanaged engine servers' );
end;
/
begin
add_domain_values('domainName','EngineServer.instances','Instances for each engineserver' );
end;
/
begin
add_domain_values('domainName','PositionKeepingServer.instances','Specific engines which can only be ran on positionkeepingserver' );
end;
/
begin
add_domain_values('domainName','PositionKeepingServer.engines','Specific engines which can only be ran on positionkeepingserver' );
end;
/
begin
add_domain_values('engineParam','CLASS_NAME','Class name for a given engine' );
end;
/
begin
add_domain_values('engineParam','INSTANCE_NAME','Instance which an engine should belong to' );
end;
/
begin
add_domain_values('engineParam','STARTUP','Whether an engine should start on a given instance' );
end;
/
begin
add_domain_values('engineParam','DISPLAY_NAME','The name which an engine should be displayed with on the engine manager' );
end;
/
begin
add_domain_values('engineserver.types','EngineServer','Default location of all engines' );
end;
/
begin
add_domain_values('engineserver.types','PositionKeepingServer','Engines dealing with keeping positions' );
end;
/
begin
add_domain_values('engineserver.unmanaged.types','PositionKeepingServer','Engines dealing with keeping positions' );
end;
/
begin
add_domain_values('engineParam','config','Configuration for engines' );
end;
/
begin
add_domain_values('PositionKeepingServer.engines','PositionKeepingPersistenceEngine','' );
end;
/
/* diff from other modules */ 

begin
	add_domain_values('PositionKeepingServer.engines','LiquidityPositionPersistenceEngine','' );
end;
/
begin
	add_domain_values('scheduledTask','UNLOAD_SAVED_CALCULATIONSERVER','pre-saved analysis output on calculation server' );
end;
/
begin
add_domain_values('domainName','DTCCGTR_Collateral_Version','The DTCC collateral module version (to be include in message sent to DTCC)' );
end;
/
begin
add_domain_values('DTCCGTR_Collateral_Version','Coll1.0','The DTCC collateral module version (to be include in message sent to DTCC)') ;
end;
/
begin
add_domain_values('REPORT.Types','DTCCGTRCollateralLink','' );
end;
/
begin
add_domain_values('REPORT.Types','DTCCGTRCollateralValue','' );
end;
/
begin
add_domain_values('REPORT.Types','DTCCGTRCollateralAggregatedValue','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSIndexTranche_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSNthLoss_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSNthLoss_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CreditDefaultIndex_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CreditDefaultSwap_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CreditDefaultIndex_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSNthDefault_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CreditDefaultSwap_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSIndexTranche_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSNthDefault_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FRA_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','IRSwap_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','IRSwap_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CapFloor_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','IRSExotic_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FRA_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','Swaption_NovationTrade_PET.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CapFloor_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','IRSExotic_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','Swaption_NovationTrade_Confirm.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FXO_Exotic_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FX_SingleLeg_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FX_Option_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CreditDefaultIndex_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSNthDefault_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CreditDefaultSwap_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSNthLoss_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSIndexTranche_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','Swaption_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CapFloor_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FRA_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','IRSwap_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','IRSExotic_Amendment_RT.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FX_SingleLeg_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FX_Option_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FXO_Exotic_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSNthDefault_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CreditDefaultIndex_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSNthLoss_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CreditDefaultSwap_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CDSIndexTranche_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','Swaption_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','FRA_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','IRSExotic_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','IRSwap_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('DTCCGTR.Templates','CapFloor_Amendment_Snapshot.xml','' );
end;
/
begin
add_domain_values('workflowRuleTrade','DTCCGTRSetDFAReportingParty','sets the ReportingParty keyword on the trade' );
end;
/
begin
add_domain_values('workflowRuleTrade','DTCCGTRSetDFANovationFeeReportingParty','sets the NovationFeeReportingParty keyword on the trade' );
end;
/
begin
add_domain_values('workflowRuleTrade','DTCCGTRSetUTI','sets the UTI keywords on the trade' );
end;
/
begin
add_domain_values('workflowRuleTrade','DTCCGTRSetEmirUTIGeneratingParty','sets the EMIR UTI Generating Party' );
end;
/
begin
add_domain_values('workflowRuleTrade','DTCCGTRSetEmirReportingRegime','sets the EMIR reporting regime if not already set' );
end;
/
begin
add_domain_values('workflowRuleTrade','DTCCGTRSetReportingRegimes','sets the EMIR and Dodd-Frank reporting regimes if not already set' );
end;
/
begin
add_domain_values('workflowRuleTrade','DTCCGTRSetNovationChildType','sets the type of novations children trades' );
end;
/
begin
add_domain_values('workflowRuleTrade','DTCCGTRRetract','Used to RETRACT from a TERMINATION, EXERCISE, EXPIRATION or CANCELATION' );
end;
/
begin
add_domain_values('domainName','DTCCGTRRemoveSubActionMessageRule','This domain lists the static data filters that must be validated for triggering the message rule DTCCGTRRemoveSubAction' );
end;
/
begin
add_domain_values('CustomStaticDataFilter','DTCCGTR','Static Data Filter specific to DTCCGTR' );
end;
/
begin
add_domain_values('DTCC-GTR-RelevantJurisdictionsByPurpose','RT','CFTC' );
end;
/
begin
add_domain_values('DTCC-GTR-RelevantJurisdictionsByPurpose','PET','CFTC' );
end;
/
begin
add_domain_values('DTCC-GTR-RelevantJurisdictionsByPurpose','Confirm','CFTC' );
end;
/
begin
add_domain_values('DTCC-GTR-RelevantJurisdictionsByPurpose','Snapshot','CFTC,ESMA' );
end;
/
begin
add_domain_values('DTCC-GTR-RelevantJurisdictionsByPurpose','RT-PET','CFTC' );
end;
/
begin
add_domain_values('DTCC-GTR-RelevantJurisdictionsByPurpose','PET-Confirm','CFTC' );
end;
/
begin
add_domain_values('DTCC-GTR-RelevantJurisdictionsByPurpose','RT-PET-Confirm','CFTC' );
end;
/
begin
add_domain_values('DTCC-GTR-TradeRetractableStatus','CANCELED','' );
end;
/
begin
add_domain_values('multiMessageFormatType','DTCCGTR','DTCCGTR must generate multiple messages for FXSwap' );
end;
/
begin
add_domain_values('domainName','InventorySecBucketFactory','' );
end;
/
begin
add_domain_values('InventorySecBucketFactory','ProductSubtypePersistent','New position balance types driven by trade subtypes' );
end;
/
begin
add_domain_values('scheduledTask','EOD_OFFICIALPL','End of day OfficialPLAnalysis Marking.' );
end;
/
begin
add_domain_values('scheduledTask','OFFICIALPLBOOTSTRAP','BootStrap process marking.' );
end;
/
begin
add_domain_values('scheduledTask','OFFICIALPLCORRECTIONS','OfficialPLAnalysis Marking Corrections.' );
end;
/
begin
add_domain_values('scheduledTask','OFFICIALPLPURGEMARKS','OfficialPLAnalysis Purge Marks.' );
end;
/
begin
add_domain_values('scheduledTask','OFFICIALPLEXPORT','OfficialPLAnalysis Export Report.' );
end;
/
begin
add_domain_values('scheduledTask','PL_GREEKS_INPUT','Scheduled task to create greeks for Live PL.' );
end;
/
begin
add_domain_values('riskAnalysis','OfficialPL','' );
end;
/
begin
add_domain_values('reportWindowPlugins:tradeBrowser','SecFinanceTradeReportExtension','' );
end;
/
begin
add_domain_values('riskPresenter','OfficialPL','OfficialPL Analysis' );
end;
/
begin
add_domain_values('function','CreateModifyOfficialPLConfig','Allow User to Add/Modify/delete OfficialPLConfig' );
end;
/
begin
add_domain_values('function','ViewOfficialPLConfig','Allow User to view any OfficialPLConfig' );
end;
/
begin
add_domain_values('function','RemoveResetPLConfig','Allow User to delete OfficialPLConfig Marks' );
end;
/
begin
add_domain_values('function','ViewResetPLConfig','Allow User to view ResetPLConfig' );
end;
/
begin
add_domain_values('plMeasure','Unrealized_MTM_PnL','' );
end;
/
begin
add_domain_values('plMeasure','Unrealized_Accrual_PnL','' );
end;
/
begin
add_domain_values('plMeasure','Unrealized_Accretion_PnL','' );
end;
/
begin
add_domain_values('plMeasure','Unrealized_Other_PnL','' );
end;
/
begin
add_domain_values('plMeasure','Realized_MTM_PnL','' );
end;
/
begin
add_domain_values('plMeasure','Realized_Accrual_PnL','' );
end;
/
begin
add_domain_values('plMeasure','Realized_Other_PnL','' );
end;
/
begin
add_domain_values('plMeasure','Unrealized_PnL_Base','' );
end;
/
begin
add_domain_values('plMeasure','Realized_PnL_Base','' );
end;
/
begin
add_domain_values('plMeasure','Unrealized_MTM_PnL_Base','' );
end;
/
begin
add_domain_values('plMeasure','Unrealized_Accrual_PnL_Base','' );
end;
/
begin
add_domain_values('plMeasure','Unrealized_Accretion_PnL_Base','') ;
end;
/
begin
add_domain_values('plMeasure','Unrealized_Other_PnL_Base','');
end;
/
begin
add_domain_values('plMeasure','Realized_MTM_PnL_Base','');
end;
/
begin
add_domain_values('plMeasure','Realized_Accrual_PnL_Base','');
end;
/
begin
add_domain_values('plMeasure','Realized_Accretion_PnL_Base','');
end;
/
begin
add_domain_values('plMeasure','Realized_Other_PnL_Base','');
end;
/
begin
add_domain_values('PricerMeasurePnlAllEOD','UnrealizedMTM','');
end;
/
begin
add_domain_values('PricerMeasurePnlAllEOD','UnrealizedAccrual','');
end;
/
begin
add_domain_values('PricerMeasurePnlAllEOD','UnrealizedAccretion','');
end;
/
begin
add_domain_values('PricerMeasurePnlAllEOD','UnrealizedOther','');
end;
/
begin
add_domain_values('PricerMeasurePnlAllEOD','RealizedMTM','');
end;
/
begin
add_domain_values('PricerMeasurePnlAllEOD','RealizedAccrual','');
end;
/
begin
add_domain_values('PricerMeasurePnlAllEOD','RealizedAccretion','');
end;
/
begin
add_domain_values('PricerMeasurePnlAllEOD','RealizedOther','');
end;
/
begin
add_domain_values('engineserver.types','ERSLimitServer','ERS Limit Server Engine Container');
end;
/
begin
add_domain_values('engineserver.types','ERSRiskServer','ERS Risk Server Engine Container');
end;
/
begin
add_domain_values('CollateralExposure.subtype','PAI','');
end;
/
begin
add_domain_values('CollateralExposure.subtype','Maintenance Fee','');
end;
/
begin
add_domain_values('CollateralExposure.subtype','Swap Exposure','');
end;
/
begin
add_domain_values('tradeKeyword','VM_CASH_OFFSET','');
end;
/
begin
add_domain_values('tradeKeyword','CET_Subtype','');
end;
/
begin
add_domain_values('tradeKeyword','optimizationConfig','');
end;
/
begin
add_domain_values('legalAgreementType','VM','');
end;
/
begin
add_domain_values('legalAgreementType','IM','');
end;
/
begin
add_domain_values('eventClass','PSEventCollateralEngineCommand','');
end;
/
begin
add_domain_values('classAuthMode','LiabilityGroupContext','');
end;
/
begin
add_domain_values('classAuditMode','LiabilityGroupContext','');
end;
/
begin
add_domain_values('classAuthMode','CollateralConfig','');
end;
/
begin
add_domain_values('classAuditMode','CollateralConfig','');
end;
/
begin
add_domain_values('function','RemoveMarginCallCreditRating','Access permission to remove MarginCallCreditRating');
end;
/
begin
add_domain_values('function','CreateMarginCallCreditRating','Access permission to create MarginCallCreditRating');
end;
/
begin
add_domain_values('function','AuthorizeCollateralConfig','Access permission to authorize Collateral Config');
end;
/
begin
add_domain_values('function','ModifyCollateralConfig','Access permission to modify Collateral Config');
end;
/
begin
add_domain_values('function','CreateCollateralConfig','Access permission to create Collateral Config');
end;
/
begin
add_domain_values('function','RemoveCollateralConfig','Access permission to remove Collateral Config');
end;
/
begin
add_domain_values('mccAdditionalField','ACCOUNT_NAME','Contains the account name');
end;
/
begin
add_domain_values('domainName','mccAdditionalField.EXCLUDE_SECLENDING_INTEREST','');
end;
/
begin
add_domain_values('mccAdditionalField.EXCLUDE_SECLENDING_INTEREST','True','');
end;
/
begin
add_domain_values('mccAdditionalField.EXCLUDE_SECLENDING_INTEREST','False','');
end;
/
begin
add_domain_values('domainName','CollateralContext.DEFAULT_LOAD_METHOD','');
end;
/
begin
add_domain_values('CollateralContext.DEFAULT_LOAD_METHOD','LOAD_METHOD_SIMPLE','');
end;
/
begin
add_domain_values('CollateralContext.DEFAULT_LOAD_METHOD','LOAD_METHOD_REFRESH_SIMPLE','');
end;
/
begin
add_domain_values('CollateralContext.DEFAULT_LOAD_METHOD','LOAD_METHOD_FULL','');
end;
/
begin
add_domain_values('CollateralContext.DEFAULT_LOAD_METHOD','LOAD_METHOD_REFRESH_FULL','');
end;
/
begin
add_domain_values('domainName','Collateral.Pool.Constraint','');
end;
/
begin
add_domain_values('Collateral.Optimization.AllocationRule','Collateral-Source','');
end;
/
begin
add_domain_values('Collateral.Optimization.Constraint','CollateralPool','');
end;
/
begin
add_domain_values('Collateral.Optimization.Constraint','Source','');
end;
/
begin
add_domain_values('Collateral.Pool.Constraint','Coupon','');
end;
/
begin
add_domain_values('Collateral.Pool.Constraint','Dividend','');
end;
/
begin
add_domain_values('Collateral.Pool.Constraint','MaximumUsage','');
end;
/
begin
add_domain_values('Collateral.Pool.Constraint','SDFilter','');
end;
/
begin
add_domain_values('Collateral.Pool.Constraint','Volatility','');
end;
/
begin
add_domain_values('domainName','NPVFlows','MTM flows that, among other things, require different transfer available date logic ');
end;
/
begin
add_domain_values('NPVFlows','NPV_ADJUSTED','');
end;
/
begin
add_domain_values('securityCode','SFR-8A','A value of  True  designates this fund to SFR-8A column.');
end;
/
begin
add_domain_values('securityCode','SFR-8B','A value of  True  designates this fund to SFR-8B column.');
end;
/
begin
add_domain_values('securityCode','Collateral Investment','A value of  False  designates this fund to SFR-8C column.');
end;
/
begin
add_domain_values('FundAttributes','SFR-8A','A value of  True  designates this fund to SFR-8A column.');
end;
/
begin
add_domain_values('FundAttributes','SFR-8B','A value of  True  designates this fund to SFR-8B column.');
end;
/
begin
add_domain_values('FundAttributes','Collateral Investment','A value of  False  designates this fund to SFR-8C column.');
end;
/
begin
add_domain_values('domainName','SFR7BMovementType','Inventory movement types to be considered when computing the SFR 7B');
end;
/
begin
add_domain_values('domainName','SFR7CMovementType','Inventory movement types to be considered when computing the SFR 7C');
end;
/
begin
add_domain_values('domainName','SFR7CBookType','Book types to be considered when computing the SFR 7C' );
end;
/
begin
add_domain_values('classAuthMode','ClientOnboardingData','' );
end;
/
begin
add_domain_values('function','CreateModifyOnboardingTemplate','' );
end;
/
begin
add_domain_values('function','ModifyOnboardingTemplate','' );
end;
/
begin
add_domain_values('function','CreateOnboardingObjects','' );
end;
/
begin
add_domain_values('function','AuthorizeClientOnboardingData','Access Permissions function for authorizing ClientOnboardingData objects' );
end;
/
begin
add_domain_values('domainName','NPVReversalFlows','Reversal equivalents of NPVFlows' );
end;
/
begin
add_domain_values('tradeKeyword','CCPSegregationAccount','' );
end;
/
begin
add_domain_values('MirrorKeywords','CCPSegregationAccount','' );
end;
/
begin
add_domain_values('leAttributeType','LCHCVRSenderCode','' );
end;
/
begin
add_domain_values('leAttributeType','CFTCReporting','' );
end;
/
begin
add_domain_values('accountProperty','Description','' );
end;
/
begin
add_domain_values('accountProperty.Description','Clearing','' );
end;
/
begin
add_domain_values('accountProperty.Description','Cash','' );
end;
/
begin
add_domain_values('accountProperty.Description','Internal','' );
end;
/
begin
add_domain_values('accountProperty.ClearingCashAccount','True','' );
end;
/
begin
add_domain_values('accountProperty.ClearingCashAccount','False','' );
end;
/
begin
add_domain_values('currencyDefaultAttribute','ClearingTransferSettleLag','' );
end;
/
begin
add_domain_values('currencyDefaultAttribute','ClearingTransferSettleLag','' );
end;
/
begin
add_domain_values('domainName','ClearingEligible','' );
end;
/
begin
add_domain_values('currencyDefaultAttribute','ClearingEligible','' );
end;
/
begin
add_domain_values('ClearingEligible','True','' );
end;
/
begin
add_domain_values('ClearingEligible','False','' );
end;
/
begin
add_domain_values('domainName','Clearing.Settlement.Ignore105','' );
end;
/
begin
add_domain_values('scheduledTask','CLEARING_MCC_CCY_UPGRADE','' );
end;
/
begin
add_domain_values('scheduledTask','CLEARING_ETD_VM','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_MCC_CCY_UPGRADE','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_MCC_CCY_UPGRADE_WARNING','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_INTRADAY_MARGIN_WARNING','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_INTRADAY_SETTLEMENT_WARNING','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_IMPORT_MARKET_DATA_WARNING','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_IMPORT_SCENARIO_SHIFTS_WARNING','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_INITIALIZE_TENORS_TABLE','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_INITIALIZE_TENORS_TABLE_WARNING','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_EXPORT_CVR_WORKSHEET_WARNING','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_IM_ACCT_UPGRADE_WARNING','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_EXCEPTION','' );
end;
/
begin
add_domain_values('eventType','EX_CLEARING_INFO','' );
end;
/
begin
add_domain_values('exceptionType','CLEARING_INTRADAY_SETTLEMENT_WARNING','' );
end;
/
begin
add_domain_values('exceptionType','CLEARING_MCC_CCY_UPGRADE','' );
end;
/
begin
add_domain_values('exceptionType','CLEARING_MCC_CCY_UPGRADE_WARNING','' );
end;
/
begin
add_domain_values('exceptionType','CLEARING_IMPORT_MARKET_DATA_WARNING','' );
end;
/
begin
add_domain_values('exceptionType','CLEARING_EXPORT_CVR_WORKSHEET_WARNING','' );
end;
/
begin
add_domain_values('exceptionType','CLEARING_IMPORT_SCENARIO_SHIFTS_WARNING','' );
end;
/
begin
add_domain_values('exceptionType','CLEARING_INITIALIZE_TENORS_TABLE_WARNING','' );
end;
/
begin
add_domain_values('exceptionType','CLEARING_EXCEPTION','' );
end;
/
begin
add_domain_values('exceptionType','CLEARING_INFO','' );
end;
/
begin
add_domain_values('measuresForAdjustment','OTE','' );
end;
/
begin
add_domain_values('measuresForAdjustment','OTE_REV','' );
end;
/
begin
add_domain_values('measuresForAdjustment','REALIZED_PL','' );
end;
/
begin
add_domain_values('measuresForAdjustment','REALIZED_PL_REV','' );
end;
/
begin
add_domain_values('REPORT.Types','UnderMarginedAccount','' );
end;
/
begin
add_domain_values('mccAdditionalField.SEPARATE_VM_SETTLEMENT','True','' );
end;
/
begin
add_domain_values('mccAdditionalField.SEPARATE_VM_SETTLEMENT','False','' );
end;
/
begin
add_domain_values('mccAdditionalField.PRODUCT_TYPE','CDX','' );
end;
/
begin
add_domain_values('mccAdditionalField.PRODUCT_TYPE','ETD','' );
end;
/
begin
add_domain_values('mccAdditionalField.IM_IMPORT_CURRENCY','Converted','' );
end;
/
begin
add_domain_values('mccAdditionalField.IM_IMPORT_CURRENCY','Native','' );
end;
/
begin
add_domain_values('domainName','leAttributeType.LCHRemoteFolderStructure','' );
end;
/
begin
add_domain_values('leAttributeType.LCHRemoteFolderStructure','Dynamic','' );
end;
/
begin
add_domain_values('leAttributeType.LCHRemoteFolderStructure','Static','' );
end;
/
begin
add_domain_values('MsgAttributes','CVRWorksheetExportedAdviceDocumentID','' );
end;
/
begin
add_domain_values('MsgAttributes','CVRWorksheetOriginalID','' );
end;
/
begin
add_domain_values('MsgAttributes','CVRWorksheetResponseDescription','' );
end;
/
begin
add_domain_values('MsgAttributes','CVRWorksheetResponseAction','' );
end;
/
begin
add_domain_values('MsgAttributes','CVRWorksheetResponseMessageID','' );
end;
/
begin
add_domain_values('MsgAttributes','CVRWorksheetAckMessageID','' );
end;
/
begin
add_domain_values('MsgAttributes','CVRWorksheetExternalResponseMessageID','' );
end;
/
begin
add_domain_values('MsgAttributes','CVRWorksheetExternalSentBy','' );
end;
/
begin
add_domain_values('MsgAttributes','CVRWorksheetExternalSentTo','' );
end;
/
begin
add_domain_values('workflowRuleMessage','PrepareCVRForSend','Enriches the CVR_WORKSHEET message with information to be sent to the CCP' );
end;
/
begin
add_domain_values('workflowRuleMessage','MatchCollateralAllocationResponse','Processes an incoming collateral allocation message and matches it to an existing CVR_WORKSHEET one' );
end;
/
begin
add_domain_values('messageStatus','ACCEPTED','' );
end;
/
begin
add_domain_values('addressMethod','LCHCVR','' );
end;
/
begin
add_domain_values('domainName','Clearing.Statement.resourceLocations','Collection of Spring resource locations to configure the Clearing Statement' );
end;
/
begin
add_domain_values('Clearing.Statement.resourceLocations','classpath:config/ClearingStatementFactory.xml','' );
end;
/
begin
add_domain_values('domainName','Clearing.Statement.profiling','Set it to true to activate some basic profiling characteristics. If set to false, or to multiple values, or empty, it is taken as false' );
end;
/

begin
add_domain_values('domainName','transferSettledStatus','' );
end;
/
begin
add_domain_values('transferStatus','SETTLED','' );
end;
/
begin
add_domain_values('eventFilter','IgnoreProductsForTransferEventFilter',' filter for Sender Engine' );
end;
/
begin
add_domain_values('domainName','Clearing.Transfer.ignoreProducts','Product names to be ignored by the TransferEngine and other downstream processes' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureEquityIndex','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionEquityIndex','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureCDSIndex','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureEquity','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionBond','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureSwap','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureFX','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionFX','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureCommodity','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionEquity','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionVolatility','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionIndex','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureMM','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionSwap','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureDividend','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureStructuredFlows','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionMM','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureVolatility','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionDividend','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureOptionCommodity','' );
end;
/
begin
add_domain_values('Clearing.Transfer.ignoreProducts','FutureBond','' );
end;
/
begin
add_domain_values('tradeKeyword','ClearingMirroringBehavior','' );
end;
/
begin
add_domain_values('MirrorKeywords','ClearingMirroringBehavior','' );
end;
/
begin
add_domain_values('domainName','keyword.ClearingMirroringBehavior','' );
end;
/
begin
add_domain_values('keyword.ClearingMirroringBehavior','MirroredAccount','Default value (OTC style)' );
end;
/
begin
add_domain_values('keyword.ClearingMirroringBehavior','SingleAccount','Single account (ETD style)' );
end;
/
begin
add_domain_values('NPVFlows','OTE','Open Trade Equity' );
end;
/
begin
add_domain_values('NPVReversalFlows','OTE_REV','Open Trade Equity Reversal' );
end;
/
begin
add_domain_values('domainName','Clearing.CDML.producerNames','List of available CDML producer names' );
end;
/
begin
add_domain_values('domainName','DTCC-GTR-NotReportingPartyRole','' );
end;
/
begin
add_domain_values('domainName','DTCC-GTR-ESMA-CorporateSectors','List of available regulatory corporate sectors for EMIR' );
end;
/
begin
add_domain_values('domainName','DTCC-GTR-ReportingAdapter','Setup of Calypso Base Reporting Adapter' );
end;
/
begin
add_domain_values('leAttributeType','EMIR-Eligible','Boolean that can force an non-EEA entity to be EMIR eligible' );
end;
/
begin
add_domain_values('leAttributeType','DFA-Eligible','Boolean that can force an non-US entity to be DFA eligible' );
end;
/
begin
add_domain_values('leAttributeType','DTCCGTR-ReportingAgent','Short name of the legal entity which is the reporting agent for current legal entity (which must be a PO)' );
end;
/
begin
add_domain_values('leAttributeType','EMIR-ReportingDelegation','When set to Full, indicates that the legal entity (with role counterparty) gives a full delegation of reporting to PO' );
end;
/
begin
add_domain_values('leAttributeType','DFA-Counterparty-Masking','Boolean that indicates if this legal entity (with role counterparty) should be masked to Dodd-Frank regulators' );
end;
/
begin
add_domain_values('leAttributeType','EMIR-Counterparty-Masking','Boolean that indicates if this legal entity (with role counterparty) should be masked to ESMA' );
end;
/
begin
add_domain_values('leAttributeType','EMIR-UTIGeneratingParty-Agreement','Indicates an UTI generating party agreement between PO and the given legal entity. If set to ProcessingOrg, PO will always be generating party, if set to Counterparty, the counterparty will always be generating party' );
end;
/
begin
add_domain_values('leAttributeType','ESMA-CorporateSector','Provides the corporate sector of legal entity for ESMA' );
end;
/
begin
add_domain_values('leAttributeType','ESMA-ExceedsClearingThreshold','Boolean that indicates whether a non-financial entity has exceeded its clearing threshold' );
end;
/
begin
add_domain_values('exceptionType','DTCC_FATAL','' );
end;
/
begin
add_domain_values('eventType','EX_DTCC_FATAL','' );
end;
/
begin
add_domain_values('exceptionType','DTCC_ERROR','' );
end;
/
begin
add_domain_values('eventType','EX_DTCC_ERROR','' );
end;
/
begin
add_domain_values('exceptionType','DTCC_WARNING','' );
end;
/
begin
add_domain_values('eventType','EX_DTCC_WARNING','' );
end;
/
begin
add_domain_values('exceptionType','DTCC_INFORMATION','' );
end;
/
begin
add_domain_values('eventType','EX_DTCC_INFORMATION','' );
end;
/
begin
add_domain_values('DTCC-GTR-ESMA-CorporateSectors','AlternativeInvestmentFund','' );
end;
/
begin
add_domain_values('DTCC-GTR-ESMA-CorporateSectors','AssuranceUndertaking','' );
end;
/
begin
add_domain_values('DTCC-GTR-ESMA-CorporateSectors','CreditInstitution','' );
end;
/
begin
add_domain_values('DTCC-GTR-ESMA-CorporateSectors','InstitutionForOccupationalRetirementProvision','' );
end;
/
begin
add_domain_values('DTCC-GTR-ESMA-CorporateSectors','InsuranceUndertaking','' );
end;
/
begin
add_domain_values('DTCC-GTR-ESMA-CorporateSectors','InvestmentFirm','' );
end;
/
begin
add_domain_values('DTCC-GTR-ESMA-CorporateSectors','ReinsuranceUndertaking','' );
end;
/
begin
add_domain_values('DTCC-GTR-ESMA-CorporateSectors','UCITS','' );
end;
/
begin
add_domain_values('leAttributeType','NFA_ID','Provides the NFA (National Future Association) identifier assigned to the legal entity' );
end;
/
begin
add_domain_values('leAttributeType','ANONYMOUS_DTCC_LE_ID','Provides a to identifier for a counterparty that we do not want to disclose to DTCC GTR' );
end;
/
begin
add_domain_values('DTCC-GTR-NotReportingPartyRole','DoddFrank','' );
end;
/
begin
add_domain_values('tradeKeyword','AmendmentTradeDatetime','' );
end;
/
begin
add_domain_values('tradeKeyword','AmendmentEffectiveDate','' );
end;
/
begin
add_domain_values('tradeKeyword','Novation_ChildType','' );
end;
/
begin
add_domain_values('CountryAttributes','EEARegion','' );
end;
/
begin
add_domain_values('domainName','ERSLimitServer.engines','' );
end;
/
begin
add_domain_values('domainName','ERSRiskServer.engines','' );
end;
/
begin
add_domain_values('domainName','ERSLimitServer.instances','' );
end;
/
begin
add_domain_values('domainName','ERSRiskServer.instances','' );
end;
/
begin
add_domain_values('engineserver.types','ERSLimitServer','ERS Limit Server Engine Container' );
end;
/
begin
add_domain_values('engineserver.types','ERSRiskServer','ERS Risk Server Engine Container' );
end;
/
begin
add_domain_values('ERSLimitServer.engines','ERSLimitEngine','' );
end;
/
begin
add_domain_values('ERSLimitServer.engines','ERSCreditEngine','' );
end;
/
begin
add_domain_values('ERSRiskServer.engines','RiskEngineBroker','' );
end;
/
begin
add_domain_values('ERSLimitServer.engines','DataWarehouseEngine','' );
end;
/
begin
add_domain_values('ERSRiskServer.engines','DataWareHouseRiskEngine','' );
end;
/


/* diff ends here */


UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='004',
        version_date=TO_DATE('03/09/2014','DD/MM/YYYY')
/

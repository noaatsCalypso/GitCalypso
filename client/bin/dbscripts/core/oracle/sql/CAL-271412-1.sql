/* CAL-79500 fix broken position_ids for trade_open_qty from BZ 39262 upgrade script */
/*   this MUST be executed before the CAL-73220 upgrade script */

update trade_open_qty t
set position_id = (select position_id from pl_position p where t.book_id = p.book_id and t.product_id = p.product_id and  t.liq_agg_id = p.liq_agg_id)
where position_id <> (select position_id from pl_position p where t.book_id = p.book_id and t.product_id = p.product_id and  t.liq_agg_id = p.liq_agg_id)
;

update trade_openqty_hist t
set position_id = (select position_id from pl_position p where t.book_id = p.book_id and t.product_id = p.product_id and  t.liq_agg_id = p.liq_agg_id)
where position_id <> (select position_id from pl_position p where t.book_id = p.book_id and t.product_id = p.product_id and  t.liq_agg_id = p.liq_agg_id)
;

update liq_position t
set position_id = (select position_id from pl_position p where t.book_id = p.book_id and t.product_id = p.product_id and  t.liq_agg_id = p.liq_agg_id)
where position_id <> (select position_id from pl_position p where t.book_id = p.book_id and t.product_id = p.product_id and  t.liq_agg_id = p.liq_agg_id)
;

update liq_position_hist t
set position_id = (select position_id from pl_position p where t.book_id = p.book_id and t.product_id = p.product_id and  t.liq_agg_id = p.liq_agg_id)
where position_id <> (select position_id from pl_position p where t.book_id = p.book_id and t.product_id = p.product_id and  t.liq_agg_id = p.liq_agg_id)
;

/* end */

/* CAL-73220 */
/* pl_position table */

CREATE OR REPLACE PROCEDURE add_table_pl_mark
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE PL_MARK (MARK_ID NUMBER(*,0) NOT NULL , TRADE_ID NUMBER(*,0) NOT NULL, PRICING_ENV_NAME VARCHAR2(32) NOT NULL , VALUATION_DATE TIMESTAMP (6) NOT NULL , POSITION_OR_TRADE VARCHAR2(128) NOT NULL , POSITION_OR_TRADE_VERSION NUMBER(*,0) NOT NULL , ENTERED_DATETIME TIMESTAMP (6) NOT NULL , UPDATE_DATETIME TIMESTAMP (6), VERSION_NUM NUMBER(*,0) NOT NULL , ENTERED_USER VARCHAR2(32) NOT NULL , BOOK_ID NUMBER(*,0) NOT NULL , POSITION_TIME VARCHAR2(64), MARKET_TIME VARCHAR2(64), COMMENTS VARCHAR2(128), SUB_ID VARCHAR2(256), STATUS VARCHAR2(32))  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 STORAGE(INITIAL 65536 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)';
    END IF;
END add_table_pl_mark;
;

BEGIN
add_table_pl_mark('pl_mark');
END;
;


drop PROCEDURE add_table_pl_mark
;


begin
  add_column_if_not_exists('pl_position','incep_trade_date','timestamp');
end;
;

begin
  add_column_if_not_exists('pl_position','entered_date','timestamp');
end;
;



create or replace procedure pl_position_tmp  as

 x date;
 y date;
 z date;
 a timestamp;

CURSOR c1 IS
        SELECT * from pl_position where incep_trade_date is null and entered_date is null;

 BEGIN

        FOR I IN C1 LOOP
                                select cast (min(trade_date) as date) into x from trade_open_qty where 
                                                I.product_id = trade_open_qty.product_id AND
                                                I.book_id = trade_open_qty.book_id AND
                                                I.liq_agg_id = trade_open_qty.liq_agg_id;
                select cast (min(valuation_date) as date) into y from pl_mark where I.position_id = pl_mark.trade_id;
                select nvl(y, x) into y from dual;

                select decode ( sign(x-y), -1,x,y) into z from dual;

                select cast ( z as timestamp) into a from dual;


                update pl_position sp set sp.INCEP_TRADE_DATE = a, sp.ENTERED_DATE = a
                where sp.product_id = I.product_id and sp.book_id = I.book_id and sp.liq_agg_id = I.liq_agg_id;
        END LOOP;
        EXCEPTION
                when others then
                dbms_output.put_line('Error occured ' || sqlerrm); 
END;
;

begin
pl_position_tmp ;
end;
;

drop procedure pl_position_tmp
;

/* position table */

begin
  add_column_if_not_exists('position','incep_trade_date','timestamp');
end;
;

begin
  add_column_if_not_exists('position','entered_date','timestamp');
end;
;

create or replace procedure position_tmp as
 x date;
 y date;
 z date;
 a timestamp;
CURSOR c1 IS
        SELECT * from position where incep_trade_date is null and entered_date is null;
 BEGIN
    	FOR I IN C1 LOOP
		select cast (min(settle_date) as date) into x from settle_position where I.product_id = settle_position.product_id 
			and I.book_id = settle_position.book_id and I.pos_agg_id = settle_position.pos_agg_id;
		select cast (min(valuation_date) as date) into y from pl_mark where I.position_id = pl_mark.trade_id;
		select nvl(y, x) into y from dual;
       	select decode ( sign(x-y), -1,x,y) into z from dual;
     	select cast ( z as timestamp) into a from dual;
		update position sp set sp.INCEP_TRADE_DATE = a, sp.ENTERED_DATE = a
		where sp.position_id = I.position_id;
	   	END LOOP;
	EXCEPTION
        	when others then
                dbms_output.put_line('Error occured ' || sqlerrm); 
	END;
;

begin
position_tmp;
end;
;

drop procedure position_tmp
;
/* settle_position table */

begin
  add_column_if_not_exists('settle_position','incep_trade_date','timestamp');
end;
;
begin
  add_column_if_not_exists('settle_position','entered_date','timestamp');
end;
;

create or replace procedure fbi as
begin
declare
  v_idx_name varchar(28);
  v_sql      varchar(256);
  x          number := 0;
  y          number := 0;
begin
      select count(*) into x from user_ind_columns where table_name = 'SETTLE_POSITION' and column_name = 'POSITION_ID';
       if x = 1 then
     select index_name into v_idx_name from user_ind_columns where table_name = 'SETTLE_POSITION' and column_name = 'POSITION_ID';
     v_sql := 'drop index '||v_idx_name;
     execute immediate v_sql;
  elsif
       (x = 0 ) then
     v_sql := 'create index idx_positionid on settle_position(position_id)';
     execute immediate v_sql;
  end if;
end;
end fbi;
;


begin
fbi;
end;
;



drop procedure fbi
;

create or replace procedure settle_position_tmp as
 x date;
 y date;
 z date;
 a timestamp;

CURSOR c1 IS
        SELECT * from settle_position where incep_trade_date is null and entered_date is null; 
		BEGIN
    	FOR I IN C1 LOOP
		x:= cast ( I.settle_date as date) ;
		select cast (min(valuation_date) as date) into y from pl_mark where I.position_id = pl_mark.trade_id;
		select nvl(y, x) into y from dual;
      	select decode ( sign(x-y), -1,x,y) into z from dual;
     	select cast ( z as timestamp) into a from dual;
		update settle_position sp set sp.INCEP_TRADE_DATE = a, sp.ENTERED_DATE = a
		where sp.position_id = I.position_id;
	   	END LOOP;
	EXCEPTION
        	when others then
                dbms_output.put_line('Error occured ' || sqlerrm); 
	END;
;

begin
settle_position_tmp;
end;
;

 
drop procedure settle_position_tmp
;

/* end */


UPDATE calypso_info
    SET major_version=11,
        minor_version=0,
        sub_version=0,
        patch_version='002',
        version_date=TO_DATE('02/07/2009','DD/MM/YYYY')
;

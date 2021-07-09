declare 
v_cnt number :=0;
begin
select count(*) into v_cnt from user_tables where table_name=upper('temp_table_cal_305182') ;
if v_cnt = 1 then
execute immediate 'DROP TABLE temp_table_cal_305182';
end if;
end;
/

create table temp_table_cal_305182 ( old_methodology varchar2(64), new_methodology varchar2(64)) 
/

insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'ACCRUAL','AmortizedCost')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'AFS','AmortizedValue')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'CASH','Cash')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'CASH_PL','AmortizedCost')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'HEDGING','FairValue')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'HTM','AmortizedCost')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'MTM','FairValue')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'NONE','None')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'TRADING','FairValue')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'TRADING_BY_CCY','FairValue')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'AmortizedCost_1','AmortizedCost')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'AmortizedCost_2','AmortizedCost')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'FairValue_1','FairValue')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'FairValue_2','FairValue')
;
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'FairValue_3','FairValue')
;


MERGE
INTO    pl_methodology_config_items trg
USING   (
        SELECT  m.CONFIG_NAME, m.DRIVER, m.BOOK_ID, m.PRODUCT_TYPE, m.METHODOLOGY_NAME, m.PRODUCT_SUB_TYPE, m.PRODUCT_EXTENDED_TYPE,  t.new_methodology 
        FROM    pl_methodology_config_items m,
                temp_table_cal_305182 t
        where   m.METHODOLOGY_NAME = t.old_methodology
        ) src
ON      (     trg.CONFIG_NAME = src.CONFIG_NAME
          and trg.DRIVER = src.DRIVER
          and trg.BOOK_ID = src.BOOK_ID
          and trg.PRODUCT_TYPE = src.PRODUCT_TYPE
          and trg.PRODUCT_SUB_TYPE = src.PRODUCT_SUB_TYPE
          and trg.PRODUCT_EXTENDED_TYPE = src.PRODUCT_EXTENDED_TYPE
        )
WHEN MATCHED THEN UPDATE
    SET trg.METHODOLOGY_NAME = src.new_methodology
;
/

/* update official_pl_mark table with new methodology names 1mm at a time in a loop */
begin
  loop
    update official_pl_mark m set m.methodology = (select t.new_methodology from temp_table_cal_305182 t where m.methodology = t.old_methodology ) 
    where exists (select 1 from temp_table_cal_305182 t where m.methodology = t.old_methodology )
    and rownum<=1000000;
  
    IF SQL%NOTFOUND THEN
      dbms_output.put_line('No rows remaining to update - exiting...');
      commit;
      EXIT;
    END IF;
  
    dbms_output.put_line('Updating (upto) 1mm mark rows...');
    commit;
  end loop;
end;
/

/* update official_pl_mark_hist table with new methodology names 1mm at a time in a loop */
begin
  loop
    update official_pl_mark_hist m set m.methodology = (select t.new_methodology from temp_table_cal_305182 t where m.methodology = t.old_methodology ) 
    where exists (select 1 from temp_table_cal_305182 t where m.methodology = t.old_methodology )
    and rownum<=1000000;
  
    IF SQL%NOTFOUND THEN
      dbms_output.put_line('No rows remaining to update - exiting...');
      commit;
      EXIT;
    END IF;
  
    dbms_output.put_line('Updating (upto) 1mm mark rows...');
    commit;
  end loop;
end;
/

MERGE
INTO    official_pl_aggregate_item trg
USING   (
        SELECT  m.agg_txn_id, m.agg_id, m.action, m.action_datetime, t.new_methodology 
        FROM    official_pl_aggregate_item m,
                temp_table_cal_305182 t
        where   m.methodology = t.old_methodology
        ) src
ON      (trg.agg_txn_id = src.agg_txn_id and trg.agg_id = src.agg_id and trg.action = src.action and trg.action_datetime = src.action_datetime)
WHEN MATCHED THEN UPDATE
    SET trg.methodology = src.new_methodology
;


drop table temp_table_cal_305182
/
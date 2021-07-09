 

/* CAL-77093, CAL-8761 Multiple liquidations per book/product */
/* create liq_config_name if not existing */
DECLARE l_exists INTEGER := 0;
BEGIN
    SELECT count(*) INTO l_exists FROM user_tables WHERE upper(table_name) = 'LIQ_CONFIG_NAME';
    IF l_exists = 0 THEN
    BEGIN
      EXECUTE IMMEDIATE 'CREATE TABLE liq_config_name (id number not null, name varchar2(32) not null, version number not null, CONSTRAINT PK_LIQ_CONFIG_NAME PRIMARY KEY ("ID"))';
    END;
    END IF;
END;
;

/* create default entry */
DECLARE l_exists INTEGER := 0;
BEGIN
    SELECT count(*) INTO l_exists FROM liq_config_name where id = 0;
    IF l_exists = 0 THEN
    BEGIN
      INSERT INTO liq_config_name(id, name, version) values (0, 'DEFAULT', 0);
    END;	
    END IF;
END;
;

DELETE FROM referring_object where rfg_obj_id IN (601,602)
;

/* CAL-97462 CAL-71386 Initialize new columns on liq_position and pl_position tables */
/* Update liq_position: all trades must be in trade. */
/* adding columns before updateing */
begin
  add_column_if_not_exists('liq_position', 'first_trade_date', 'timestamp null');
  add_column_if_not_exists('liq_position','second_trade_date','timestamp null');
  add_column_if_not_exists('liq_position_hist','first_trade_date','timestamp null');
  add_column_if_not_exists('liq_position_hist','second_trade_date', 'timestamp null');
  add_column_if_not_exists('pl_position','last_trade_date','timestamp null');
  add_column_if_not_exists('pl_position_hist','last_trade_date', 'timestamp null');
end;
;
update /*+ PARALLEL ( liq_position ) */  liq_position
set first_trade_date=NVL(first_trade_date,(select trade_date_time from trade where trade.trade_id=liq_position.first_trade)),
    second_trade_date=NVL(second_trade_date,(select trade_date_time from trade where trade.trade_id=liq_position.second_trade))
where (first_trade_date is null or second_trade_date is null)
  and is_deleted=0
;

update /*+ PARALLEL ( liq_position_hist ) */ liq_position_hist
set first_trade_date=NVL(first_trade_date,(select trade_date_time from trade where trade.trade_id=liq_position_hist.first_trade)),
    second_trade_date=NVL(second_trade_date,(select trade_date_time from trade where trade.trade_id=liq_position_hist.second_trade))
where (first_trade_date is null or second_trade_date is null)
and is_deleted=0
;
update /*+ PARALLEL ( liq_position_hist ) */ liq_position_hist
set first_trade_date=NVL(first_trade_date,(select trade_date_time from trade_hist where trade_hist.trade_id=liq_position_hist.first_trade)),
second_trade_date=NVL(second_trade_date,(select trade_date_time from trade_hist where trade_hist.trade_id=liq_position_hist.second_trade))
where (first_trade_date is null or second_trade_date is null)
and is_deleted=0
;

/* Update pl_position: join from both liq_position and liq_position_hist (pl_position_hist not used). */
CREATE TABLE pos_trade_date AS 
(select position_id,first_trade_date td from liq_position where is_deleted=0 union all 
select position_id,second_trade_date td from liq_position where is_deleted=0 union all
select position_id,first_trade_date  td from liq_position_hist where is_deleted=0 union all
select position_id,second_trade_date td from liq_position_hist where is_deleted=0)
;
create index aaa on pos_trade_date (position_id, td)
;
update /*+ PARALLEL ( pl_position  ) */ pl_position 
set last_trade_date=
(select max(td) from pos_trade_date where pos_trade_date.position_id=pl_position.position_id group by pos_trade_date.position_id)
where last_trade_date is null
;
DROP TABLE pos_trade_date
;


UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='003',
        version_date=TO_DATE('30/06/2010','DD/MM/YYYY')
;

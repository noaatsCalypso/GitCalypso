
/* CAL-77093, CAL-8761 Multiple liquidations per book/product */
/* create liq_config_name if not existing */
if not exists (select 1 from sysobjects where sysobjects.name = 'liq_config_name')
BEGIN
    EXEC ('CREATE TABLE liq_config_name (id numeric(18,0) not null, name varchar(32) not null, version numeric(18,0) not null, CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED(id))')
END
go

/* create default entry */
if not exists (SELECT 1 FROM liq_config_name where id = 0)
BEGIN
    INSERT INTO liq_config_name(id, name, version) values (0, 'DEFAULT', 0)
END	
go

DELETE FROM referring_object where rfg_obj_id IN (601,602)
go


/* CAL-97462 CAL-71386 Initialize new columns on liq_position and pl_position tables */
/* Update liq_position: all trades must be in trade. */
/* adding the columns before updating*/
add_column_if_not_exists 'liq_position' ,'first_trade_date', 'datetime null'
go
add_column_if_not_exists 'liq_position','second_trade_date', 'datetime null'
go
add_column_if_not_exists 'liq_position_hist','first_trade_date', 'datetime null'
go
add_column_if_not_exists 'liq_position_hist','second_trade_date', 'datetime null'
go
add_column_if_not_exists 'pl_position' ,'last_trade_date','datetime null'
go
add_column_if_not_exists 'pl_position_hist','last_trade_date','datetime null'
go

update liq_position
set first_trade_date=(select trade_date_time from trade (parallel 5) where trade.trade_id=liq_position.first_trade)
where first_trade_date is null
and is_deleted=0
go
update liq_position
set second_trade_date=(select trade_date_time from trade where trade.trade_id=liq_position.second_trade)
where second_trade_date is null
and is_deleted=0
go

/* Update liq_position_hist: trades may be either in trade or trade_hist. */
select * into #all_trade 
from (select trade_id, trade_date_time from trade (parallel 5) union all
select trade_id, trade_date_time from trade_hist (parallel 5)) all_trade
go 
update liq_position_hist
set first_trade_date=(select trade_date_time from #all_trade (parallel 5) where #all_trade.trade_id=liq_position_hist.first_trade)
where first_trade_date is null
and is_deleted=0
go
update liq_position_hist
set second_trade_date=(select trade_date_time from #all_trade (parallel 5) where #all_trade.trade_id=liq_position_hist.second_trade)
where second_trade_date is null
and is_deleted=0
go
DROP TABLE #all_trade
go

/* Update pl_position: join from both liq_position and liq_position_hist (pl_position_hist not used). */
select * into #pos_trade_date from
(select position_id,first_trade_date td from liq_position (parallel 5) where is_deleted=0 union all 
select position_id,second_trade_date td from liq_position (parallel 5) where is_deleted=0 union all
select position_id,first_trade_date  td from liq_position_hist (parallel 5) where is_deleted=0 union all
select position_id,second_trade_date td from liq_position_hist (parallel 5) where is_deleted=0) pos_trade_date
go
create index i1 on #pos_trade_date (position_id, td)
go
update pl_position 
set last_trade_date=
(select max(td) from #pos_trade_date (parallel 5) where #pos_trade_date.position_id=pl_position.position_id group by #pos_trade_date.position_id)
where last_trade_date is null
go
DROP TABLE #pos_trade_date
go

/*  Update Version */
UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='003',
        version_date='20100530'
go


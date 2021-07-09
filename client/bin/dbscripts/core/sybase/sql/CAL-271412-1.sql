 

/* CAL-79500 fix broken position_ids for trade_open_qty from BZ 39262 upgrade script */
/*   this MUST be executed before the CAL-73220 upgrade script */

update trade_open_qty 
set position_id = (select position_id from pl_position p (parallel 5) where trade_open_qty.book_id = p.book_id and trade_open_qty.product_id = p.product_id and  trade_open_qty.liq_agg_id = p.liq_agg_id)
where position_id <> (select position_id from pl_position p (parallel 5) where trade_open_qty.book_id = p.book_id and trade_open_qty.product_id = p.product_id and  trade_open_qty.liq_agg_id = p.liq_agg_id)
go

update trade_openqty_hist 
set position_id = (select position_id from pl_position p (parallel 5) where trade_openqty_hist.book_id = p.book_id and trade_openqty_hist.product_id = p.product_id and  trade_openqty_hist.liq_agg_id = p.liq_agg_id)
where position_id <> (select position_id from pl_position p (parallel 5) where trade_openqty_hist.book_id = p.book_id and trade_openqty_hist.product_id = p.product_id and  trade_openqty_hist.liq_agg_id = p.liq_agg_id)
go

update liq_position
set position_id = (select position_id from pl_position p (parallel 5) where liq_position.book_id = p.book_id and liq_position.product_id = p.product_id and  liq_position.liq_agg_id = p.liq_agg_id)
where position_id <> (select position_id from pl_position p (parallel 5) where liq_position.book_id = p.book_id and liq_position.product_id = p.product_id and liq_position.liq_agg_id = p.liq_agg_id)
go

update liq_position_hist
set position_id = (select position_id from pl_position p (parallel 5) where liq_position_hist.book_id = p.book_id and liq_position_hist.product_id = p.product_id and  liq_position_hist.liq_agg_id = p.liq_agg_id)
where position_id <> (select position_id from pl_position p (parallel 5) where liq_position_hist.book_id = p.book_id and liq_position_hist.product_id = p.product_id and  liq_position_hist.liq_agg_id = p.liq_agg_id)
go

/* end */


if not exists (select 1 from sysobjects where name='pl_mark')
begin
exec('create table pl_mark (
	mark_id numeric  not null,
        trade_id numeric  not null,
        pricing_env_name varchar(32) not null,
        valuation_date datetime not null,
        position_or_trade varchar(128) not null,
        position_or_trade_version numeric  not null,
        entered_datetime datetime not null,
        update_datetime datetime null,
        version_num numeric  not null,
        entered_user varchar(32) not null,
        sub_id varchar(256) null,
        book_id numeric  not null,
        position_time varchar(64) null,
        market_time varchar(64) null,
        comments varchar(128) null,
        status varchar(32) null, constraint ct_primarykey primary key (mark_id))')
exec ('create index idx_pl_mark on pl_mark(trade_id, sub_id,pricing_env_name,valuation_date)')
end
go

/* CAL-73220 */
/* pl_position table */
add_column_if_not_exists 'pl_position', 'incep_trade_date','datetime null'
go

add_column_if_not_exists 'pl_position', 'entered_date','datetime null'
go

if exists (select 1 from sysobjects where name='pl_position_tmp')
begin
exec ('drop proc pl_position_tmp')
end
go

create proc pl_position_tmp
as
begin
declare @posid int, @i int 
declare @Cdate datetime , @Vdate datetime, @Fdate datetime , @Sdate datetime, @trdate  datetime
declare pl_pos_cur cursor
for
select tr_opn.position_id, min(tr_opn.trade_date)  from (select position_id, trade_date 
from trade_open_qty union all select position_id, trade_date 
from trade_openqty_hist) as tr_opn group by position_id
open pl_pos_cur
fetch pl_pos_cur into @posid, @trdate 
while (@@sqlstatus=0)
begin
select @Cdate=convert(date,@trdate) 
select @Vdate=convert(date,min(valuation_date)) from pl_mark where pl_mark.trade_id=@posid
select @Vdate=isnull(@Vdate,@Cdate)
select @i=sign(datediff(day,@Cdate,@Vdate))
if @i < 0
begin
select @Fdate=@Cdate
end
else
begin
select @Fdate=@Vdate
end 
update pl_position set incep_trade_date=@Fdate where position_id=@posid
update pl_position set entered_date=@Fdate where position_id=@posid
fetch pl_pos_cur into @posid, @trdate 
end
close pl_pos_cur
deallocate cursor pl_pos_cur
end
go

exec pl_position_tmp
go 

drop proc pl_position_tmp
go
/* position table */

add_column_if_not_exists 'position', 'incep_trade_date', 'datetime null'
go

add_column_if_not_exists 'position', 'entered_date', 'datetime null'
go

if exists (select 1 from sysobjects where name='position_tmp' and type='P')
begin
exec ('drop proc position_tmp')
end
go

create procedure pl_position_tmp 
as
begin
declare @prdid int,@bookid int , @liqid int, @posid int, @Cdate datetime, @Vdate datetime, @Fdate datetime ,@i int
declare pl_pos_cur cursor
for
SELECT product_id,book_id, liq_agg_id ,position_id from pl_position where incep_trade_date is null and entered_date is null
open pl_pos_cur
fetch pl_pos_cur into @prdid, @bookid ,@liqid ,@posid
while (@@sqlstatus=0)
begin
select @Cdate= min(trade_date) from trade_open_qty where 
                                                @prdid = trade_open_qty.product_id AND
                                                @bookid = trade_open_qty.book_id AND
                                                @liqid = trade_open_qty.liq_agg_id
select @Vdate=min(valuation_date) from pl_mark where @posid = pl_mark.trade_id
select @Vdate=isnull(@Vdate,@Cdate)
select @i=sign(datediff(day,@Cdate,@Vdate))
if @i < 0
begin
select @Fdate=@Cdate
end
else
begin
select @Fdate=@Vdate
end 
update pl_position set incep_trade_date = @Fdate, entered_date = @Fdate where product_id = @prdid and book_id = @bookid and liq_agg_id = @liqid 
fetch pl_pos_cur into @prdid, @bookid ,@liqid ,@posid
end
close pl_pos_cur
deallocate cursor pl_pos_cur
end
go

begin
exec pl_position_tmp
end
go

 
drop proc pl_position_tmp
go

/* settle_position table */
add_column_if_not_exists 'settle_position', 'incep_trade_date', 'datetime null'
go

add_column_if_not_exists 'settle_position','entered_date','datetime null'
go

if exists (select 1 from sysobjects where name='settle_position_tmp')
begin
exec ('drop proc settle_position_tmp')
end
go

create proc settle_position_tmp 
as
begin 
declare @Sdate datetime ,  @posid int ,@Sedate date
declare @Cdate date ,  @i int , @Ddate date

declare settle_pos_cur cursor
for
select settle_date, position_id from settle_position where incep_trade_date=null and entered_date=null
begin
open settle_pos_cur
fetch settle_pos_cur into @Sdate,@posid 
while (@@sqlstatus=0)
begin
select @Sedate=convert(date,@Sdate)
select @Cdate=convert(date,min(valuation_date)) from pl_mark where pl_mark.trade_id=@posid
select @Cdate=isnull(@Cdate,@Sedate)
select @i=sign(datediff(day,@Sedate,@Cdate))
if @i > 0
begin
select @Ddate=@Sedate
end
else
begin
select @Ddate=@Cdate
end
update settle_position set incep_trade_date=@Ddate where position_id=@posid
update settle_position set entered_date=@Ddate where position_id=@posid
fetch settle_pos_cur into @Sdate , @posid
end
close settle_pos_cur
deallocate cursor settle_pos_cur
end
end
go

begin
exec settle_position_tmp
end
go


drop proc settle_position_tmp
go
/* end */



/*  Update Version */
UPDATE calypso_info
    SET major_version=11,
        minor_version=0,
        sub_version=0,
        patch_version='002',
        version_date='20090702'
go

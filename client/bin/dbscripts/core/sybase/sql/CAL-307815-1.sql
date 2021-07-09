if exists (select 1 from sysobjects where name='official_pl_aggregate_item' and type='U')
begin
declare @sql1 varchar(200)
begin
select @sql1='update official_pl_aggregate_item set adj_status='||char(39)||'Adjusted'||char(39)||' where adj_status='||char(39)||'Imported & Adjusted'||char(39)
exec (@sql1)
end
end
go
if exists (select 1 from sysobjects where name='official_pl_mark' and type='U')
begin
declare @sql1 varchar(200)
begin
select @sql1='update official_pl_mark set adj_status='||char(39)||'Adjusted'||char(39)||' where adj_status='||char(39)||'Imported & Adjusted'||char(39)
exec(@sql1)
end
end
go
if exists (select 1 from sysobjects where name='official_pl_mark_hist' and type='U')
begin
declare @sql1 varchar(200)
begin
select @sql1='update official_pl_mark_hist set adj_status='||char(39)||'Adjusted'||char(39)||' where adj_status='||char(39)||'Imported & Adjusted'||char(39)
exec(@sql1)
end
end
go
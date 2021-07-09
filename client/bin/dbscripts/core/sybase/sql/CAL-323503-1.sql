begin
declare @length1 int ,@length2 int 
select @length1 = datalength(data_key), @length2=isnull(datalength(data_key),0) from live_pl_greeks_curve 
if (@length1 < 300 or @length2= null)
begin 
exec ('alter table live_pl_greeks_curve modify data_key varchar(300) not null')
end
end
go

begin
declare @length1 int ,@length2 int 
select @length1 = datalength(data_key), @length2=isnull(datalength(data_key),0) from live_pl_greeks_recovery
if (@length1 < 300 or @length2= null)
begin 
exec ('alter table live_pl_greeks_recovery modify data_key varchar(300)')
end
end 
go

begin
declare @length1 int ,@length2 int 
select @length1 = datalength(data_key), @length2=isnull(datalength(data_key),0) from live_pl_greeks_vol
if (@length1 < 300 or @length2= null)
begin 
exec ('alter table live_pl_greeks_vol modify data_key varchar(300)')
end
end
go

begin
declare @length1 int ,@length2 int 
select @length1 = datalength(data_key), @length2=isnull(datalength(data_key),0) from live_pl_greeks_vol_underlying
if (@length1 < 300 or @length2= null) 
begin 
exec ('alter table live_pl_greeks_vol_underlying modify data_key varchar(300)')
end
end
go

begin
declare @length1 int ,@length2 int 
select @length1 = datalength(data_key), @length2=isnull(datalength(data_key),0) from live_pl_greeks_quote
if (@length1 < 300 or @length2= null)
begin 
exec ('alter table live_pl_greeks_quote modify data_key varchar(300)')
end
end
go

if exists (select 1 from sysobjects where name='inv_cashposition')
begin
exec ('drop table inv_cashposition')
end
go

if exists (select 1 from sysobjects where name='inv_cashpos_hist')
begin
exec ('drop table inv_cashpos_hist')
end
go

if exists (select 1 from sysobjects where name='inv_secposition')
begin
exec ('drop table inv_secposition')
end
go

if exists (select 1 from sysobjects where name='inv_secpos_hist')
begin
exec ('drop table inv_secpos_hist')
end
go

if exists (select 1 from sysobjects where name='inv_cash_balance_back152')
begin
exec ('drop table inv_cash_balance_back152')
end
go

if exists (select 1 from sysobjects where name='inv_cash_movement_back152')
begin
exec ('drop table inv_cash_movement_back152')
end
go

if exists (select 1 from sysobjects where name='inv_sec_balance_back152')
begin
exec ('drop table inv_sec_balance_back152')
end
go

if exists (select 1 from sysobjects where name='inv_sec_movement_back152')
begin
exec ('drop table inv_sec_movement_back152')
end
go

if exists (select 1 from sysobjects where name='inv_movement_history')
begin
exec ('drop table inv_movement_history')
end
go

if exists (select 1 from sysobjects where name='inv_secposition_new')
begin
exec ('drop table inv_secposition_new')
end
go

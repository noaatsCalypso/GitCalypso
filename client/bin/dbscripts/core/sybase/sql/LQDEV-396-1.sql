select * into ba_expression_back from ba_expression
go

if exists (select 1 from sysobjects where name ='ba_expression' and type='U')
begin
exec sp_rename 'ba_expression','liq_expression'
end
go

select * into ba_expr_variable_back from ba_expr_variable
go

if exists (select 1 from sysobjects where name ='ba_expr_variable' and type='U')
begin
exec sp_rename 'ba_expr_variable','liq_expr_variable'
end
go

select * into ba_expr_variable_params_back from ba_expr_variable_params
go

if exists (select 1 from sysobjects where name ='ba_expr_variable_params' and type='U')
begin
exec sp_rename 'ba_expr_variable_params','liq_expr_variable_params'
end
go


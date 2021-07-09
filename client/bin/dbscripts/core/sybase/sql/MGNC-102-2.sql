if not exists (select 1 from syscolumns where object_id('ers_margin_sensitivity')=syscolumns.id and syscolumns.name='valuation_date')
begin
exec('select * into ers_margin_sensitivity_back from ers_margin_sensitivity')
exec('drop table ers_margin_sensitivity')
exec('create table ers_margin_sensitivity( run_id numeric not null ,
execution_time datetime null ,
valuation_date datetime not null ,
portfolio_id varchar(60) not null ,
party_id varchar(60) not null ,
cp_id varchar(60) not null ,
margin_agreement_name varchar(60) not null ,
im_model varchar(20) not null ,
risk_type varchar(20) not null ,
qualifier varchar(20) not null ,
bucket numeric null ,
label1 varchar(20)  null ,
label2 varchar(20)  null ,
amount float null ,
amount_ccy varchar(3) not  null ,
amount_base float null ,
source varchar(60) null,
pricing_env varchar(120) not null,
product_class varchar(20) not null)')
end
go

if exists (select 1 from acc_limit_cfg group by account_id having count(*)>1)
begin
exec ('select *,id_col=identity(10) into acc_limit_cfg_back from acc_limit_cfg where 1=0') 
exec('create unique index idx_limit_dup on acc_limit_cfg_back(account_id,active_from,active_to,minimum,maximum) with ignore_dup_key')
exec ('insert into acc_limit_cfg_back  select * from acc_limit_cfg') 
exec ('update acc_limit_cfg_back set acc_limit_cfg_id = id_col+1000')
exec ('alter table acc_limit_cfg_back drop id_col')
exec ('drop table acc_limit_cfg')
exec ('sp_rename acc_limit_cfg_back,acc_limit_cfg' )
end 
go

DELETE FROM calypso_seed WHERE seed_name = 'accountLimit'
go

begin
declare @new_id int
select @new_id= max(acc_limit_cfg_id)+1 from acc_limit_cfg 
if @new_id=NULL 
return 
INSERT INTO calypso_seed(last_id, seed_name, seed_alloc_size) values (@new_id ,'accountLimit', 100) 
end 
go
/* Make ID column not null, add new PK and remove old one */ 
if exists (select 1 from sysobjects, syscolumns where convert(bit,(status&8)) = 1 and sysobjects.name='acc_limit_cfg'
and sysobjects.id=syscolumns.id and syscolumns.name='acc_limit_cfg_id')
begin
exec ('ALTER TABLE acc_limit_cfg MODIFY acc_limit_cfg_id numeric NOT NULL')
end
go 


if not exists(SELECT 1 FROM sysindexes i, sysobjects t 
WHERE t.name = 'acc_limit_cfg' AND i.id = t.id AND (i.status & 2048) = 2048)
begin 
exec ('ALTER TABLE acc_limit_cfg ADD CONSTRAINT ct_primarykey PRIMARY KEY (acc_limit_cfg_id)')
end
go

/* diff patch */
add_domain_values 'plMeasure', 'Intraday_Trade_Full_Base_PnL', ''  
go
add_domain_values 'plMeasure', 'Intraday_Trade_Translation_PnL', ''  
go
add_domain_values 'plMeasure', 'Intraday_Trade_Cash_FX_Reval', ''  
go
add_domain_values 'domainName', 'PricingSheetMeasures', 'The Pricer Measures supported in the Pricing Sheet'  
go
add_domain_values 'PricingSheetMeasures', 'NPV',''
go
add_domain_values 'PricingSheetMeasures', 'PV' ,''
go
add_domain_values 'PricingSheetMeasures', 'TV' ,''
go
add_domain_values 'PricingSheetMeasures', 'VANNA_VOLGA_ADJ' ,''
go
add_domain_values 'PricingSheetMeasures', 'DELTA' ,''
go
add_domain_values 'PricingSheetMeasures', 'DELTA_PCT',''
go
add_domain_values 'PricingSheetMeasures', 'DELTA_RISKY_PRIM' ,''
go
add_domain_values 'PricingSheetMeasures', 'DELTA_RISKY_SEC' ,''
go
add_domain_values 'PricingSheetMeasures', 'MOD_DELTA' ,''
go
add_domain_values 'PricingSheetMeasures', 'FWD_DELTA' ,''
go
add_domain_values 'PricingSheetMeasures', 'FWD_DELTA_RISKY_PRIM' ,''
go
add_domain_values 'PricingSheetMeasures', 'FWD_DELTA_RISKY_SEC' ,''
go
add_domain_values 'PricingSheetMeasures', 'GAMMA' ,''
go
add_domain_values 'PricingSheetMeasures', 'MOD_GAMMA' ,''
go
add_domain_values 'PricingSheetMeasures', 'GAMMA_PCT' ,''
go
add_domain_values 'PricingSheetMeasures', 'RHO' ,''
go
add_domain_values 'PricingSheetMeasures', 'RHO2' ,''
go
add_domain_values 'PricingSheetMeasures', 'REAL_RHO' ,''
go
add_domain_values 'PricingSheetMeasures', 'REAL_RHO2' ,''
go
add_domain_values 'PricingSheetMeasures', 'THETA' ,''
go
add_domain_values 'PricingSheetMeasures', 'THETA_PCT' ,''
go
add_domain_values 'PricingSheetMeasures', 'REAL_THETA' ,''
go
add_domain_values 'PricingSheetMeasures', 'THETA2' ,''
go
add_domain_values 'PricingSheetMeasures', 'VEGA' ,''
go
add_domain_values 'PricingSheetMeasures', 'VEGA_PCT' ,''
go
add_domain_values 'PricingSheetMeasures', 'MOD_VEGA' ,''
go
add_domain_values 'PricingSheetMeasures', 'W_VEGA' ,''
go
add_domain_values 'PricingSheetMeasures', 'W_MOD_VEGA' ,''
go
add_domain_values 'PricingSheetMeasures', 'W_SHIFT_MOD_VEGA' ,''
go
add_domain_values 'PricingSheetMeasures', 'DVEGA_DVOL' ,''
go
add_domain_values 'PricingSheetMeasures', 'DVEGA_DSPOT' ,''
go
add_domain_values 'PricingSheetMeasures', 'DDELTA_DVOL' ,''
go
add_domain_values 'PricingSheetMeasures', 'IMPLIEDVOLATILITY' ,''
go
add_domain_values 'PricingSheetMeasures', 'IMPLIED_TRADING_VOL' ,''
go
add_domain_values 'PricingSheetMeasures', 'TRADING_DAYS' ,''
go
/* end */

/*  Update Version */
UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='001',
        version_date='20100305'
go


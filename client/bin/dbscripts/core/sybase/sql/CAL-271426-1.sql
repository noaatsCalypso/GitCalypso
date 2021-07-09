update trade set quantity =-1 
where trade_id in (SELECT trade.trade_id 
                   FROM trade, product_pm_depo_lease 
				   where trade.product_id = product_pm_depo_lease.product_id 
				   and product_pm_depo_lease.deposit_lease_type = 1 
				   and trade.quantity=1)
go
update trade set quantity =1 
where trade_id in (SELECT trade.trade_id 
                   FROM trade, product_pm_depo_lease 
				   where trade.product_id = product_pm_depo_lease.product_id 
				   and product_pm_depo_lease.deposit_lease_type = 2 
				   and trade.quantity=-1)
go

add_domain_values  'productType', 'ContingentCreditDefaultSwap', 'ContingentCreditDefaultSwap' 
go
add_domain_values  'domainName', 'ccdsUpfrontFeeType', '' 
go
add_domain_values  'productTypeReportStyle', 'ContingentCreditDefaultSwap', 'ContingentCreditDefaultSwap ReportStyle' 
go
add_domain_values  'domainName', 'ccdsUnderlyingProductTypes', 'Defines the product types available for selection in the ContingentCreditDefaultSwap trade window' 
go
add_domain_values  'ccdsUnderlyingProductTypes', 'Swap', ''
go
add_domain_values  'ccdsUnderlyingProductTypes', 'CapFloor', '' 
go
add_domain_values  'ccdsUnderlyingProductTypes', 'CancellableSwap', '' 
go
add_domain_values  'ccdsUnderlyingProductTypes', 'Swaption', '' 
go
add_domain_values  'ccdsUnderlyingProductTypes', 'XCCySwap', ''
go

update domain_values
set name = 'CommodityLocation'
from domain_values outer
where name = 'CommodityStorageLocation'
and not exists
(
select 1
from domain_values inner
where inner.name = 'CommodityLocation'
and inner.value = outer.value
)
go
DELETE from domain_values where name='CurveUnderlyingCommoditySpreadType' and value='Calendar'
go

/* end */ 
exec add_column_if_not_exists 'swap_leg','compound_freq_style','varchar(32) null'
go
update swap_leg set compound_freq_style='Original' where compound_freq='NON' and compound_freq_style='Regular' and product_id in (select product_id from product_desc where product_type= 'EquityLinkedSwap')
go
/*  Update Version */
UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='004',
        version_date='20101004'
go


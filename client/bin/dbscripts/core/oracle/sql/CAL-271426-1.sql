update /*+ PARALLEL (trade) */ trade set quantity =-1 
where trade_id in (SELECT trade.trade_id 
                   FROM trade, product_pm_depo_lease 
				   where trade.product_id = product_pm_depo_lease.product_id 
				   and product_pm_depo_lease.deposit_lease_type = 1 
				   and trade.quantity=1)
;
update /*+ PARALLEL (trade) */  trade set quantity =1 
where trade_id in (SELECT trade.trade_id 
                   FROM trade, product_pm_depo_lease 
				   where trade.product_id = product_pm_depo_lease.product_id 
				   and product_pm_depo_lease.deposit_lease_type = 2 
				   and trade.quantity=-1)
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'ContingentCreditDefaultSwap', 'ContingentCreditDefaultSwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ccdsUpfrontFeeType', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'ContingentCreditDefaultSwap', 'ContingentCreditDefaultSwap ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ccdsUnderlyingProductTypes', 'Defines the product types available for selection in the ContingentCreditDefaultSwap trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ccdsUnderlyingProductTypes', 'Swap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ccdsUnderlyingProductTypes', 'CapFloor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ccdsUnderlyingProductTypes', 'CancellableSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ccdsUnderlyingProductTypes', 'Swaption', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ccdsUnderlyingProductTypes', 'XCCySwap', '' )
;

update domain_values outer
set name = 'CommodityLocation'
where name = 'CommodityStorageLocation'
and not exists
(
select 1
from domain_values inner
where inner.name = 'CommodityLocation'
and inner.value = outer.value
)
;
DELETE from domain_values where name='CurveUnderlyingCommoditySpreadType' and value='Calendar'
;
 
/* CAL-108748 */

DECLARE v_nullable varchar2(1);
begin
select nullable into v_nullable from user_tab_cols where table_name='BO_MESSAGE' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_message)*/ bo_message set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_MESSAGE MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_MESSAGE_HIST' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_message_hist)*/ bo_message_hist set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_MESSAGE_HIST MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_TRANSFER' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_transfer)*/ bo_transfer set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_TRANSFER MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_TRANSFER_HIST' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_transfer_hist)*/ bo_transfer_hist set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_TRANSFER_HIST MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_POSTING' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_posting)*/ bo_posting set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_POSTING MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_POSTING_HIST' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_posting_hist)*/ bo_posting_hist set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_POSTING_HIST MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_CRE' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_cre)*/ bo_cre set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_CRE MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_CRE_HIST' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_cre_hist)*/ bo_cre_hist set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_CRE_HIST MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_TASK_HIST' and column_name = 'TASK_VERSION';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_task_hist)*/ bo_task_hist set task_version = 0 where task_version is null;
  execute immediate 'ALTER TABLE BO_TASK_HIST MODIFY TASK_VERSION NOT NULL ' ;
  END;
end if;
end;
;

/* end */
 
begin
  add_column_if_not_exists('swap_leg','compound_freq_style','VARCHAR2(32)');
end;
;

update swap_leg set compound_freq_style='Original' where compound_freq='NON' and compound_freq_style='Regular' and product_id in (select product_id from product_desc where product_type= 'EquityLinkedSwap')
;
UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='004',
        version_date=TO_DATE('4/10/2010','DD/MM/YYYY')
;

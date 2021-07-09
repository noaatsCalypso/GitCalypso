
create index  IDX_PL_MARKX on PL_MARK(MARK_TYPE, TRADE_ID, PRICING_ENV_NAME, SUB_ID, VALUATION_DATE, MARK_ID) compute statistics
;
begin
add_column_if_not_exists ('option_contract','dateformat','number null');
add_column_if_not_exists ('eto_contract','dateformat','number null');
end;
;

update option_contract set dateformat = 1 where  dateformat is null
;
update eto_contract set dateformat = 1 where  dateformat is null
;

UPDATE calypso_info
    SET major_version=15,
        minor_version=0,
        sub_version=0,
        patch_version='004',
        version_date=TO_DATE('01/07/2016','DD/MM/YYYY')
;

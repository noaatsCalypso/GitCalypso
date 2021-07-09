 
begin
add_column_if_not_exists ('PRODUCT_TLOCK','settlement_type','varchar2 (255)  NULL');
end;
;
begin
add_column_if_not_exists ('PRODUCT_TLOCK','observation_type','varchar2 (255)  NULL');
end;
;
begin
add_column_if_not_exists ('PRODUCT_TLOCK','duration','float NULL');
end;
;
begin
add_column_if_not_exists ('PRODUCT_TLOCK','lock_price','float NULL');
end;
;
begin
add_column_if_not_exists ('PRODUCT_TLOCK','duration_override_b','numeric NULL');
end;
;
update product_tlock set settlement_type = 'CASH_SETTLE_YIELD' where settlement_type is null
;
update product_tlock set observation_type = 'SINGLE' where observation_type is null
;

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='020',
        version_date=TO_DATE('31/12/2014','DD/MM/YYYY') 

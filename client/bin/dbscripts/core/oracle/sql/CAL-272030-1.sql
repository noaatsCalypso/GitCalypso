begin
add_column_if_not_exists ('swap_leg' , 'sample_timing','varchar(18) null');
end;
/
begin
add_column_if_not_exists ('swap_leg' , 'sprd_calc_mtd','varchar(128) null');
end;
/
begin
add_column_if_not_exists ('swap_leg_hist' , 'sample_timing','varchar(18) null');
end;
/
begin
add_column_if_not_exists ('swap_leg_hist' , 'sprd_calc_mtd','varchar(128) null');
end;
/
update swap_leg 
set sample_timing = 'BEG_PER' 
where product_id in (select product_id from product_els)
;

update swap_leg_hist 
set sample_timing = 'BEG_PER' 
where product_id in (select product_id from product_els_hist)
;

update swap_leg
set sprd_calc_mtd = 'SPRD_ADDITIVE'
where sprd_calc_mtd is null
;

update swap_leg_hist
set sprd_calc_mtd = 'SPRD_ADDITIVE'
where sprd_calc_mtd is null
;
UPDATE calypso_info
    SET major_version=14,
        minor_version=3,
        sub_version=0,
        patch_version='005',
        version_date=TO_DATE('01/06/2015','DD/MM/YYYY')
; 

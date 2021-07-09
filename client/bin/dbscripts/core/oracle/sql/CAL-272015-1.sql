create or replace procedure update_xccy_swap
is
begin
declare
cursor c1 is
select distinct p.product_id , x.pay_side_reset_b ,p.pay_leg_id , p.receive_leg_id ,s.ACT_INITIAL_EXCH_B from product_swap p , swap_leg s ,XCCY_SWAP_EXT_INFO x
where p.product_id = x.product_id and s.product_id = x.product_id;
begin
for c1_rec in c1 LOOP
begin
update XCCY_SWAP_EXT_INFO set adj_first_flw_b = 0 where product_id = c1_rec.product_id and c1_rec.ACT_INITIAL_EXCH_B=0;
end;
end loop;
end;
end;
/
begin
update_xccy_swap;
end;
/
drop procedure update_xccy_swap
;
UPDATE calypso_info
    SET major_version=14,
        minor_version=2,
        sub_version=0,
        patch_version='007',
        version_date=TO_DATE('28/02/2015','DD/MM/YYYY')
;

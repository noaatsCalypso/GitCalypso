/* CAL-199430 */
/* CAL-354757*/
/* CAL-362958 */

declare

    column_exists exception;

    pragma exception_init (column_exists , -01430);

begin

    execute immediate 'ALTER TABLE cu_basis_swap ADD  act_initial_exch_b  number NULL';

    execute immediate 'ALTER TABLE cu_basis_swap ADD  act_final_exch_b  number NULL';

    exception when column_exists then null;

end;
/

begin
add_column_if_not_exists ('cu_basis_swap','principal_actual_b','number DEFAULT 0 NOT NULL');
end;
/

update cu_basis_swap set act_initial_exch_b = principal_actual_b, act_final_exch_b = principal_actual_b
;

/* CAL-204386 */

begin
add_column_if_not_exists ('product_cap_floor','init_fixing_type','varchar2(30) NULL');
end;
/
update product_cap_floor set init_fixing_type = '1st Rate' where man_first_reset_b = 1
;
                
update product_cap_floor set init_fixing_type = 'Init Level' where man_first_reset_b = 2
;
/**CAL-203654 -- Inflation Real Rate Swap - Fixed Rate should be captured as a rate and not an index factor **/
/** Warning: this script should only be run once on upgrade!! **/

update swap_leg
set fixed_rate=fixed_rate * 100
where 
leg_type = 'Float'
and product_id in ( select sl.product_id
from swap_leg sl, rate_index_default rid
where rid.index_type = 'Inflation'
and sl.rate_index like '%' || rid.currency_code || '/' || rid.rate_index_code || '%'
and sl.leg_type = 'Float')
;
update rate_schedule rs 
set rs.rate = rs.rate * 100
where rs.type = 'FIXED_RATE' and 
exists 
(select 1
from swap_leg sl, rate_index_default rid
where sl.product_id = rs.product_id 
and sl.leg_id = rs.sub_id 
and sl.leg_type = 'Float'
and rid.index_type='Inflation'
and sl.rate_index like '%' || rid.currency_code || '/' || rid.rate_index_code || '%')
;

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='021',
        version_date=TO_DATE('05/01/2015','DD/MM/YYYY') 
;

/* CAL-199430 */
/*CAL-354757*/

add_column_if_not_exists 'cu_basis_swap','principal_actual_b','integer DEFAULT 0 NOT NULL'
go

if exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'act_initial_exch_b' )
begin
exec 'update cu_basis_swap set act_initial_exch_b = principal_actual_b'
end
go

if exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'act_final_exch_b' )
begin
exec 'update cu_basis_swap set act_final_exch_b = principal_actual_b'
end
go

/* CAL-204386 */
add_column_if_not_exists 'product_cap_floor','init_fixing_type','varchar(30) null'
go

update product_cap_floor set init_fixing_type = '1st Rate' where man_first_reset_b = 1
go
update product_cap_floor set init_fixing_type = 'Init Level' where man_first_reset_b = 2
go

/**CAL-203654 -- Inflation Real Rate Swap - Fixed Rate should be captured as a rate and not an index factor **/
/** Warning: this script should only be run once on upgrade!! **/

update swap_leg
set fixed_rate=fixed_rate * 100
where 
leg_type = 'Float'
and product_id in ( select sl.product_id
from swap_leg sl, rate_index_default rid
where rid.index_type='Inflation'
and sl.rate_index like '%' || rid.currency_code || '/' || rid.rate_index_code || '%'
and sl.leg_type = 'Float')
go
update rate_schedule  
set rate = rate * 100
where type = 'FIXED_RATE' and 
exists 
(select 1
from swap_leg sl, rate_index_default rid
where sl.product_id = rate_schedule.product_id 
and sl.leg_id = rate_schedule.sub_id 
and sl.leg_type = 'Float'
and rid.index_type='Inflation'
and sl.rate_index like '%' || rid.currency_code || '/' || rid.rate_index_code || '%')
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='021',
        version_date='20150105'
go 

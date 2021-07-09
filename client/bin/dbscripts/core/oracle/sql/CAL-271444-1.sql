update cu_basis_swap_dtls set reset_avg_method='Equal' where reset_avg_method is null
;

insert into group_access (group_name, access_id, access_value, read_only_b)
select group_name, access_id, 'Navigator', read_only_b from group_access where access_value = 'MainEntry'
and not exists(Select 1 from group_access a where a.access_value = 'Navigator' and a.group_name = group_access.group_name)
;
insert into cu_basis_swap_dtls(cu_id, leg_id, reset_avg_method, avg_sample_freq, sample_day)
select cbs.cu_id,1,rid.avg_method,
rid.frequency,rid.day_of_week
from cu_basis_swap cbs, rate_index_default rid
where
cbs.base_avg_b = 1
and cbs.base_rate_index like rid.currency_code || '/' || rid.rate_index_code || '%'
and cbs.cu_id not in (select cu_id from cu_basis_swap_dtls)
;

insert into cu_basis_swap_dtls
(cu_id, leg_id, reset_avg_method, avg_sample_freq, sample_day)
select cbs.cu_id,2,rid.avg_method,
rid.frequency,rid.day_of_week
from cu_basis_swap cbs, rate_index_default rid
where
cbs.basis_avg_b = 1
and cbs.basis_rate_index like rid.currency_code || '/' || rid.rate_index_code || '%'
and cbs.cu_id not in (select cu_id from cu_basis_swap_dtls)
;

create table prod_structured_flow_back as select * from product_structured_flows
;
begin
add_column_if_not_exists ('swap_leg','open_term_b','number default 0 null');
end;
/
begin
add_column_if_not_exists ('swap_leg','notice_days','number null');
end;
/

update swap_leg set open_term_b = (select open_term_b from product_structured_flows where product_structured_flows.product_id=swap_leg.product_id)
where exists ( select 1 from product_structured_flows where product_structured_flows.product_id=swap_leg.product_id )
;

update swap_leg set notice_days = (select notice_days from product_structured_flows where product_structured_flows.product_id=swap_leg.product_id)
where exists ( select 1 from product_structured_flows where product_structured_flows.product_id=swap_leg.product_id )
;
alter table product_structured_flows drop column open_term_b
;
alter table product_structured_flows drop column notice_days
;

begin

drop_unique_if_exists ('strategy');
end; 
/

begin
add_column_if_not_exists ('pc_discount','collateral_curr','varchar2(32) null');
end;
/

UPDATE calypso_info
    SET major_version=14,
        minor_version=0,
        sub_version=0,
        patch_version='018',
        version_date=TO_DATE('21/10/2013','DD/MM/YYYY')
;

update cu_basis_swap_dtls set reset_avg_method='Equal' where reset_avg_method is null
go

insert into group_access (group_name, access_id, access_value, read_only_b)
select group_name, access_id, 'Navigator', read_only_b from group_access where access_value = 'MainEntry'
and not exists(Select 1 from group_access a where a.access_value = 'Navigator' and a.group_name = group_access.group_name)
go
insert into cu_basis_swap_dtls(cu_id, leg_id, reset_avg_method, avg_sample_freq, sample_day)
select cbs.cu_id,1,rid.avg_method,
rid.frequency,rid.day_of_week
from cu_basis_swap cbs, rate_index_default rid
where
cbs.base_avg_b = 1
and cbs.base_rate_index like rid.currency_code || '/' || rid.rate_index_code || '%'
and cbs.cu_id not in (select cu_id from cu_basis_swap_dtls)
go

insert into cu_basis_swap_dtls
(cu_id, leg_id, reset_avg_method, avg_sample_freq, sample_day)
select cbs.cu_id,2,rid.avg_method,
rid.frequency,rid.day_of_week
from cu_basis_swap cbs, rate_index_default rid
where
cbs.basis_avg_b = 1
and cbs.basis_rate_index like rid.currency_code || '/' || rid.rate_index_code || '%'
and cbs.cu_id not in (select cu_id from cu_basis_swap_dtls)
go
 
select * into prod_struct_flows_back from product_structured_flows
go
add_column_if_not_exists 'swap_leg','open_term_b','numeric null'
go
add_column_if_not_exists 'swap_leg','notice_days','numeric null'
go
update swap_leg set open_term_b = (select open_term_b from product_structured_flows where product_structured_flows.product_id=swap_leg.product_id)
where exists ( select 1 from product_structured_flows where product_structured_flows.product_id=swap_leg.product_id )
go
update swap_leg set notice_days = (select notice_days from product_structured_flows where product_structured_flows.product_id=swap_leg.product_id)
where exists ( select 1 from product_structured_flows where product_structured_flows.product_id=swap_leg.product_id )
go
alter table product_structured_flows drop open_term_b
go
alter table product_structured_flows drop notice_days
go


UPDATE calypso_info
    SET major_version=14,
        minor_version=0,
        sub_version=0,
        patch_version='018',
        version_date='20131021'
go

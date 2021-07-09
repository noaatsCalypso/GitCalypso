alter table cu_cds rename column start_offset to start_offset_bck
;
alter table cu_cds rename column offset to start_offset
;
alter table product_otccom_opt rename column settlement_offset to settlement_offset_bck
;
alter table product_otccom_opt rename column offset to settlement_offset
;
alter table product_otceq_opt rename column settlement_offset to settlement_offset_bck
;
alter table product_otceq_opt rename column offset to settlement_offset
;
alter table accrual_schedule_params rename column accrual_offset to accrual_offset_bck
;
alter table accrual_schedule_params rename column offset to accrual_offset
;
alter table cu_cds drop column start_offset_bck
;
alter table product_otccom_opt drop column settlement_offset_bck
;
alter table product_otceq_opt drop column settlement_offset_bck
;
alter table accrual_schedule_params drop column accrual_offset_bck
;
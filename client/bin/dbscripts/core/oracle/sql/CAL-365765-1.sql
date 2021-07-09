alter table product_credit_facility rename column credit_limit to credit_limit_bck
;
alter table acc_interest_config rename column offset_date to offset_date_bck
;
alter table product_credit_facility rename column limit to credit_limit
;
alter table acc_interest_config rename column offset to offset_date
;

alter table product_credit_facility drop column credit_limit_bck
;
alter table acc_interest_config drop column offset_date_bck
;
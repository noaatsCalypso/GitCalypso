alter table liq_limit_ccy_bucket rename column bucket_limit to bucket_limit_bck
;
alter table liq_limit_ccy_bucket rename column limit to bucket_limit
;
alter table liq_limit_ccy_class_lvl rename column class_lvl_limit to class_lvl_limit_bck
;
alter table liq_limit_ccy_class_lvl rename column limit to class_lvl_limit
;
alter table liq_limit_ccy_class_lvl_bucket rename column lvl_bucket_limit to lvl_bucket_limit_bck
;
alter table liq_limit_ccy_class_lvl_bucket rename column limit to lvl_bucket_limit
;
alter table liq_limit_ccy_bucket drop column bucket_limit_bck
;
alter table liq_limit_ccy_class_lvl drop column class_lvl_limit_bck
;
alter table liq_limit_ccy_class_lvl_bucket drop column lvl_bucket_limit_bck
;
/* This scripts is part of the exercise to replace Calypso env parameter TP_FX_SPT_BY_CP_TIME_ZONE_B  */
/* with dayChangeRule selection in PricingEnv. */
/* *** NOTE  Only users who has TP_FX_SPT_BY_CP_TIME_ZONE_B flag set to true should run this scripts *** */

update pricing_env set day_change_rule = 'FX'
;

update curve set day_change_rule = 'FX'
;

update curve_hist set day_change_rule = 'FX'
;

update vol_surface set day_change_rule = 'FX'
;

update vol_surface_hist set day_change_rule = 'FX'
;

update correlation_matrix set day_change_rule = 'FX'
;

update corr_matrix_hist set day_change_rule = 'FX'
;

update corr_surface set day_change_rule = 'FX'
;


Insert into book_attr_value (book_id,attribute_name,attribute_value)
Select book_id, 'DayChangeRule','FX' from book
;
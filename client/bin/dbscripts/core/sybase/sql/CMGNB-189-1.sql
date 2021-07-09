/*cm_simm_calc_request to cm_calc_request where cm_simm_calc_request.request_time is not null*/
INSERT INTO cm_calc_request (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date,
client_request_id, valuation_date, pricing_env_name, save_results, status, methodology, request_time) 
SELECT id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, 
NULL as client_request_id, valuation_date, pricing_env_name, save_results, status, 'SIMM', request_time FROM cm_simm_calc_request WHERE request_time IS NOT NULL
go
/*cm_simm_calc_request to cm_calc_request where cm_simm_calc_request.request_time is null,so put in dummy value*/
INSERT INTO cm_calc_request (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date,
client_request_id, valuation_date, pricing_env_name, save_results, status, methodology, request_time) 
SELECT id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, 
NULL as client_request_id, valuation_date, pricing_env_name, save_results, status, 'SIMM', 1 as request_time FROM cm_simm_calc_request WHERE request_time IS NULL
go
/**/
INSERT INTO cm_account_calc_request (id, account_id) SELECT id, account_id FROM cm_simm_calc_request
go
/**/
/*time_horizon in cm_simm_calc_request.time_horizon is not null*/
INSERT INTO cm_account_calc_request_simm (id, time_horizon, calculation_set_id) SELECT id, time_horizon, calculation_set_id FROM cm_simm_calc_request  WHERE time_horizon IS NOT NULL
go
/*time_horizon in cm_account_calc_request is null default to 10D in new table */
INSERT INTO cm_account_calc_request_simm (id, time_horizon, calculation_set_id) SELECT id, '10D' as time_horizon, calculation_set_id FROM cm_simm_calc_request  WHERE time_horizon IS NULL
go
INSERT INTO cm_calc_request_errors (request_id, error_messages, error_messages_order) SELECT request_id, error_messages, error_messages_order FROM cm_simm_calc_request_errors
go

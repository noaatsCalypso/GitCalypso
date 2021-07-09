
add_column_if_not_exists 'risk_on_demand_item', 'catchup_limit', 'numeric null' 
go
update risk_on_demand_item set rate_source_name = 'NONE' 
WHERE saved_output = 0 AND analysis_name != 'OfficialPL' 
AND run_freq = -1 AND quote_freq = -1 AND market_data_freq=-1 AND catchup_limit = -1
go

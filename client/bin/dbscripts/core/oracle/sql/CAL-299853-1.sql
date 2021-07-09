begin
  add_column_if_not_exists('risk_on_demand_item', 'saved_output', 'number');
end;
/
begin
  add_column_if_not_exists('risk_on_demand_item', 'run_freq', 'number(38)');
end;
/

update risk_on_demand_item set rate_source_name = 'NONE' 
WHERE saved_output = 0 AND analysis_name != 'OfficialPL' 
AND run_freq = -1 AND quote_freq = -1 AND market_data_freq=-1 AND catchup_limit = -1
;
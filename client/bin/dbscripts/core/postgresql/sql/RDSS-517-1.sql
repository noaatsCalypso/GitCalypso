DO $$
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(config_name)),0) into x from reutersdss_config_name;	
	select coalesce(count(*),0) into y from reutersdss_config_name;		
		
	if (x < 64 or y = 0) then	
		execute 'alter table reutersdss_config_name alter column config_name type varchar(64)';
	end if;	
		
end;		
$$
;

DO $$		
declare		
		
x integer;		
y integer;		
		

begin		
	select coalesce(max(length(rpt_tmplt_name)),0) into x from reutersdss_rpt_templates;	
	select coalesce(count(*),0) into y from reutersdss_rpt_templates;		
		
	if (x < 64 or y = 0) then	
		execute  'alter table reutersdss_rpt_templates alter column rpt_tmplt_name type varchar(64)';
	end if;	
		
end;	
$$
;	
		
DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(rpt_col_tmplt_name)),0) into x from reutersdss_rpt_cols;	
	select coalesce(count(*),0) into y from reutersdss_rpt_cols;			
		
	if (x < 64 or y = 0) then	
		execute  'alter table reutersdss_rpt_cols alter column rpt_col_tmplt_name type varchar(64)';
	end if;	
		
end;		
$$
;	

DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(col_name)),0) into x from reutersdss_rpt_cols;	
	select coalesce(count(*),0) into y from reutersdss_rpt_cols;	
		
	if (x < 255 or y = 0) then	
		execute  'alter table reutersdss_rpt_cols alter column col_name type varchar(255)';
	end if;	
		
end;		
$$
;

DO $$
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(instrument_tmplt_name)),0) into x from reutersdss_instruments;	
	select coalesce(count(*),0) into y from reutersdss_instruments;	
		
	if (x < 64 or y = 0) then	
		execute  'alter table reutersdss_instruments alter column instrument_tmplt_name type varchar(64)';
	end if;	
		
end;		
$$
;	

DO $$
	
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(iden_name)),0) into x from reutersdss_instruments;	
	select coalesce(count(*),0) into y from reutersdss_instruments;	
	
	if (x < 255 or y = 0) then	
		execute  'alter table reutersdss_instruments alter column iden_name type varchar(255)';
	end if;	
		
end;		
$$
;		

DO $$
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(iden_desc)),0) into x from reutersdss_instruments;	
	select coalesce(count(*),0) into y from reutersdss_instruments;	
		
	if (x < 64 or y = 0) then	
		execute  'alter table reutersdss_instruments alter column iden_desc type varchar(64)';
	end if;	
		
end;		
$$
;

DO $$		
		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(schedules_tmplt_name)),0) into x from reutersdss_schedules;	
	select coalesce(count(*),0) into y from reutersdss_schedules;	
	if (x < 64 or y = 0) then	
		execute  'alter table reutersdss_schedules alter column schedules_tmplt_name type varchar(64)';
	end if;	
		
end;		
$$
;


DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(typename)),0) into x from reutersdss_mapping;	
	select coalesce(count(*),0) into y from reutersdss_mapping;		
		
	if (x < 96 or y = 0) then	
		execute  'alter table reutersdss_mapping alter column typename type varchar(96)';
	end if;	
		
end;		
$$
;

		
DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(intf_value)),0) into x from reutersdss_mapping;	
	select coalesce(count(*),0) into y from reutersdss_mapping;		
		
	if (x < 255 or y = 0) then	
		execute  'alter table reutersdss_mapping alter column intf_value type varchar(255)';
	end if;	
		
end;		
$$
;

	
DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(calypso_value)),0) into x from reutersdss_mapping;	
	select coalesce(count(*),0) into y from reutersdss_mapping;		
		
	if (x < 255 or y = 0) then	
		execute  'alter table reutersdss_mapping alter column calypso_value type varchar(255)';
	end if;	
		
end;		
$$
;		

DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(intf_value)),0) into x from reutersdss_mapping_rules;	
	select coalesce(count(*),0) into y from reutersdss_mapping_rules;		
		
	if (x < 64 or y = 0) then	
		execute  'alter table reutersdss_mapping_rules alter column intf_value type varchar(64)';
	end if;	
		
end;		
$$
;		

DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(calypso_value)),0) into x from reutersdss_mapping_rules;	
	select coalesce(count(*),0) into y from reutersdss_mapping_rules;		
		
	if (x < 64 or y = 0) then	
		execute  'alter table reutersdss_mapping_rules alter column calypso_value type varchar(64)';
	end if;	
		
end;		
$$
;		

DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(rule_name)),0) into x from reutersdss_mapping_rules;	
	select coalesce(count(*),0) into y from reutersdss_mapping_rules;	
	
		
	if (x < 255 or y = 0) then	
		execute  'alter table reutersdss_mapping_rules alter column rule_name type varchar(255)';
	end if;	
		
end;		
$$
;	
	
DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(rule_value)),0) into x from reutersdss_mapping_rules;	
	select coalesce(count(*),0) into y from reutersdss_mapping_rules;	
	
		
	if (x < 255 or y = 0) then	
		execute  'alter table reutersdss_mapping_rules alter column rule_value type varchar(255)';
	end if;	
		
end;		
$$
;		

DO $$		
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(rule_group)),0) into x from reutersdss_mapping_rules;	
	select coalesce(count(*),0) into y from reutersdss_mapping_rules;	
	
		
	if (x < 64 or y = 0) then	
		execute  'alter table reutersdss_mapping_rules alter column rule_group type varchar(64)';
	end if;	
		
end;		
$$
;
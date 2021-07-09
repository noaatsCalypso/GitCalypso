declare

x number;
y number;

begin
	select vsize(CONFIG_NAME) into x from REUTERSDSS_CONFIG_NAME;
	select count(*) into y from REUTERSDSS_CONFIG_NAME;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 64 or y = 0) then
		execute immediate 'alter table REUTERSDSS_CONFIG_NAME modify CONFIG_NAME varchar2(64)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(RPT_TMPLT_NAME) into x from REUTERSDSS_RPT_TEMPLATES;
	select count(*) into y from REUTERSDSS_RPT_TEMPLATES;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 64 or y = 0) then
		execute immediate 'alter table REUTERSDSS_RPT_TEMPLATES modify RPT_TMPLT_NAME varchar2(64)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(RPT_COL_TMPLT_NAME) into x from REUTERSDSS_RPT_COLS;
	select count(*) into y from REUTERSDSS_RPT_COLS;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 64 or y = 0) then
		execute immediate 'alter table REUTERSDSS_RPT_COLS modify RPT_COL_TMPLT_NAME varchar2(64)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(COL_NAME) into x from REUTERSDSS_RPT_COLS;
	select count(*) into y from REUTERSDSS_RPT_COLS;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 255 or y = 0) then
		execute immediate 'alter table REUTERSDSS_RPT_COLS modify COL_NAME varchar2(255)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(INSTRUMENT_TMPLT_NAME) into x from REUTERSDSS_INSTRUMENTS;
	select count(*) into y from REUTERSDSS_INSTRUMENTS;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 64 or y = 0) then
		execute immediate 'alter table REUTERSDSS_INSTRUMENTS modify INSTRUMENT_TMPLT_NAME varchar2(64)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(IDEN_NAME) into x from REUTERSDSS_INSTRUMENTS;
	select count(*) into y from REUTERSDSS_INSTRUMENTS;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 255 or y = 0) then
		execute immediate 'alter table REUTERSDSS_INSTRUMENTS modify IDEN_NAME varchar2(255)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(IDEN_DESC) into x from REUTERSDSS_INSTRUMENTS;
	select count(*) into y from REUTERSDSS_INSTRUMENTS;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 64 or y = 0) then
		execute immediate 'alter table REUTERSDSS_INSTRUMENTS modify IDEN_DESC varchar2(64)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(SCHEDULES_TMPLT_NAME) into x from REUTERSDSS_SCHEDULES;
	select count(*) into y from REUTERSDSS_SCHEDULES;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 64 or y = 0) then
		execute immediate 'alter table REUTERSDSS_SCHEDULES modify SCHEDULES_TMPLT_NAME varchar2(64)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(TYPENAME) into x from REUTERSDSS_MAPPING;
	select count(*) into y from REUTERSDSS_MAPPING;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 96 or y = 0) then
		execute immediate 'alter table REUTERSDSS_MAPPING modify TYPENAME varchar2(96)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(INTF_VALUE) into x from REUTERSDSS_MAPPING;
	select count(*) into y from REUTERSDSS_MAPPING;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 255 or y = 0) then
		execute immediate 'alter table REUTERSDSS_MAPPING modify INTF_VALUE varchar2(255)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(CALYPSO_VALUE) into x from REUTERSDSS_MAPPING;
	select count(*) into y from REUTERSDSS_MAPPING;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 255 or y = 0) then
		execute immediate 'alter table REUTERSDSS_MAPPING modify CALYPSO_VALUE varchar2(255)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(INTF_VALUE) into x from REUTERSDSS_MAPPING_RULES;
	select count(*) into y from REUTERSDSS_MAPPING_RULES;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 64 or y = 0) then
		execute immediate 'alter table REUTERSDSS_MAPPING_RULES modify INTF_VALUE varchar2(64)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(CALYPSO_VALUE) into x from REUTERSDSS_MAPPING_RULES;
	select count(*) into y from REUTERSDSS_MAPPING_RULES;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 64 or y = 0) then
		execute immediate 'alter table REUTERSDSS_MAPPING_RULES modify CALYPSO_VALUE varchar2(64)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(RULE_NAME) into x from REUTERSDSS_MAPPING_RULES;
	select count(*) into y from REUTERSDSS_MAPPING_RULES;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 255 or y = 0) then
		execute immediate 'alter table REUTERSDSS_MAPPING_RULES modify RULE_NAME varchar2(255)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(RULE_VALUE) into x from REUTERSDSS_MAPPING_RULES;
	select count(*) into y from REUTERSDSS_MAPPING_RULES;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 255 or y = 0) then
		execute immediate 'alter table REUTERSDSS_MAPPING_RULES modify RULE_VALUE varchar2(255)';
	end if;

end;
/


declare

x number;
y number;

begin
	select vsize(RULE_GROUP) into x from REUTERSDSS_MAPPING_RULES;
	select count(*) into y from REUTERSDSS_MAPPING_RULES;
	exception WHEN NO_DATA_FOUND THEN

	x:=0;
	y:=0;

	WHEN OTHERS THEN 
	
	x:=0;
	y:=0;
	
	if (x <= 64 or y = 0) then
		execute immediate 'alter table REUTERSDSS_MAPPING_RULES modify RULE_GROUP varchar2(64)';
	end if;

end;
/
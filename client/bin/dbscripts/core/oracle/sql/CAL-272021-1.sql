declare
  x number :=0 ;
begin
	SELECT count(*) INTO x FROM user_tables WHERE table_name=upper('official_pl_config');
	IF x=0 THEN
    execute immediate 'create table official_pl_config (pl_config_id number not null , 
	config_name varchar2(126) not null, pricing_env_name varchar2(32) not null, 
	instance_type varchar2(32) not null, pl_time varchar2(32) not null, 
	pl_unit varchar2(32) not null, include_backdated_trade number not null, 
	methodology_config_name varchar2(256), time_zone varchar2(128), holidays varchar2(256), 
	version number, book_id number, pl_type varchar2(32) not null, 
	fx_rate_conversion varchar2(32) not null, is_fxtranslation number not null, 
	funding_level varchar2(32) not null, crystallization_level varchar2(32) not null, 
	is_cost_of_funding_pl number not null, year_end_month varchar2(126),
	pl_measures varchar2(2000),
	pricer_measures varchar2(2000),
	trade_attributes varchar2(2000),
	sell_off_measures varchar2(2000),
	fx_histo_rate_measures varchar2(2000),
	crystallized_measures varchar2(2000)) ';
	END IF;
end;
/
create table official_pl_config_back14_2 as select * from official_pl_config
;
begin
add_column_if_not_exists ('official_pl_config','pl_measures','varchar2(2000) null'); 
end;
/
begin
add_column_if_not_exists ('official_pl_config','pricer_measures','varchar2(2000) null');
end;
/
begin
add_column_if_not_exists ('official_pl_config','trade_attributes','varchar2(2000) null');
end;
/
begin
add_column_if_not_exists ('official_pl_config','sell_off_measures','varchar2(2000) null');
end;
/
begin
add_column_if_not_exists ('official_pl_config','fx_histo_rate_measures','varchar2(2000) null');
end;
/
begin
add_column_if_not_exists ('official_pl_config','crystallized_measures','varchar2(2000) null');
end;
/
        
create unique index idx_pl_confg on official_pl_config_attr(pl_config_id,attr_type,attr_value,user_specified_order)
;
create or replace procedure update_pl_variables1
is 
begin
declare 
cursor c1 is 
SELECT pl_config_id , 'plmeasure' as col_key, pl_measures  from official_pl_config where pl_measures is not null;
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      prd_seq number;
	  pl_config_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into pl_config_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		prd_seq := 0;
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  prd_seq := 1;
			 INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  prd_seq := prd_seq + 1;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parse_out_val, prd_seq);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  prd_seq:= prd_seq + 1 ;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
			end if;
			end loop;
			fetch c1 into pl_config_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_pl_variables1;
end;
/

drop procedure update_pl_variables1
;

create or replace procedure update_pl_variables2
is 
begin
declare 
cursor c1 is 
SELECT pl_config_id , 'sell_off_measure' as col_key, sell_off_measures from official_pl_config where sell_off_measures is not null;

      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      prd_seq number;
	  pl_config_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into pl_config_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		prd_seq := 0;
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  prd_seq := 1;
			 INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  prd_seq := prd_seq + 1;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parse_out_val, prd_seq);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  prd_seq:= prd_seq + 1 ;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
			end if;
			end loop;
			fetch c1 into pl_config_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_pl_variables2;
end;
/
drop procedure update_pl_variables2
;


create or replace procedure update_pl_variables3
is 
begin
declare 
cursor c1 is 
SELECT pl_config_id , 'crystallized_measure' as col_key, crystallized_measures  from official_pl_config where crystallized_measures is not null;
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      prd_seq number;
	  pl_config_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into pl_config_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		prd_seq := 0;
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  prd_seq := 1;
			 INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  prd_seq := prd_seq + 1;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parse_out_val, prd_seq);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  prd_seq:= prd_seq + 1 ;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
			end if;
			end loop;
			fetch c1 into pl_config_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_pl_variables3;
end;
/

drop procedure update_pl_variables3
;

create or replace procedure update_pl_variables4
is 
begin
declare 
cursor c1 is 
SELECT pl_config_id , 'trade_attribute' as col_key, trade_attributes  from official_pl_config where trade_attributes is not null;
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      prd_seq number;
	  pl_config_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into pl_config_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		prd_seq := 0;
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  prd_seq := 1;
			 INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  prd_seq := prd_seq + 1;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parse_out_val, prd_seq);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  prd_seq:= prd_seq + 1 ;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
			end if;
			end loop;
			fetch c1 into pl_config_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_pl_variables4;
end;
/
drop procedure update_pl_variables4
;
create or replace procedure update_pl_variables5
is 
begin
declare 
cursor c1 is 
SELECT pl_config_id , 'pricer_measure' as col_key, pricer_measures  from official_pl_config where pricer_measures is not null;
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      prd_seq number;
	  pl_config_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into pl_config_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		prd_seq := 0;
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  prd_seq := 1;
			 INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  prd_seq := prd_seq + 1;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parse_out_val, prd_seq);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  prd_seq:= prd_seq + 1 ;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
			end if;
			end loop;
			fetch c1 into pl_config_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_pl_variables5;
end;
/
drop procedure update_pl_variables5
;
create or replace procedure update_pl_variables6
is 
begin
declare 
cursor c1 is 
SELECT pl_config_id , 'fxHistoRate_measure' as col_key, fx_histo_rate_measures  from official_pl_config where fx_histo_rate_measures is not null;
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      prd_seq number;
	  pl_config_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into pl_config_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		prd_seq := 0;
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  prd_seq := 1;
			 INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  prd_seq := prd_seq + 1;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parse_out_val, prd_seq);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  prd_seq:= prd_seq + 1 ;
			 	INSERT INTO official_pl_config_attr(pl_config_id, attr_type, attr_value, user_specified_order) VALUES (pl_config_id, col_key, parseval, prd_seq);
			end if;
			end loop;
			fetch c1 into pl_config_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_pl_variables6;
end;
/

drop procedure update_pl_variables6
;

alter table official_pl_config drop column pl_measures 
;
alter table official_pl_config drop column pricer_measures 
;
alter table official_pl_config drop column trade_attributes
;
alter table official_pl_config drop column sell_off_measures
;
alter table official_pl_config drop column fx_histo_rate_measures
;
alter table official_pl_config drop column crystallized_measures
;
 
begin
  add_column_if_not_exists('risk_config_item', 'timestamp_format', 'varchar2(32)');
end;
/
update risk_config_item set timestamp_format = 'NoTimestamp' where append_timestamp_b = 0 and timestamp_format is null
;

UPDATE calypso_info
    SET major_version=14,
        minor_version=3,
        sub_version=0,
        patch_version='001',
        version_date=TO_DATE('29/05/2015','DD/MM/YYYY') 

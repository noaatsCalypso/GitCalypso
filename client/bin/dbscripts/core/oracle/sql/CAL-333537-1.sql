create or replace procedure upgrade_haircut_1
is 
begin
declare 
cursor c1 is 
SELECT name, sec_sd_filter from haircut order by name, sec_sd_filter;

cfg_name                varchar2(255);
haircut_rule_seed_id	  int;
inc                     int;
inc2                    int;
inc_plus_one            int;
sdf                     varchar2(255);
previous_sdf            varchar2(255);
previous_cfg            varchar2(255);
exist_haircut_rule_seed number;
haircut_rule_kv_cfg_count            int;
    
begin 
open c1; 
fetch c1 into cfg_name, sdf;
inc := 0;

DELETE FROM haircut_rule_kv_cfg;
DELETE FROM haircut_rule_kv;

SELECT count(*) into exist_haircut_rule_seed FROM calypso_seed WHERE seed_name = 'haircut_rule';
if exist_haircut_rule_seed = 0
  then
    haircut_rule_seed_id := 1000000;
    INSERT INTO calypso_seed(last_id, seed_name, seed_alloc_size) VALUES (1000000, 'haircut_rule', 500);
  else
    SELECT last_id into haircut_rule_seed_id FROM calypso_seed WHERE seed_name = 'haircut_rule';
    dbms_output.put_line('last_id ' || haircut_rule_seed_id);
end if;

while c1%FOUND 
loop
    dbms_output.put_line('haircut_rule_seed_id 1 ' || haircut_rule_seed_id);
    if previous_cfg = cfg_name then
      dbms_output.put_line('haircut_rule_seed_id 2 ' || haircut_rule_seed_id);
    else
      inc2 := 0;
      haircut_rule_seed_id := haircut_rule_seed_id + 500;
      INSERT INTO haircut_rule_kv_cfg(id, version, name, description) VALUES (haircut_rule_seed_id, 0, cfg_name, 'null');
      inc := haircut_rule_seed_id + 1;
      INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (haircut_rule_seed_id, 'definitions', 'TYPE_LIST', inc);
      INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (haircut_rule_seed_id, 'TENOR_MATURITY_DATE_INCLUSIVE', 'TYPE_BOOLEAN', 'false');
      INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (haircut_rule_seed_id, 'TotalHCCalculation', 'TYPE_STRING', 'ADDITION');
    end if;
    
    if (previous_sdf = sdf AND previous_cfg = cfg_name) then
      dbms_output.put_line('previous_sdf ' || previous_sdf);
    else
      inc_plus_one := inc + inc2 + 1;
      dbms_output.put_line('inc_plus_one ' || inc_plus_one);
      INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (inc, inc2, 'TYPE_LIST', inc_plus_one);
      INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (inc_plus_one, '0', 'TYPE_STRING', 'Haircut rule');
      INSERT INTO haircut_rule_kv(id, name, type, value) VALUES (inc_plus_one, '1', 'TYPE_STRING', sdf);
    end if;
	previous_cfg := cfg_name;
    inc2 := inc2 +1;
		previous_sdf := sdf;
		fetch c1 into cfg_name, sdf;
end loop;
UPDATE calypso_seed SET last_id = nvl(inc_plus_one,0) where seed_name = 'haircut_rule';
end;
end;
/
begin
upgrade_haircut_1;
end;
/
drop procedure upgrade_haircut_1
/

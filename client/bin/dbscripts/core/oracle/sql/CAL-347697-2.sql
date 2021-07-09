declare 
cnt number;
idx_name varchar(28);

begin
  execute immediate 'alter table ers_measure_config rename to ers_measure_config_back160';
  exception when others then null;
end;
/
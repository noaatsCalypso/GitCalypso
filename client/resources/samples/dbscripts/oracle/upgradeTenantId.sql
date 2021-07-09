create or replace procedure set_calypso_context(
	username varchar2,
	tenantid int,
	impersonatetenants varchar2)
as
begin
	dbms_session.set_identifier(tenantid);
end set_calypso_context;
;

declare
tenant_name_cnt int := 0;

CURSOR segarate_only_table_name_csr IS
SELECT table_name
FROM user_tab_cols
WHERE table_name not in ('CALYPSO_CACHE','CALYPSO_INFO','CALYPSO_SEED','SHAREDTABLES','TENANT')
AND column_name = 'TENANT_ID';

v_sql varchar(512);

begin
select count(*) into tenant_name_cnt from user_tab_cols where table_name = 'TENANT' and column_name = 'TENANT_NAME';
dbms_output.put_line(tenant_name_cnt);
if tenant_name_cnt = 0 
then
    drop_tenant_policies;
    v_sql := 'alter table tenant rename column tenant_id to tenant_name';
    execute immediate v_sql;
    v_sql := 'alter table tenant add (tenant_id int default 0 not null)';
    execute immediate v_sql;
    v_sql := 'update tenant t1 set tenant_id = 1000 + (select count(*) from tenant t2 where t1.rowid < t2.rowid)';
    execute immediate v_sql;
    for segarate_only_table in segarate_only_table_name_csr loop
        v_sql := 'ALTER TABLE '||segarate_only_table.table_name||' rename column tenant_id to tenant_name';
	dbms_output.put_line(v_sql);
        execute immediate v_sql;
        v_sql := 'ALTER TABLE '||segarate_only_table.table_name||' ADD (tenant_id int default 0 not null)';
	dbms_output.put_line(v_sql);
        execute immediate v_sql;
        v_sql := 'UPDATE '||segarate_only_table.table_name||
		' SET tenant_id = (SELECT tenant_id FROM tenant where '|| segarate_only_table.table_name||
		'.tenant_name = tenant.tenant_name)';
	dbms_output.put_line(v_sql);
	execute immediate v_sql;
   end loop;
   create_default_tenant_policies('calypso_cache,calypso_info,calypso_seed,sharedtables,tenant','','');
end if;
end;
;

declare
cursor uc_scr is
select table_name, constraint_name
from user_constraints
where constraint_type = 'P';
begin
for constraint in uc_scr loop
   execute immediate 'alter table ' || constraint.table_name ||
                ' drop constraint ' || constraint.constraint_name;
end loop;
end;
;

declare
cursor ui_scr is
select index_name
from user_ind_columns 
where column_name = 'TENANT_NAME';
begin
for indexToDrop in ui_scr loop
    execute immediate 'drop index ' || indexToDrop.index_name;
end loop;
end;
;

drop table exsp_var_setting_hist
;

drop table exsp_tsvar_sch_param_hist
;

drop table exsp_tsvar_samp_param_hist
;

drop table exsp_tsvar_exp_sch_hist 
;

drop table exsp_tsvar_hist
;

drop table exsp_qvar_override_hist
;

drop table exsp_avar_hist
;


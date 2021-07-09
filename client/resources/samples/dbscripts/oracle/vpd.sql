DECLARE
cnt number;
BEGIN
  select count(*) into cnt from user_tables where UPPER(table_name) = 'TENANT';
  if (cnt = 0)
  then
     EXECUTE IMMEDIATE ('CREATE TABLE tenant ( tenant_id numeric  NOT NULL,  tenant_name varchar2 (255) NOT NULL,  isshared numeric  NOT NULL )');
     EXECUTE IMMEDIATE ('ALTER TABLE tenant ADD CONSTRAINT pk_tenant1 PRIMARY KEY ( tenant_id )');
  end if;
END;
/
create or replace context calypsocontext using set_calypso_context;
/
create or replace procedure set_calypso_context(
	username varchar2,
	tenantname varchar2,
	impersonatetenants varchar2)
as
tenantId int;
begin
	select tenant_id into tenantId from tenant where tenant_name=tenantname;
	dbms_session.set_identifier(tenantid);
exception
	when no_data_found then
		raise_application_error(-20001,'no tenant available for the passed in tenant: ' || tenantname);
	when others then
		raise_application_error(-20001,'an application error');
end set_calypso_context;
/
show error
/

/*
   Used for segregate tables for both select and modify policy 
*/
create or replace function segregate_tenant_only_policy (
  schema_var in varchar2,
  table_var  in varchar2
)
return varchar2
is
  return_val varchar2(400);
  cnt number;
begin
   select count(*) into cnt from tenant 
   where tenant_id = SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') 
   and isshared > 0;

   if cnt > 0
   then
      /* A share tenant */
      raise_application_error (-20000, 'Share tenant '|| SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') || 'trys to access segregate table ' || table_var );
   end if;

  return_val := 'tenant_id = SYS_CONTEXT(''USERENV'',
				   ''CLIENT_IDENTIFIER'')';
  return return_val;
end segregate_tenant_only_policy;
/
show error
/

/*
   Used for segregate tables for both select and modify policy 
*/
create or replace function tenant_only_policy (
  schema_var in varchar2,
  table_var  in varchar2
)
return varchar2
is
  return_val varchar2(400);
begin
  return_val := 'tenant_id = SYS_CONTEXT(''USERENV'',
				   ''CLIENT_IDENTIFIER'')';
  return return_val;
end tenant_only_policy;
/
show error
/

/*
   For share table, no need for select policy.
   For modify policy, only share tenant can modify it. 
*/
create or replace function share_tenant_only_policy (
  schema_var in varchar2,
  table_var  in varchar2
)
return varchar2
is
   return_val varchar2(400);
   cnt number;
begin
   select count(*) into cnt from tenant 
   where tenant_id = SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') 
   and isshared > 0;

   if (cnt = 0)
   then
      /* regular tenant */
      raise_application_error (-20001, 'Regular tenant '|| SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') || ' trys to access share table ' || table_var );
   end if;

   return_val :=  'tenant_id = SYS_CONTEXT(''USERENV'',
				   ''CLIENT_IDENTIFIER'')';
  return return_val;
end share_tenant_only_policy;
/
show error
/

CREATE or replace TYPE char_table AS TABLE OF varchar2(50);
/

CREATE OR REPLACE FUNCTION tenant_list (p_in_list  IN  VARCHAR2)
  RETURN char_table
AS
  l_tab   char_table  := char_table ();
  l_text  VARCHAR2(32767) := p_in_list || ',';
  l_idx   NUMBER;
BEGIN
  LOOP
    l_idx := INSTR(l_text, ',');
    EXIT WHEN NVL(l_idx, 0) = 0;
    l_tab.extend;
    l_tab(l_tab.last) := TRIM(SUBSTR(l_text, 1, l_idx - 1));
    l_text := SUBSTR(l_text, l_idx + 1);
  END LOOP;

  RETURN l_tab;
END;
/
show error
/


/* Please make sure to grant execute on sys.dbms_rls to the schema owner. 
   Need to connect sys/calypso as sysdba first. */

CREATE OR REPLACE procedure drop_tenant_policies
AS
currentSchema varchar2(50);
CURSOR policy_scr IS
SELECT object_name, policy_name
FROM user_policies
WHERE policy_name IN ('MT_MODIFY', 'MT_SELECT');
BEGIN
    currentSchema := sys_context( 'userenv', 'current_schema' );
    FOR r_policy IN policy_scr LOOP
        dbms_rls.drop_policy (currentSchema, r_policy.object_name, r_policy.policy_name);
    END LOOP;
END;
/
show error
/

CREATE OR REPLACE procedure create_tenant_policy ( in_table_name varchar2,
	in_select_policy varchar2, in_modify_policy varchar2)
as
currentSchema varchar2(50);
cnt number;
begin
   currentSchema := sys_context( 'userenv', 'current_schema' );
   SELECT count(*) INTO cnt FROM user_policies WHERE object_name = in_table_name
   AND policy_name = 'MT_SELECT';
   if cnt > 0
   then
      dbms_rls.drop_policy (currentSchema, in_table_name,'MT_SELECT');
   end if;
   SELECT count(*) INTO cnt FROM user_policies WHERE object_name = in_table_name
   AND policy_name = 'MT_MODIFY';
   if cnt > 0
   then
      dbms_rls.drop_policy (currentSchema, in_table_name,'MT_MODIFY');
   end if;

   if in_select_policy is not null
   then
      dbms_rls.add_policy(currentSchema,  in_table_name, 'MT_SELECT', currentSchema,
   		   in_select_policy, 'SELECT');
   end if;

   if in_modify_policy is not null
   then
      dbms_rls.add_policy(currentSchema,  in_table_name, 'MT_MODIFY', currentSchema,
		   in_modify_policy, 'INSERT,UPDATE,DELETE');
   end if;
end;
/
show error
/


/* There are 4 kinds of tables,
   SYSTEM - Such as calypso_info, calypso_seed and tenant or any other tables we want to build 
            policy differently
   SHARE - All table share.
   TENANTONLY - Segarate table but share tenant can save (as segregate tenant) as well.
   SEGREGATE - The rest. Segerate tables and share tenants cannot save.
   

   System - no select/modify policies.
   Share - no select policy (so all can select). modify policy is share_tenant_only_policy.
   TenantOnly - select policy is tenant_only_policy. modify policy is tenant_only_policy.
   Segregate - select policy is segregate_tenant_only_policy. modify policy is segregate_tenant_only_policy.
*/

create or replace procedure create_default_tenant_policies (
in_system_tables varchar2,  in_tenantonly_tables varchar2,  in_share_tables varchar2)
as
system_tables char_table := null;
share_tables char_table := null;
tenantonly_tables char_table := null;
currentSchema varchar2(50);

CURSOR segarate_only_table_name_csr IS
SELECT table_name
FROM user_tab_cols
WHERE table_name not in (SELECT * from table(system_tables))
AND table_name not in (SELECT * FROM table(share_tables))
AND table_name not in (SELECT * FROM table(tenantonly_tables))
AND column_name = 'TENANT_ID' AND not EXISTS (
	SELECT * FROM user_policies 
	WHERE user_policies.object_name = user_tab_cols.table_name
	  AND (policy_name = 'MT_MODIFY' OR policy_name = 'MT_SELECT')
);

CURSOR share_table_name_csr IS
SELECT column_value FROM table(share_tables);

CURSOR tenantonly_table_name_csr IS
SELECT column_value FROM table(tenantonly_tables);

begin
   /* Build three tables, system_tables, tenantonly_tables and share_tables */

   if in_system_tables is not null
   then
      system_tables := tenant_list(upper(in_system_tables));
   else
      system_tables := char_table ();
   end if;

   if in_share_tables is not null
   then
      share_tables := tenant_list( upper(in_share_tables));
   else
      share_tables := char_table ();
   end if;

   if in_tenantonly_tables is not null
   then
      tenantonly_tables := tenant_list(upper(in_tenantonly_tables));
   else
      tenantonly_tables := char_table ();
   end if;

   for se_table_name in segarate_only_table_name_csr loop
      create_tenant_policy (se_table_name.table_name, 'segregate_tenant_only_policy', 'segregate_tenant_only_policy');
   end loop;

   for sh_table_name in share_table_name_csr loop
      create_tenant_policy (sh_table_name.column_value, null, 'share_tenant_only_policy');
   end loop;


   for to_table_name in tenantonly_table_name_csr loop
      create_tenant_policy (to_table_name.column_value,  'tenantonly_policy', 'tenantonly_policy');
   end loop;


end;
/
show error
/



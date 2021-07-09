
begin
   execute immediate 'drop package STRING_FNC';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/

begin
   execute immediate 'drop package TYPES';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/

begin
   execute immediate 'drop procedure sp_ers_save_scenario';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
/* sp_ers_update_trade deprecated but exist on code even if not used need first full removal */
/* sp_ers_makeofficial_trade deprecated but exist on code even if not used need first full removal */
begin
   execute immediate 'drop procedure sp_save_scenario_params';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure SP_DELETE_SCENARIO_SET';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure sp_save_mc_scenario_params';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure sp_ers_update_hierarchy_attr';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure sp_ers_update_batch';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/

begin
   execute immediate 'drop trigger tr_ins_ers_result';
exception when others then
   if sqlcode != -4080 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure DROP_TABLE_IF_EXISTS';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure sp_ers_arc_result';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/